# 2.2 — Foundation Models & The Transformer

## 1. What Is a Foundation Model?

Stanford's definition: *a model trained on broad data at scale and adaptable to a wide range of downstream tasks.*

### Characteristics
- **Large** — billions of parameters.
- **Pretrained** at great expense on web-scale corpora.
- **Adaptable** via prompting, RAG, or fine-tuning.
- **Multi-task** — one model handles translation, summarization, Q&A, classification, generation.
- **Often multimodal** in recent generations.

### Types of Foundation Models
| Type | Output | Examples |
|------|--------|----------|
| **Large Language Model (LLM)** | Text | Claude, Llama, GPT-4, Amazon Nova, Mistral |
| **Image / Vision** | Image or understanding | Stable Diffusion, Amazon Nova Canvas |
| **Multimodal** | Accept multiple modalities | Claude 3, Nova Pro, GPT-4V |
| **Embedding model** | Vectors | Titan Embeddings, Cohere Embed |
| **Code** | Code | Code Llama, Claude, Amazon Q Developer |
| **Video** | Video | Nova Reel |
| **Audio** | Speech / music | Polly Generative, MusicGen |

---

## 2. The Transformer — The Architecture Behind Modern AI

### 2.1 Why transformers won

Before transformers:
- RNNs / LSTMs — sequential; hard to parallelize; bad at very long dependencies.
- CNNs — good for local patterns, limited at long-range context.

Transformers introduced **self-attention** — every token can attend to every other in one step, massively parallelizable on GPUs.

### 2.2 Key Components (conceptual)

```
                       Input tokens
                            │
                            ▼
                      [Embeddings]
                            │
                 [Positional encoding]
                            │
          ┌─────── N × Transformer block ──────┐
          │   ┌────── Multi-head self-attn ─────┤
          │   │   Query, Key, Value projections │
          │   │   Attention weights             │
          │   │   Output projection             │
          │   └─────────────┬───────────────────┘
          │                 │
          │   ┌── Residual + LayerNorm ─────────┤
          │   │                                 │
          │   └── Feed-forward (MLP) ───────────┤
          │                 │                   │
          │   ┌── Residual + LayerNorm ─────────┤
          └─────────────────────────────────────┘
                            │
                     [Output projection]
                            │
                          Logits
```

### 2.3 Key terms

- **Self-attention** — each token creates Query (Q), Key (K), Value (V) vectors. For each token, compute similarity between its Q and every other token's K, softmax, then weighted sum over V. Output = contextualized representation.
- **Multi-head attention** — run attention h times in parallel with different projections so the model can attend to different kinds of relationships.
- **Positional encoding** — since attention has no built-in sense of order, inject position information (sinusoidal, learned, **RoPE** rotary).
- **Feed-forward** — per-token MLP.
- **Residual connections + LayerNorm** — help training.

### 2.4 Decoder vs Encoder vs Encoder-Decoder

| Style | Examples | Good at |
|-------|----------|---------|
| **Encoder-only** | BERT, RoBERTa | Understanding (classification, NER, embeddings) |
| **Decoder-only** | GPT, Claude, Llama | Text generation |
| **Encoder-Decoder** | T5, BART, original Transformer | Translation, summarization (seq-to-seq) |

Most modern LLMs used for chat are **decoder-only**.

---

## 3. Foundation Models Available on Amazon Bedrock

> Know the **families** and one or two key differentiators. You do not need to memorize every version.

### Amazon (first-party)
- **Amazon Nova** — multimodal family: Nova Micro (text only, fast), Nova Lite (multimodal, fast/cheap), Nova Pro (multimodal, high quality), Nova Canvas (image), Nova Reel (video), Nova Sonic (speech), Nova Premier. Long context.
- **Amazon Titan** — Titan Text (G1 Express, Lite), Titan Embeddings V2, Titan Multimodal Embeddings, Titan Image Generator. Good price/performance; often used for embeddings.

### Anthropic
- **Claude 3 family**: Haiku (fast/cheap), Sonnet (balanced), Opus (most capable), plus Claude 3.5/3.7 Sonnet and Claude 4. Known for long context, strong reasoning, safety, tool use. 200K+ token context.

### Meta
- **Llama 3.x** (8B, 70B, 405B) and **Llama 3.2** (incl. multimodal vision variants), **Llama 3.3** — open-weights models on Bedrock, good cost/quality, customizable.

### Mistral AI
- **Mistral 7B, Mistral Small/Large, Mixtral 8x7B** — efficient, open-source heritage.

### Cohere
- **Command R / R+** — optimized for RAG and tool use; **Embed** for multilingual embeddings; **Rerank** for retrieval refinement.

### AI21 Labs
- **Jamba 1.5 Mini / Large** — hybrid SSM-Transformer architecture, very long context.

### Stability AI
- **Stable Diffusion XL / Stable Image Core / Stable Image Ultra / SD3** — image generation.

### DeepSeek, Writer, TwelveLabs (video), Mistral embed, others
- Available via Bedrock or Bedrock Marketplace (more on this later).

### How to think about selection
See `03-Domain3/01-Model-Selection.md` for a deep dive.

---

## 4. Key Properties That Matter on the Exam

| Property | Why it matters |
|----------|----------------|
| **Context window size** | Long docs, RAG, conversation length |
| **Modality** | Multimodal for vision/doc tasks |
| **Latency & throughput** | User experience, cost |
| **Price (input / output tokens)** | TCO |
| **Accuracy / quality** | Task suitability |
| **Tool / function calling support** | Agents |
| **Fine-tuning support on Bedrock** | Customization |
| **Languages supported** | Global products |
| **Licensing** | Some models have commercial restrictions |
| **Region availability** | Data residency |

---

## 5. Open-source vs Proprietary Models

| Dimension | Open-source (Llama, Mistral) | Proprietary (Claude, Nova) |
|-----------|------------------------------|----------------------------|
| Cost | Lower per-token, self-host possible | Usually higher |
| Control | Full (can host anywhere, modify weights) | Limited |
| Performance | Generally strong, closing the gap | Often top-tier on benchmarks |
| Safety / alignment | You own it | Vendor-provided |
| IP / support | Community + you | Vendor support + SLAs |
| Customizability | Can fully fine-tune | Managed fine-tuning only |

On the exam: know that **Bedrock offers both** and you choose based on use case, budget, compliance.

---

## 6. Diffusion Models — How Image Generation Works (High Level)

1. Start with pure noise.
2. A U-Net (or transformer) is trained to **predict the noise** at each timestep.
3. Iteratively subtract predicted noise over T steps (denoise).
4. Condition the denoising on a text prompt embedding (CLIP-like encoder).

This is how Stable Diffusion and Amazon Nova Canvas / Titan Image Generator work under the hood.

---

## 7. Multimodal — How It Works

- Shared embedding space for text and images (or audio).
- Image encoder → visual tokens → concatenated with text tokens → fed into the LLM.
- The LLM then reasons over text + image jointly.

Use cases:
- Visual Q&A ("describe this chart").
- Document understanding (tables + text + images).
- Image captioning.
- UI generation (sketch → code).
- Safety moderation.

---

## 8. Emergent Behaviors

As models scale, unexpected capabilities appear:
- Few-shot learning
- Chain-of-thought reasoning
- Instruction following
- Tool use / function calling
- Code generation

These aren't explicitly trained — they emerge at a sufficient scale of data, parameters, and compute.

> Next — [2.3 Amazon Bedrock Deep Dive](./03-Amazon-Bedrock.md)
