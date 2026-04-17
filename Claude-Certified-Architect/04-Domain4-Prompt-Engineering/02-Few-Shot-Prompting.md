# D4.2 — Few-Shot Prompting

> **Golden rules**: 2 – 4 examples. Consistent format. At least one edge case. More than 6 → bloat.

## 1. What Few-Shot Prompting Is

Few-shot prompting provides **example input → output pairs** in the prompt to teach Claude the expected format, reasoning style, and edge-case handling **without changing the model itself**.

It sits between:
- **Zero-shot** — just describe the task.
- **Fine-tuning** — train a custom model.

Few-shot is the sweet spot: small lift in prompt length, big lift in reliability on ambiguous tasks.

## 2. The Golden Rules (memorize)

1. **2 – 4 examples** is optimal.
2. **All examples share the same output structure** — including field order, naming, casing.
3. **At least one example covers an edge case** (sarcasm, ambiguity, mixed sentiment).
4. **Diversity matters** — positive/negative, simple/complex, common/rare.
5. **> 6 examples adds cost without benefit** — diminishing returns + bloat.

## 3. When Few-Shot Is Most Valuable

| Task type | Few-shot helps? |
|---|---|
| Ambiguous classification (sentiment with sarcasm) | ✅ massively |
| Custom output formats | ✅ |
| Domain-specific reasoning | ✅ |
| Fuzzy boundaries between categories | ✅ |
| Clear, objective tasks ("extract the email") | ❌ — zero-shot works |
| Standard formats (JSON extraction with a schema) | ❌ — use `tool_use` schema |
| Single-step math | ❌ |

## 4. Structured Template

```
Classify customer reviews. Provide sentiment and reasoning.

Example 1 (clear positive):
Input:  "Absolutely love this product! Best purchase this year."
Output: {"sentiment": "positive", "confidence": "high",
         "reasoning": "Strong positive language, superlative."}

Example 2 (clear negative):
Input:  "Terrible experience. Product broke after 2 days."
Output: {"sentiment": "negative", "confidence": "high",
         "reasoning": "Explicit negative + product failure."}

Example 3 (ambiguous — mixed sentiment):
Input:  "Great features but battery life is disappointing."
Output: {"sentiment": "mixed", "confidence": "medium",
         "reasoning": "Positive on features, negative on battery."}

Example 4 (edge case — sarcasm):
Input:  "Oh wonderful, another update that breaks everything."
Output: {"sentiment": "negative", "confidence": "medium",
         "reasoning": "Sarcastic positive masking frustration."}

Now classify:
Input:  "{user_review}"
```

Four examples: positive, negative, mixed, sarcastic. Each uses the same three fields. Every edge the exam or real world could throw has an exemplar.

## 5. Why 2 – 4 — the Research

Anthropic and Anthropic-independent benchmarks converge on:
- **1 example**: slight improvement over zero-shot; sometimes worse if the example biases unexpectedly.
- **2 – 4 examples**: large gains on ambiguous classifications and custom formats.
- **5 – 6 examples**: marginal additional gains.
- **7 +**: degrades or plateaus; costs more tokens.

Exam answer: **2 – 4**. Memorize this range.

## 6. Format Consistency — the Silent Killer

If your four examples use different formats, you teach Claude to improvise:

```
Example 1: "positive" - high confidence
Example 2: sentiment=NEGATIVE, conf=high
Example 3: {"s":"mixed", "c":0.6}
Example 4: Mixed feelings overall.
```

Claude will pick **one** of the formats (probably the last or first), or **invent** a new one. Make every example look the same:

```
Example 1: {"sentiment": "positive", "confidence": "high", "reasoning": "..."}
Example 2: {"sentiment": "negative", "confidence": "high", "reasoning": "..."}
Example 3: {"sentiment": "mixed",    "confidence": "medium","reasoning": "..."}
Example 4: {"sentiment": "negative", "confidence": "medium","reasoning": "..."}
```

## 7. Edge-Case Coverage

Include at least one example that handles the **hardest** category you expect:

- Sentiment → include sarcasm.
- Document classification → include an "other" or novel type.
- Named entity recognition → include ambiguous entities (a person named "April").
- Code intent detection → include an intentionally confusing call.

The model generalizes from the edge cases you showed. If you never showed sarcasm, it won't handle sarcasm.

## 8. Few-Shot + `tool_use` — Combined Pattern

Few-shot examples can ride inside a `tool_use` extraction:

```
Here are examples of the extract_invoice tool being invoked correctly.

Example 1:
Input: "INVOICE #1234, Acme Corp, $500, due 2025-10-01"
→ extract_invoice({vendor_name:"Acme Corp", invoice_number:"1234", total:500, date:"2025-10-01", document_type:"standard_invoice"})

Example 2 (proforma):
Input: "PROFORMA #A-100, Beta Ltd, $0.00 (quote)"
→ extract_invoice({vendor_name:"Beta Ltd", invoice_number:"A-100", total:0.00, date:null, document_type:"proforma"})

Example 3 (edge case — unusual document type):
Input: "DEBIT NOTE #DN-001, Gamma Inc, $150"
→ extract_invoice({vendor_name:"Gamma Inc", invoice_number:"DN-001", total:150, date:null, document_type:"other", document_type_detail:"debit note"})

Now extract: {user_invoice}
```

Combines `tool_use` (structural guarantee) with few-shot (semantic grounding).

## 9. Diversity — Not Just Quantity

Four examples of positive sentiment, even with different phrasings, teach Claude less than one positive, one negative, one mixed, one sarcastic. Choose examples across:

- **Value** — positive / negative / neutral / mixed
- **Complexity** — simple / compound
- **Frequency** — common / rare
- **Source** — chat / email / review / SMS

## 10. Anti-Patterns

| Anti-pattern | Why wrong |
|---|---|
| One example only | Insufficient pattern signal; may bias |
| Seven or more examples | Bloat; marginal gain |
| All positive examples | Can't handle negatives well |
| Inconsistent output format | Claude improvises |
| No edge case | Fails on edge cases |
| Long prose examples for a short task | Wastes tokens |

## 11. Few-Shot in Production — Maintenance

Few-shot examples drift as your product evolves. Schedule quarterly reviews:
1. Are the examples still representative of real inputs?
2. Any new categories that lack examples?
3. Have old edge cases become so common they're no longer edges?

Treat few-shot examples as **test data** — version them, review them, and regenerate them when the distribution changes.

## 12. Exam Self-Check

1. *Optimal number of few-shot examples?*
   → 2 – 4.
2. *What mandatory property must the examples share?*
   → Consistent output format.
3. *A few-shot prompt has 10 examples. Problem?*
   → Bloat; diminishing returns.
4. *A classifier is missing sarcastic reviews. Fix?*
   → Add at least one sarcastic example.

---

### Key Takeaways
- ✅ 2 – 4 examples.
- ✅ Identical output format across examples.
- ✅ At least one edge case.
- ✅ Diverse across value, complexity, source.
- ❌ Don't ship with 0 or > 6 examples.
- ❌ Don't mix output formats.

Next → [`03-Tool-Use-Structured-Output.md`](03-Tool-Use-Structured-Output.md)
