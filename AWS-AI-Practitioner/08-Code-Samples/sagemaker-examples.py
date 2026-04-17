"""
Amazon SageMaker — End-to-End Example

Demonstrates:
  1. Training an XGBoost model with the built-in algorithm
  2. Deploying a real-time endpoint
  3. Invoking the endpoint
  4. Running a Clarify bias / explainability job (conceptual)
  5. Registering the model in the Model Registry

Prerequisites:
  - pip install sagemaker pandas
  - An execution role with access to S3 & SageMaker
  - Training data uploaded to S3 in CSV format
"""

import sagemaker
from sagemaker import image_uris
from sagemaker.inputs import TrainingInput
from sagemaker.estimator import Estimator
from sagemaker.model_monitor import DataCaptureConfig


ROLE = "arn:aws:iam::123456789012:role/SageMakerExecutionRole"
BUCKET = "my-ml-bucket"
PREFIX = "churn"
REGION = "us-east-1"

session = sagemaker.Session()


# 1. Train
def train() -> str:
    image = image_uris.retrieve(framework="xgboost", region=REGION, version="1.7-1")
    estimator = Estimator(
        image_uri=image,
        role=ROLE,
        instance_count=1,
        instance_type="ml.m5.xlarge",
        output_path=f"s3://{BUCKET}/{PREFIX}/output",
        use_spot_instances=True,
        max_run=3600,
        max_wait=7200,
        hyperparameters={
            "objective": "binary:logistic",
            "num_round": 200,
            "max_depth": 6,
            "eta": 0.2,
            "subsample": 0.8,
        },
    )
    estimator.fit(
        {
            "train": TrainingInput(
                f"s3://{BUCKET}/{PREFIX}/train/", content_type="text/csv"
            ),
            "validation": TrainingInput(
                f"s3://{BUCKET}/{PREFIX}/validation/", content_type="text/csv"
            ),
        }
    )
    return estimator.model_data


# 2. Deploy with data capture (so Model Monitor can work)
def deploy(model_data: str) -> str:
    from sagemaker.xgboost.model import XGBoostModel

    model = XGBoostModel(
        model_data=model_data,
        role=ROLE,
        framework_version="1.7-1",
    )
    predictor = model.deploy(
        initial_instance_count=1,
        instance_type="ml.m5.large",
        endpoint_name="churn-endpoint",
        data_capture_config=DataCaptureConfig(
            enable_capture=True,
            sampling_percentage=20,
            destination_s3_uri=f"s3://{BUCKET}/{PREFIX}/capture",
        ),
    )
    return predictor.endpoint_name


# 3. Invoke
def predict(endpoint_name: str, csv_row: str) -> str:
    import boto3
    rt = boto3.client("sagemaker-runtime", region_name=REGION)
    resp = rt.invoke_endpoint(
        EndpointName=endpoint_name,
        ContentType="text/csv",
        Body=csv_row.encode("utf-8"),
    )
    return resp["Body"].read().decode("utf-8")


# 4. Clarify — bias + explainability (conceptual)
def clarify_job(endpoint_name: str) -> None:
    from sagemaker.clarify import (
        SageMakerClarifyProcessor,
        DataConfig,
        ModelConfig,
        BiasConfig,
        ModelPredictedLabelConfig,
        SHAPConfig,
    )

    clarify = SageMakerClarifyProcessor(
        role=ROLE, instance_count=1, instance_type="ml.m5.xlarge"
    )

    data_config = DataConfig(
        s3_data_input_path=f"s3://{BUCKET}/{PREFIX}/validation/",
        s3_output_path=f"s3://{BUCKET}/{PREFIX}/clarify-output",
        label="churn",
        headers=["age", "gender", "tenure", "plan", "churn"],
        dataset_type="text/csv",
    )
    model_config = ModelConfig(
        model_name=endpoint_name,
        instance_type="ml.m5.large",
        instance_count=1,
        content_type="text/csv",
    )
    bias_config = BiasConfig(
        label_values_or_threshold=[1],
        facet_name="gender",
        facet_values_or_threshold=["female"],
    )
    clarify.run_bias(
        data_config=data_config,
        bias_config=bias_config,
        model_config=model_config,
        model_predicted_label_config=ModelPredictedLabelConfig(probability_threshold=0.5),
    )
    clarify.run_explainability(
        data_config=data_config,
        model_config=model_config,
        explainability_config=SHAPConfig(num_samples=200),
    )


# 5. Model Registry — register an approved model
def register_model(model_data: str, group_name: str = "churn-models") -> str:
    from sagemaker.xgboost.model import XGBoostModel

    model = XGBoostModel(
        model_data=model_data,
        role=ROLE,
        framework_version="1.7-1",
    )
    package = model.register(
        content_types=["text/csv"],
        response_types=["text/csv"],
        inference_instances=["ml.m5.large"],
        transform_instances=["ml.m5.xlarge"],
        model_package_group_name=group_name,
        approval_status="PendingManualApproval",
    )
    return package.model_package_arn


if __name__ == "__main__":
    # model_data = train()
    # endpoint_name = deploy(model_data)
    # print(predict(endpoint_name, "42,1,24,gold"))
    # clarify_job(endpoint_name)
    # register_model(model_data)
    print("Uncomment steps after configuring ROLE, BUCKET, and data.")
