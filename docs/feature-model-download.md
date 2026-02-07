# Feature Specification: Model Auto-Download

**Feature:** Optional model download from URLs
**Target Version:** v1.2
**Parent Spec:** `docs/system-spec.md`

---

## 1. Overview

Enhance the `--model` argument in the `run` command to support HTTP/HTTPS URLs. Downloading is **optional** and only occurs if the `--download-dir` argument is provided.

## 2. User Experience

### CLI Usage

```bash
# Download from Hugging Face using standard identifier
./lcm --run --model -hf unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M --download-dir ./models

# Download from direct URL
./lcm --run --model https://huggingface.co/.../model.gguf --download-dir ./my-models

# Download disabled (Default): Identifier or URL will fail if not a local file
./lcm --run --model https://huggingface.co/.../model.gguf
```

### Behavior

1.  **Hugging Face Detection:** If `--model` is followed by `-hf <repo>:<file>`.
    *   Resolves to: `https://huggingface.co/<repo>/resolve/main/<file>[.gguf]`
2.  **URL Detection:** If the `--model` argument starts with `http://` or `https://`.
3.  **Download Trigger:**
    *   If `--download-dir <path>` is provided:
        *   Extract filename from URL.
        *   If file exists in `<path>`, skip download and use local file.
        *   If file does NOT exist, download it to `<path>`.
    *   If `--download-dir` is NOT provided:
        *   Treat the URL as a standard file path (which will likely fail if it doesn't exist locally).
3.  **Idempotency:** Existing files in the target directory prevent re-downloading.

## 3. Configuration

| Argument | Description |
| :--- | :--- |
| `--download-dir <path>` | Enables auto-download and sets the target directory |