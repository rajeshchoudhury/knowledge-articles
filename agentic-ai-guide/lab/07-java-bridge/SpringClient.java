package com.example.helpdesk;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClient;

import java.util.Map;

/**
 * Minimal Spring Boot controller that forwards requests to the
 * Python agent sidecar running on http://localhost:8000.
 *
 * Expected request:
 *   POST /assist
 *   { "thread_id": "user-42", "message": "What is on P-1001?" }
 *
 * Expected response (from Python sidecar):
 *   { "reply": "...", "steps": 5 }
 */
@RestController
@RequestMapping("/assist")
public class SpringClient {

    private final RestClient agent = RestClient.builder()
            .baseUrl(System.getenv().getOrDefault("AGENT_URL", "http://localhost:8000"))
            .build();

    @PostMapping
    public Map<String, Object> ask(@RequestBody Map<String, String> body) {
        return agent.post()
                .uri("/chat")
                .contentType(MediaType.APPLICATION_JSON)
                .body(body)
                .retrieve()
                .body(Map.class);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        return agent.get().uri("/health").retrieve().body(Map.class);
    }
}
