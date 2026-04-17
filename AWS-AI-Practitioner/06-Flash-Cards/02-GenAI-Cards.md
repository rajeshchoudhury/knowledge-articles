# Flash Cards — Generative AI

| Q | A |
|---|---|
| Foundation Model | Large pretrained model adaptable to many downstream tasks |
| LLM | Foundation model for natural language |
| Transformer | Self-attention based architecture; basis of modern LLMs |
| Token | Chunk of text (~¾ word in English) processed by LLMs |
| Context window | Max tokens model can consider per call |
| Embedding | Numerical vector representing semantic meaning |
| Typical embedding use cases | Semantic search, RAG, clustering, classification |
| Temperature | Randomness of output; 0 = deterministic |
| Top-p | Nucleus sampling — cumulative probability cutoff |
| Top-k | Sample from top k most likely tokens |
| Max tokens | Cap on generated output length |
| Stop sequences | Strings that terminate generation |
| Decoder-only model | Generates text (GPT, Claude, Llama) |
| Encoder-only model | Understands text (BERT) |
| Diffusion model | Image generation by iteratively denoising |
| Multimodal model | Accepts multiple modalities (text + image) |
| Hallucination | Confident but incorrect output |
| Grounding | Anchor output in real reference material |
| Prompt engineering | Craft inputs to steer outputs |
| Zero-shot | No examples |
| Few-shot | A few examples in the prompt |
| Chain-of-thought | "Think step by step" reasoning |
| Self-consistency | Sample multiple CoTs and vote |
| ReAct | Reason → Act → Observe loop for agents |
| Prompt injection | Attack where user content overrides instructions |
| Indirect prompt injection | Malicious content inside retrieved docs |
| Jailbreak | Trick model into forbidden output |
| Defense for prompt injection | Guardrails, delimiters, structured outputs, least-privilege tools |
| Generative AI risks | Hallucination, bias, PII, IP, prompt injection, cost, staleness |
| Bedrock | Serverless FM API (multi-provider) |
| Bedrock model providers | Amazon Nova/Titan, Anthropic, Meta, Mistral, Cohere, Stability AI, AI21 |
| Converse API | Unified chat API across all Bedrock chat models |
| InvokeModelWithResponseStream | Streaming tokens |
| Bedrock Knowledge Bases | Managed RAG service |
| Bedrock Agents | Multi-step orchestration with tool use |
| Bedrock Guardrails | Safety filters (content, PII, topics, grounding, automated reasoning) |
| Bedrock Model Evaluation | Automatic + human + LLM-as-judge evaluation |
| Bedrock Flows | Visual workflow builder |
| Bedrock Prompt Management | Versioned prompt templates |
| Bedrock Studio | Web UI for building GenAI apps in IAM Identity Center |
| On-demand (Bedrock) | Pay per token, no commitment |
| Provisioned throughput (Bedrock) | Reserved Model Units at hourly cost; required for custom models |
| Batch inference (Bedrock) | Async bulk, 50% discount |
| Model Units (MUs) | Unit of reserved throughput |
| Fine-tune vs continued pretraining | Labeled pairs vs raw domain text |
| Model distillation | Train small student to mimic big teacher |
| RAG | Retrieve relevant docs, inject into prompt |
| Vector DB options on Bedrock | OpenSearch Serverless, Aurora PostgreSQL (pgvector), Neptune Analytics, Pinecone, Redis Enterprise, MongoDB Atlas |
| Embedding model options on Bedrock | Titan Embeddings V2, Titan Multimodal, Cohere Embed |
| Chunking strategies | Fixed, hierarchical, semantic, none, custom (Lambda) |
| Typical chunk size | 300–1000 tokens, 10–20% overlap |
| Hybrid search | Dense + sparse (BM25 + vector) |
| Reranking | Secondary refining step (Cohere Rerank, cross-encoder) |
| MMR | Max Marginal Relevance — diversify results |
| RetrieveAndGenerate | Managed RAG in one API call |
| Retrieve | Get chunks only |
| Agent components | Instructions + FM + Action Groups + KBs + Guardrails + Memory |
| Action group backend | Lambda (or RETURN_CONTROL) |
| User confirmation | Agent asks human before destructive action |
| Multi-agent collaboration | Supervisor + specialist agents |
| Guardrail content filter categories | Hate, insults, sexual, violence, misconduct, prompt attacks |
| Guardrail filter strengths | NONE / LOW / MEDIUM / HIGH |
| Guardrail sensitive info | PII detection + masking (built-in + custom regex) |
| Contextual grounding check | Grounding + relevance thresholds vs retrieved context |
| Automated Reasoning check | Formal logic validation vs policy |
| When to fine-tune | Persistent style/format/behavior change |
| When to use RAG | Fresh or private knowledge |
| When to use prompt only | Simple tasks, quickly iterating |
| RLHF | Reinforcement learning from human feedback |
| DPO | Direct Preference Optimization (alignment alternative to PPO) |
| LoRA | Low-rank adaptation — efficient fine-tune |
| Emergent capabilities | Few-shot, CoT, tool use at scale |
| Image generation Bedrock | Nova Canvas, Titan Image Generator, Stable Diffusion, Stable Image |
| Video generation Bedrock | Nova Reel |
| Nova families | Micro (text), Lite/Pro (multimodal), Canvas (image), Reel (video), Sonic (speech), Premier |
| Amazon Titan | Text Express/Lite, Embeddings V2, Multimodal Embeddings, Image Generator |
| Claude family | Haiku, Sonnet, Opus (Claude 3/3.5/3.7/4) |
| Llama family | 3, 3.1, 3.2 (+Vision), 3.3 |
| Cohere Command R+ | Strong at RAG & tool use |
| AI21 Jamba | Hybrid SSM+Transformer, long context |
| Mistral Large | Top Mistral general model |
| Data used to train Bedrock base FMs? | No — your data is not used to train FMs |
| Where does your Bedrock data stay? | In your account, in the region you choose |

