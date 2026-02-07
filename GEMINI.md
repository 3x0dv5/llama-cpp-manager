# llama-cpp-manager Context

This file provides context and instructions for AI agents working on the `llama-cpp-manager` project.

## Project Overview

**llama-cpp-manager** is a repeatable, idempotent, user-local manager for the upstream [llama.cpp](https://github.com/ggerganov/llama.cpp) project on Linux and MacOS. It automates the installation of dependencies, handles source updates, auto-detects GPU capabilities (CUDA/Metal), and manages builds via CMake.

### Core Goals
- **Repeatability:** Idempotent installation that converges to a stable state.
- **GPU Auto-Detection:** Automatically enables CUDA if `nvcc` is present, falling back to CPU if not.
- **User-Local:** Installs artifacts to `~/.local` to avoid cluttering system directories.
- **Strict Management:** Does not fork upstream or bundle models; focuses solely on the lifecycle of the `llama.cpp` binaries.

## Project Status

As of February 2026, the project is in the **specification/bootstrap phase**. The core system specification is defined in `docs/system-spec.md`. Implementation of the primary Bash entrypoint is pending.

## Technology Stack

- **Primary Language:** Bash 4.4+ (for the manager script).
- **Build System:** CMake (for building llama.cpp).
- **Target OS:** Ubuntu 22.04+ (Primary), Debian-based (Best-effort).
- **Target Architectures:** x86_64 (Primary), ARM64 (CPU-only).
- **Dependencies:** `git`, `cmake`, `build-essential`, `pkg-config`, `python3`, `libopenblas-dev`.
- **Optional:** `ccache` (build speed), NVIDIA CUDA Toolkit.

## Building and Running

The tool is intended to be used as a CLI script (e.g., `lcm`).

### Key Commands (Planned)
- `--install-llama-cpp`: Install dependencies, clone, and build.
- `--update-llama-cpp`: Pull latest upstream changes and rebuild.
- `--build`: Re-run CMake build without updating source.
- `--run --model <path>`: Execute a minimal inference sanity check.

## Development Conventions

- **Shell Standards:** Scripts should be `shellcheck`-clean and follow Bash 4.4+ conventions.
- **Idempotency:** All commands must be safely re-runnable.
- **Sudo Usage:** `sudo` is restricted *only* to `apt` dependency installation.
- **Logging:** Use timestamped logs and clear fallback messages (e.g., when falling back from CUDA to CPU).
- **Licensing:** The project is licensed under the **MIT License**. Ensure all new files are consistent with this.

## Key Files

- `README.md`: Basic project description.
- `LICENSE`: MIT License terms.
- `docs/system-spec.md`: Comprehensive system architecture and CLI specification.
- `GEMINI.md`: AI context and project guidelines (this file).