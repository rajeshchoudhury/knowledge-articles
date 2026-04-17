"""
AWS Solutions Architect Professional – Cross-Account Operations with boto3

KEY EXAM TOPICS DEMONSTRATED:
  - STS AssumeRole for cross-account access
  - Session chaining (multi-hop role assumption: A -> B -> C)
  - S3 cross-account object copy with KMS re-encryption
  - KMS cross-account encryption/decryption
  - DynamoDB cross-account operations
  - CloudFormation stack creation in remote accounts
  - Cross-account SNS publishing
  - Comprehensive error handling and exponential backoff retry

EXAM TIPS:
  - Cross-account access requires BOTH:
    1. Trust policy on the target role (allows the source principal to assume)
    2. IAM policy on the source principal (allows sts:AssumeRole on target)
  - STS temporary credentials expire (default 1 hour, max 12 hours for IAM users,
    1 hour for role chaining)
  - External ID prevents the "confused deputy" problem in third-party access
  - Session policies can further restrict assumed role permissions
"""

import json
import time
import logging
from typing import Optional
from datetime import datetime, timezone

import boto3
from botocore.exceptions import ClientError, BotoCoreError
from botocore.config import Config

# ---------------------------------------------------------------------------
# Logging Configuration
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger("cross-account-ops")

# Retry configuration with exponential backoff
RETRY_CONFIG = Config(
    retries={"max_attempts": 3, "mode": "adaptive"},
    connect_timeout=5,
    read_timeout=10,
)


# ===========================================================================
# Cross-Account Session Management
# ===========================================================================

def assume_role(
    role_arn: str,
    session_name: str,
    external_id: Optional[str] = None,
    duration_seconds: int = 3600,
    session_policy: Optional[str] = None,
    source_session: Optional[boto3.Session] = None,
) -> boto3.Session:
    """
    Assume an IAM role and return a boto3 Session with temporary credentials.

    EXAM TIP: AssumeRole returns temporary credentials (access key, secret key,
    session token) valid for the specified duration.  The session_name appears
    in CloudTrail logs, making it valuable for auditing which principal
    performed which actions.

    Args:
        role_arn: ARN of the role to assume (e.g., arn:aws:iam::123456789012:role/CrossAccountRole)
        session_name: Identifier for the session (appears in CloudTrail)
        external_id: Shared secret to prevent confused deputy attacks
        duration_seconds: Credential validity (900-43200 for IAM users, max 3600 for chained roles)
        session_policy: Optional inline policy to further restrict the assumed session
        source_session: Existing session to chain from (for multi-hop assumption)

    Returns:
        boto3.Session configured with temporary cross-account credentials
    """
    if source_session:
        sts_client = source_session.client("sts", config=RETRY_CONFIG)
    else:
        sts_client = boto3.client("sts", config=RETRY_CONFIG)

    assume_params = {
        "RoleArn": role_arn,
        "RoleSessionName": session_name,
        "DurationSeconds": duration_seconds,
    }

    if external_id:
        assume_params["ExternalId"] = external_id

    if session_policy:
        assume_params["Policy"] = session_policy

    try:
        response = sts_client.assume_role(**assume_params)
        credentials = response["Credentials"]

        session = boto3.Session(
            aws_access_key_id=credentials["AccessKeyId"],
            aws_secret_access_key=credentials["SecretAccessKey"],
            aws_session_token=credentials["SessionToken"],
        )

        assumed_identity = sts_client.get_caller_identity()
        logger.info(
            "Assumed role %s (Account: %s, Session: %s, Expires: %s)",
            role_arn,
            response["AssumedRoleUser"]["Arn"],
            session_name,
            credentials["Expiration"].isoformat(),
        )
        return session

    except ClientError as e:
        error_code = e.response["Error"]["Code"]
        if error_code == "AccessDenied":
            logger.error(
                "Access denied assuming %s. Verify: "
                "1) Trust policy allows your principal, "
                "2) Your IAM policy allows sts:AssumeRole on this ARN, "
                "3) External ID matches (if required)",
                role_arn,
            )
        elif error_code == "MalformedPolicyDocument":
            logger.error("Session policy is malformed: %s", session_policy)
        elif error_code == "RegionDisabledException":
            logger.error("STS is disabled in the target region")
        raise


def chained_assume_role(
    role_chain: list[dict],
    initial_session: Optional[boto3.Session] = None,
) -> boto3.Session:
    """
    Perform multi-hop role assumption through a chain of roles.

    EXAM TIP: Role chaining (A assumes B, B assumes C) has these constraints:
      - Maximum session duration is 1 hour (cannot be extended)
      - Each hop adds latency and is a potential point of failure
      - CloudTrail logs each hop independently for full audit trail
      - Common pattern: Dev Account -> Shared Services -> Production

    Args:
        role_chain: List of dicts with keys: role_arn, session_name, external_id (optional)
        initial_session: Starting session (defaults to local credentials)

    Returns:
        Final boto3.Session after traversing the entire chain
    """
    current_session = initial_session

    for i, hop in enumerate(role_chain):
        logger.info("Role chain hop %d/%d: %s", i + 1, len(role_chain), hop["role_arn"])
        current_session = assume_role(
            role_arn=hop["role_arn"],
            session_name=hop.get("session_name", f"chain-hop-{i+1}"),
            external_id=hop.get("external_id"),
            duration_seconds=3600,  # Max for chained roles
            source_session=current_session,
        )

    return current_session


# ===========================================================================
# S3 Cross-Account Operations
# ===========================================================================

def cross_account_s3_copy(
    source_bucket: str,
    source_key: str,
    dest_bucket: str,
    dest_key: str,
    dest_session: boto3.Session,
    dest_kms_key_id: Optional[str] = None,
) -> dict:
    """
    Copy an S3 object to a bucket in another account with optional KMS re-encryption.

    EXAM TIP: Cross-account S3 copy requires:
      1. Source bucket policy allows s3:GetObject for the destination account/role
      2. Destination role has s3:PutObject on the destination bucket
      3. If KMS-encrypted: destination role needs kms:Decrypt on source key
         AND kms:GenerateDataKey on destination key
      4. Bucket owner enforced (recommended) eliminates ACL complexity

    Args:
        source_bucket: Source S3 bucket name
        source_key: Source object key
        dest_bucket: Destination S3 bucket name
        dest_key: Destination object key
        dest_session: boto3 Session with credentials for the destination account
        dest_kms_key_id: KMS key ID in destination account for re-encryption
    """
    s3_client = dest_session.client("s3", config=RETRY_CONFIG)

    copy_source = {"Bucket": source_bucket, "Key": source_key}
    extra_args = {}

    if dest_kms_key_id:
        extra_args["ServerSideEncryption"] = "aws:kms"
        extra_args["SSEKMSKeyId"] = dest_kms_key_id

    try:
        response = s3_client.copy_object(
            Bucket=dest_bucket,
            Key=dest_key,
            CopySource=copy_source,
            **extra_args,
        )
        logger.info(
            "Copied s3://%s/%s -> s3://%s/%s (KMS: %s)",
            source_bucket, source_key, dest_bucket, dest_key,
            dest_kms_key_id or "default",
        )
        return response

    except ClientError as e:
        error_code = e.response["Error"]["Code"]
        if error_code == "AccessDenied":
            logger.error(
                "Access denied. Check: source bucket policy, destination IAM policy, "
                "and KMS key policies for both source and destination keys."
            )
        elif error_code == "NoSuchBucket":
            logger.error("Bucket not found. Verify bucket names and region.")
        raise


def cross_account_s3_sync(
    source_bucket: str,
    prefix: str,
    dest_bucket: str,
    dest_session: boto3.Session,
    dest_kms_key_id: Optional[str] = None,
) -> int:
    """
    Sync all objects under a prefix from source to destination bucket.

    Returns:
        Count of objects copied
    """
    s3_source = boto3.client("s3", config=RETRY_CONFIG)
    copied = 0
    paginator = s3_source.get_paginator("list_objects_v2")

    for page in paginator.paginate(Bucket=source_bucket, Prefix=prefix):
        for obj in page.get("Contents", []):
            cross_account_s3_copy(
                source_bucket=source_bucket,
                source_key=obj["Key"],
                dest_bucket=dest_bucket,
                dest_key=obj["Key"],
                dest_session=dest_session,
                dest_kms_key_id=dest_kms_key_id,
            )
            copied += 1

    logger.info("Synced %d objects from s3://%s/%s to s3://%s", copied, source_bucket, prefix, dest_bucket)
    return copied


# ===========================================================================
# KMS Cross-Account Encryption/Decryption
# ===========================================================================

def cross_account_encrypt(
    plaintext: bytes,
    key_id: str,
    target_session: boto3.Session,
    encryption_context: Optional[dict] = None,
) -> bytes:
    """
    Encrypt data using a KMS key in another account.

    EXAM TIP: For cross-account KMS usage:
      1. Key policy in the key's account must grant kms:Encrypt to the caller
      2. Caller's IAM policy must allow kms:Encrypt on the key ARN
      3. Encryption context (key-value pairs) is logged in CloudTrail and
         provides additional authentication data (AAD).  If used for encrypt,
         the SAME context must be provided for decrypt.
    """
    kms_client = target_session.client("kms", config=RETRY_CONFIG)

    params = {"KeyId": key_id, "Plaintext": plaintext}
    if encryption_context:
        params["EncryptionContext"] = encryption_context

    try:
        response = kms_client.encrypt(**params)
        logger.info("Encrypted %d bytes with key %s", len(plaintext), key_id)
        return response["CiphertextBlob"]
    except ClientError as e:
        if e.response["Error"]["Code"] == "DisabledException":
            logger.error("KMS key %s is disabled", key_id)
        raise


def cross_account_decrypt(
    ciphertext: bytes,
    target_session: boto3.Session,
    encryption_context: Optional[dict] = None,
) -> bytes:
    """
    Decrypt data that was encrypted with a cross-account KMS key.

    EXAM TIP: The key ID is embedded in the ciphertext blob, so you don't
    need to specify it for decryption.  The caller only needs kms:Decrypt
    permission on the key that was used for encryption.
    """
    kms_client = target_session.client("kms", config=RETRY_CONFIG)

    params = {"CiphertextBlob": ciphertext}
    if encryption_context:
        params["EncryptionContext"] = encryption_context

    try:
        response = kms_client.decrypt(**params)
        logger.info("Decrypted data using key %s", response["KeyId"])
        return response["Plaintext"]
    except ClientError as e:
        if e.response["Error"]["Code"] == "InvalidCiphertextException":
            logger.error(
                "Decryption failed. Verify encryption context matches "
                "and the correct key policy grants are in place."
            )
        raise


# ===========================================================================
# DynamoDB Cross-Account Operations
# ===========================================================================

def cross_account_dynamodb_query(
    table_name: str,
    key_condition: str,
    expression_values: dict,
    target_session: boto3.Session,
    index_name: Optional[str] = None,
    region: str = "us-east-1",
) -> list[dict]:
    """
    Query a DynamoDB table in another account.

    EXAM TIP: Cross-account DynamoDB access requires the target account role
    to have dynamodb:Query permission.  For Global Tables, you can query the
    local replica directly (lower latency) without cross-account access.
    """
    dynamodb = target_session.resource("dynamodb", region_name=region, config=RETRY_CONFIG)
    table = dynamodb.Table(table_name)

    query_params = {
        "KeyConditionExpression": key_condition,
        "ExpressionAttributeValues": expression_values,
    }
    if index_name:
        query_params["IndexName"] = index_name

    try:
        items = []
        response = table.query(**query_params)
        items.extend(response.get("Items", []))

        while "LastEvaluatedKey" in response:
            query_params["ExclusiveStartKey"] = response["LastEvaluatedKey"]
            response = table.query(**query_params)
            items.extend(response.get("Items", []))

        logger.info("Queried %d items from %s in remote account", len(items), table_name)
        return items

    except ClientError as e:
        if e.response["Error"]["Code"] == "ResourceNotFoundException":
            logger.error("Table %s not found in remote account", table_name)
        raise


def cross_account_dynamodb_batch_write(
    table_name: str,
    items: list[dict],
    target_session: boto3.Session,
    region: str = "us-east-1",
) -> int:
    """
    Batch write items to a DynamoDB table in another account.
    Handles unprocessed items with exponential backoff.

    EXAM TIP: BatchWriteItem supports up to 25 items per call.
    Unprocessed items should be retried with exponential backoff
    (indicates provisioned throughput exceeded).
    """
    dynamodb = target_session.client("dynamodb", region_name=region, config=RETRY_CONFIG)
    written = 0
    batch_size = 25

    for i in range(0, len(items), batch_size):
        batch = items[i:i + batch_size]
        request_items = {
            table_name: [{"PutRequest": {"Item": item}} for item in batch]
        }

        retries = 0
        while request_items:
            try:
                response = dynamodb.batch_write_item(RequestItems=request_items)
                unprocessed = response.get("UnprocessedItems", {})

                written += len(batch) - len(unprocessed.get(table_name, []))

                if unprocessed:
                    request_items = unprocessed
                    retries += 1
                    sleep_time = min(2 ** retries, 32)
                    logger.warning(
                        "Retrying %d unprocessed items (attempt %d, backoff %ds)",
                        len(unprocessed.get(table_name, [])), retries, sleep_time,
                    )
                    time.sleep(sleep_time)
                else:
                    break

            except ClientError as e:
                if e.response["Error"]["Code"] == "ProvisionedThroughputExceededException":
                    retries += 1
                    sleep_time = min(2 ** retries, 32)
                    logger.warning("Throughput exceeded, backing off %ds", sleep_time)
                    time.sleep(sleep_time)
                else:
                    raise

    logger.info("Wrote %d items to %s in remote account", written, table_name)
    return written


# ===========================================================================
# CloudFormation Cross-Account Stack Operations
# ===========================================================================

def create_stack_in_account(
    stack_name: str,
    template_url: str,
    parameters: dict,
    target_session: boto3.Session,
    capabilities: Optional[list] = None,
    region: str = "us-east-1",
) -> str:
    """
    Create a CloudFormation stack in another account and wait for completion.

    EXAM TIP: Cross-account CloudFormation deployment patterns:
      1. StackSets (preferred for org-wide deployment)
      2. AssumeRole + CreateStack (this approach, for targeted deployments)
      3. CodePipeline cross-account action (for CI/CD pipelines)
    Capabilities like CAPABILITY_IAM must be explicitly acknowledged.

    Returns:
        Stack ID of the created stack
    """
    cfn_client = target_session.client("cloudformation", region_name=region, config=RETRY_CONFIG)

    cfn_params = [
        {"ParameterKey": k, "ParameterValue": v} for k, v in parameters.items()
    ]

    try:
        response = cfn_client.create_stack(
            StackName=stack_name,
            TemplateURL=template_url,
            Parameters=cfn_params,
            Capabilities=capabilities or ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"],
            OnFailure="ROLLBACK",
            Tags=[
                {"Key": "ManagedBy", "Value": "cross-account-automation"},
                {"Key": "CreatedAt", "Value": datetime.now(timezone.utc).isoformat()},
            ],
        )
        stack_id = response["StackId"]
        logger.info("Creating stack %s (ID: %s)", stack_name, stack_id)

        waiter = cfn_client.get_waiter("stack_create_complete")
        waiter.wait(
            StackName=stack_id,
            WaiterConfig={"Delay": 30, "MaxAttempts": 60},
        )

        logger.info("Stack %s creation complete", stack_name)
        return stack_id

    except ClientError as e:
        error_code = e.response["Error"]["Code"]
        if error_code == "AlreadyExistsException":
            logger.warning("Stack %s already exists", stack_name)
            return cfn_client.describe_stacks(StackName=stack_name)["Stacks"][0]["StackId"]
        raise


# ===========================================================================
# Cross-Account SNS Publishing
# ===========================================================================

def publish_cross_account_sns(
    topic_arn: str,
    message: str,
    subject: str,
    target_session: boto3.Session,
    message_attributes: Optional[dict] = None,
) -> str:
    """
    Publish a message to an SNS topic in another account.

    EXAM TIP: Cross-account SNS publishing requires the topic policy to
    allow sns:Publish from the source account/role.  Alternatively, the
    source account can subscribe to the topic if the topic policy allows
    sns:Subscribe.  For fan-out across accounts, use EventBridge with
    cross-account event bus.

    Returns:
        MessageId of the published message
    """
    sns_client = target_session.client("sns", config=RETRY_CONFIG)

    publish_params = {
        "TopicArn": topic_arn,
        "Message": message,
        "Subject": subject,
    }

    if message_attributes:
        publish_params["MessageAttributes"] = {
            k: {"DataType": "String", "StringValue": v}
            for k, v in message_attributes.items()
        }

    try:
        response = sns_client.publish(**publish_params)
        logger.info("Published message %s to %s", response["MessageId"], topic_arn)
        return response["MessageId"]

    except ClientError as e:
        if e.response["Error"]["Code"] == "AuthorizationError":
            logger.error(
                "Not authorized to publish to %s. "
                "Check the SNS topic policy and IAM permissions.",
                topic_arn,
            )
        raise


# ===========================================================================
# Utility: Retry with Exponential Backoff
# ===========================================================================

def retry_with_backoff(func, max_retries: int = 5, base_delay: float = 1.0):
    """
    Generic retry wrapper with exponential backoff and jitter.

    EXAM TIP: AWS SDKs have built-in retry logic, but for custom
    orchestration (e.g., waiting for eventually-consistent reads),
    implement application-level retries with jitter to avoid
    thundering herd problems.
    """
    import random

    for attempt in range(max_retries):
        try:
            return func()
        except (ClientError, BotoCoreError) as e:
            if attempt == max_retries - 1:
                raise

            delay = base_delay * (2 ** attempt) + random.uniform(0, 1)
            logger.warning(
                "Attempt %d/%d failed: %s. Retrying in %.1fs",
                attempt + 1, max_retries, str(e), delay,
            )
            time.sleep(delay)


# ===========================================================================
# Example Usage / Main
# ===========================================================================

def main():
    """Demonstrate cross-account operations."""

    # --- 1. Simple cross-account role assumption ---
    prod_session = assume_role(
        role_arn="arn:aws:iam::111111111111:role/CrossAccountAdmin",
        session_name="admin-deployment",
        external_id="unique-external-id-12345",
    )

    # --- 2. Multi-hop role chain: Dev -> SharedServices -> Production ---
    prod_via_shared = chained_assume_role(
        role_chain=[
            {
                "role_arn": "arn:aws:iam::222222222222:role/SharedServicesRole",
                "session_name": "dev-to-shared",
            },
            {
                "role_arn": "arn:aws:iam::333333333333:role/ProductionDeployRole",
                "session_name": "shared-to-prod",
                "external_id": "prod-access-token",
            },
        ]
    )

    # --- 3. Cross-account S3 copy with KMS re-encryption ---
    cross_account_s3_copy(
        source_bucket="dev-data-bucket",
        source_key="exports/2024/report.csv",
        dest_bucket="prod-data-bucket",
        dest_key="imports/2024/report.csv",
        dest_session=prod_session,
        dest_kms_key_id="arn:aws:kms:us-east-1:111111111111:key/prod-key-id",
    )

    # --- 4. Cross-account KMS encrypt/decrypt ---
    ciphertext = cross_account_encrypt(
        plaintext=b"sensitive data payload",
        key_id="arn:aws:kms:us-east-1:111111111111:key/shared-key-id",
        target_session=prod_session,
        encryption_context={"purpose": "cross-account-demo", "env": "production"},
    )

    plaintext = cross_account_decrypt(
        ciphertext=ciphertext,
        target_session=prod_session,
        encryption_context={"purpose": "cross-account-demo", "env": "production"},
    )

    # --- 5. Cross-account CloudFormation deployment ---
    stack_id = create_stack_in_account(
        stack_name="prod-monitoring-stack",
        template_url="https://s3.amazonaws.com/templates/monitoring.yaml",
        parameters={
            "Environment": "production",
            "AlertEmail": "ops@example.com",
        },
        target_session=prod_session,
    )

    # --- 6. Cross-account SNS notification ---
    publish_cross_account_sns(
        topic_arn="arn:aws:sns:us-east-1:111111111111:deployment-notifications",
        message=json.dumps({
            "event": "deployment_complete",
            "stack_id": stack_id,
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }),
        subject="Production Deployment Complete",
        target_session=prod_session,
        message_attributes={"environment": "production", "severity": "info"},
    )

    logger.info("All cross-account operations completed successfully")


if __name__ == "__main__":
    main()
