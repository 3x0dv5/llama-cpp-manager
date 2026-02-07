# Feature Specification: Run Optimization

**Author:** Rui Lima (ruilima.ai)
**Feature:** `--optimize` flag for `run` command
**Target Version:** v1.1
**Parent Spec:** `docs/system-spec.md`

---

## 1. Overview

The `--optimize` flag adds a parameter discovery mode to the existing `--run` command. Instead of executing the model for inference, it analyzes the host hardware and the provided model to recommend optimal runtime parameters for `llama.cpp`.

---

## 2. User Experience

### CLI Usage

```bash
lcm --run --model <path_to_model> --optimize
```

### Output Behavior

* **Success:** Prints a structured JSON object to `stdout` containing hardware details and recommended parameters.
* **Failure:** Prints error messages to `stderr` and exits with a non-zero status.

---

## 3. Functional Requirements

### 3.1 Parameter Discovery
* The `--optimize` flag MUST be used in conjunction with `--model`.
* When present, the `run` command MUST NOT execute the `llama-cli` binary for inference.
* The command MUST output recommendations based on the analysis logic defined in Section 4.

### 3.2 Hardware Analysis
The system must detect the following hardware capabilities:

* **CPU:**
  * Physical core count
  * Logical processor count
  * Architecture (x86_64, arm64)
  * NUMA nodes (if applicable/detectable)
* **GPU:**
  * Presence of NVIDIA CUDA or Apple Metal
  * VRAM capacity (in MB/GB)
* **Memory:**
  * Total System RAM (in MB/GB)

### 3.3 Model Analysis
* Validate the existence and readability of the `.gguf` file.
* Extract model metadata (size on disk) to estimate memory requirements.
* *Future Scope:* Parse GGUF header for exact parameter count and quantization level.

---

## 4. Optimization Logic

The following heuristics will be used to generate recommendations:

### 4.1 `--threads` (CPU Threads)
* **Logic:** Use physical core count minus 1 (to leave a core for system tasks).
* **Constraints:** Minimum 1, Maximum `nproc`.

### 4.2 `--n-gpu-layers` (GPU Offload)
* **Logic:**
  * **Metal (MacOS):** Default to `999` (offload all) if VRAM > Model Size * 1.2 (overhead). Otherwise, scale linearly.
  * **CUDA (Linux):** Similar logic to Metal, ensuring model fits in VRAM.
  * **CPU Only:** Set to `0`.

### 4.3 `--n-ctx` (Context Window)
* **Logic:** Recommend `4096` as a safe default for most Llama 2/3 models, or read from model metadata if/when feasible.

### 4.4 `--batch-size`
* **Logic:**
  * **GPU:** `512` if VRAM is sufficient.
  * **CPU:** `256` or lower to preserve cache locality.

### 4.5 `--mlock` (Memory Locking)
* **Logic:** Recommend `true` if (System RAM) > (Model Size * 1.5). Prevents swapping.

### 4.6 `--no-mmap`
* **Logic:** Recommend `true` if loading the model via `mmap` is likely to cause I/O stuttering (e.g., slow HDD), though default is usually fine. (Optional for v1).

---

## 5. Output Format

The output MUST be valid JSON to allow for piping into other tools.

```json
{
  "hardware": {
    "cpu_cores_physical": 8,
    "cpu_cores_logical": 16,
    "ram_total_gb": 32,
    "gpu_type": "CUDA",
    "gpu_vram_gb": 12
  },
  "model": {
    "path": "/path/to/model.gguf",
    "size_gb": 4.8
  },
  "recommended_params": {
    "--threads": 7,
    "--n-gpu-layers": 35,
    "--n-ctx": 4096,
    "--batch-size": 512,
    "--mlock": true
  },
  "rationale": [
    "Detected 8 physical cores; reserving 1 for system.",
    "Model fits entirely within 12GB VRAM; offloading all layers."
  ]
}
```

---

## 6. Error Handling

* **Missing Model:** If `--model` is not provided, exit with error.
* **Hardware Detection Failure:** Warn to `stderr` and provide safe defaults (e.g., CPU-only mode).
* **Invalid Model File:** Exit with error if file does not exist or is unreadable.

---

## 7. Integration Plan

1.  **Modify `run` argument parsing:** Add check for `--optimize`.
2.  **Implement `detect_hardware()` function:** Encapsulate CPU/GPU/RAM detection logic.
3.  **Implement `analyze_model()` function:** Basic file size check.
4.  **Implement `generate_recommendations()` function:** Apply heuristics.
5.  **Output JSON:** Format and print result.
