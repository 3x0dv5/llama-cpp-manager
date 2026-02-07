# System Specification

## llama-cpp-manager

**Repository:** `llama-cpp-manager`
**License:** MIT
**Primary Platforms:** Linux (Ubuntu), MacOS
**Primary Target:** Automated installation, update, and build management for `llama.cpp`

---

## 1. Overview

`llama-cpp-manager` provides a **repeatable, idempotent, user-local** mechanism to install, update, and build the upstream `llama.cpp` project on Linux and MacOS systems.

The project acts strictly as a **manager** for `llama.cpp`:

* It does not fork or modify upstream code
* It does not bundle models
* It does not install background services
* It does not replace system package managers

---

## 2. Scope & Goals

### In Scope

* Install required build dependencies (via `apt` on Linux, `brew` on MacOS)
* Clone and update `llama.cpp`
* Auto-detect hardware acceleration:
    * NVIDIA CUDA (Linux)
    * Apple Metal (MacOS)
* Build `llama.cpp` using CMake
* Expose executables via user-local symlinks
* Provide a minimal runtime sanity check

### Out of Scope

* Model lifecycle management
* Runtime orchestration or serving frameworks
* Windows support (Native or WSL2)
* Packaging into `.deb` / `.rpm` / `.dmg`

---

## 3. Supported Platforms

### Operating Systems

* **Linux:** Ubuntu 22.04+ (Primary), Debian-based
* **MacOS:** macOS 13.0+ (Ventura) or newer

### Architecture

* `x86_64` (Intel/AMD)
* `arm64` (Apple Silicon, ARM Linux)

### Shell

* `bash` 4.4+
* `zsh` (MacOS default, compatible mode)

---

## 4. Installation Model

### Privileges

* `sudo` required **only** for dependency installation (`apt` or system-wide `brew`)
* All build artifacts live in the user’s home directory

### Default Paths

| Component | Path                           | Notes |
| --------- | ------------------------------ | ----- |
| Source    | `~/.local/src/llama.cpp`       | |
| Build     | `~/.local/src/llama.cpp/build` | |
| Binaries  | `~/.local/bin`                 | Added to PATH if missing |

All paths are configurable via environment variables.

---

## 5. CLI Interface

### Entrypoint

```bash
lcm
```

### Commands

| Command | Description |
| --- | --- |
| `--install-llama-cpp` | Install dependencies, clone repo, build |
| `--update-llama-cpp` | Update repo and rebuild |
| `--build` | Build without updating |
| `--run` | Run a minimal inference sanity check |
| `--status` | Check system readiness and show missing steps |
| `--help` | Display usage |

### Runtime Arguments

| Argument          | Required          | Description                    |
| ----------------- | ----------------- | ------------------------------ |
| `--model <path>`  | yes (for `--run`) | Path to `.gguf` model          |
| `--prompt <text>` | no                | Prompt text (default provided) |

---

## 6. Configuration

### Environment Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `LCM_LLAMA_DIR` | `~/.local/src/llama.cpp` | Source checkout |
| `LCM_BUILD_DIR` | `$LCM_LLAMA_DIR/build` | Build directory |
| `LCM_BIN_DIR` | `~/.local/bin` | Binary symlinks |
| `LCM_REPO_URL` | upstream GitHub URL | llama.cpp source |
| `LCM_JOBS` | `nproc` (or `sysctl`) | Parallel build jobs |

### Idempotency

All commands must be safely re-runnable and converge to a stable final state.

---

## 7. Dependency Specification

### Linux (apt)

* `git`
* `cmake`
* `build-essential`
* `pkg-config`
* `python3`
* `libopenblas-dev`

### MacOS (Homebrew)

* `git`
* `cmake`
* `python`
* `pkg-config`

### Optional

* `ccache` (build speed)
* NVIDIA CUDA Toolkit (Linux only)

---

## 8. Hardware Acceleration Auto-Detection

### Logic

The script auto-detects the optimal backend based on the environment.

| Platform | Detection Trigger | Backend Enabled | CMake Flag |
| :--- | :--- | :--- | :--- |
| **Linux** | `nvcc` in PATH | **CUDA** | `-DGGML_CUDA=ON` |
| **MacOS** | `uname` is Darwin | **Metal (MPS)** | `-DGGML_METAL=ON` |
| **Any** | (Fallback) | **CPU Only** | (Defaults) |

### Behavior

* Detection is automatic and prioritizes GPU over CPU.
* Explicit overrides via environment variables (e.g., `LCM_FORCE_CPU=1`) are planned for future versions but not required for v1.
* Build logs must clearly state which backend is being configured.

---

## 9. Build System

### Generator

* CMake (out-of-source)

### Default Flags

```text
-DCMAKE_BUILD_TYPE=Release
-DLLAMA_BUILD_TESTS=OFF
-DLLAMA_BUILD_EXAMPLES=ON
```

### Platform-Specific Flags

* **MacOS:** `-DGGML_METAL=ON` (if on Apple Silicon/Metal-capable Mac)
* **Linux (CUDA):** `-DGGML_CUDA=ON`

### Build Command

```bash
# Linux
cmake --build . -j $(nproc)

# MacOS
cmake --build . -j $(sysctl -n hw.ncpu)
```

---

## 10. Binary Installation

### Installation Strategy

* Symlink built binaries into `${BIN_DIR}`
* No binary copying by default

### Managed Executables

* `llama-cli`
* `llama-server`
* `llama-quantize`
* `llama-bench`
* `llama-perplexity`

Missing binaries produce warnings, not failures.

---

## 11. Runtime Sanity Check

### Behavior

* Validates `llama-cli` existence
* Validates model file readability
* Executes a short inference

### Default Execution

```bash
llama-cli -m <model> -p "<prompt>" -n 64
```

---

## 12. Logging & UX

### Logging

* Timestamped logs
* Clear action descriptions
* Explicit fallback messages (e.g., CUDA → CPU)

### UX Guarantees

* Never silently fails
* Never modifies shell profiles automatically
* Always prints actionable remediation steps

---

## 13. Safety & Security

* No remote scripts executed
* No telemetry or analytics
* No destructive filesystem operations outside build dir
* No background services or daemons

---

## 14. Licensing

### Repository License

* **MIT**

### Upstream Attribution

* `llama.cpp` is developed and licensed separately
* No upstream code is redistributed

---

## 15. Documentation Requirements

Minimum documentation:

* `README.md`
* `docs/system-spec.md`
* `docs/troubleshooting.md`
* `LICENSE`

---

## 16. CI Recommendations

Minimum CI checks:

* `bash -n`
* `shellcheck`
* Ubuntu runner

Full builds are optional and not required.

---

## 17. Forward Compatibility

Design must not block:

* Additional GPU backends
* Version pinning
* Multiple install targets
* Model helpers
* Packaged releases
