package com.example.helpdesk;

import dev.langchain4j.agent.tool.Tool;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.bedrock.BedrockChatModel;
import dev.langchain4j.service.AiServices;
import software.amazon.awssdk.regions.Region;

import java.util.HashMap;
import java.util.Map;

/**
 * Pure-Java agent using LangChain4j.
 *
 * Build (Gradle):
 *   implementation 'dev.langchain4j:langchain4j:0.36.2'
 *   implementation 'dev.langchain4j:langchain4j-bedrock:0.36.2'
 *
 * Run (requires AWS creds + Bedrock model access):
 *   java -cp ... com.example.helpdesk.LangChain4jAgent
 */
public class LangChain4jAgent {

    /** Tools are just @Tool-annotated methods on a plain bean. */
    static class PolicyTools {
        private final Map<String, Map<String, Object>> db = new HashMap<>();

        PolicyTools() {
            db.put("P-1001", Map.of("holder", "Alice", "type", "AUTO", "sumInsured", 500_000));
            db.put("P-1002", Map.of("holder", "Bob",   "type", "HOME", "sumInsured", 2_000_000));
        }

        @Tool("Return the policy record for a given policy_id, e.g. P-1001")
        public Map<String, Object> getPolicy(String policyId) {
            return db.getOrDefault(policyId, Map.of("error", "not_found"));
        }

        @Tool("Compute annual premium. type must be AUTO|HOME|LIFE. sumInsured in rupees.")
        public Map<String, Object> computePremium(String type, double sumInsured) {
            Map<String, Integer> rate = Map.of("AUTO", 1200, "HOME", 350, "LIFE", 800);
            if (!rate.containsKey(type.toUpperCase())) {
                return Map.of("error", "unknown type " + type);
            }
            double premium = (sumInsured / 100_000.0) * rate.get(type.toUpperCase());
            return Map.of("premium", premium);
        }
    }

    public interface HelpdeskAssistant {
        String chat(String userMessage);
    }

    public static void main(String[] args) {
        var model = BedrockChatModel.builder()
                .modelId("us.anthropic.claude-sonnet-4-5-20250929-v1:0")
                .region(Region.US_EAST_1)
                .build();

        HelpdeskAssistant assistant = AiServices.builder(HelpdeskAssistant.class)
                .chatLanguageModel(model)
                .tools(new PolicyTools())
                .chatMemory(MessageWindowChatMemory.withMaxMessages(20))
                .systemMessageProvider(id ->
                        "You are an insurance helpdesk. Always use tools for policy data.")
                .build();

        System.out.println(assistant.chat("What is on policy P-1001?"));
        System.out.println(assistant.chat("Compute the HOME premium for sum insured 2,000,000."));
    }
}
