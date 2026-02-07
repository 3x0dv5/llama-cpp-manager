# llama-cpp-manager Context

This file provides context and instructions for AI agents working on the `llama-cpp-manager` project.

## Project Overview

**llama-cpp-manager** (lcm) is a repeatable, idempotent, user-local manager for the upstream [llama.cpp](https://github.com/ggerganov/llama.cpp) project on Linux and MacOS. It automates dependency management, source updates, hardware detection, and optimized builds.

### Core Goals
- **Repeatability:** Idempotent installation that converges to a stable state.
- **Hardware-Aware:** Auto-detects CUDA/Metal/CPU capabilities and provides optimized runtime parameters.
- **Stability:** Specifically designed to handle modern system incompatibilities (e.g., GCC 15 / glibc 2.41 conflicts) via automated workarounds or containerized builds.
- **User-Local:** Installs artifacts to `~/.local` to avoid cluttering system directories.

## Project Status

As of February 2026, the core manager is **fully implemented** and functional. The system supports automated installation, hardware optimization, Hugging Face model management, and Docker-based stable build environments.

## Technology Stack

- **Primary Language:** Bash 4.4+ (Entrypoint script).
- **Secondary Language:** Python 3 (Optimization logic).
- **Build System:** CMake (for building llama.cpp).
- **Containerization:** Docker/Podman (for stable build environments).
- **Target OS:** Ubuntu 22.04+ (Primary), Debian-based, MacOS 13.0+.
- **Dependencies:** `git`, `git-lfs`, `cmake`, `build-essential`, `pkg-config`, `python3`, `curl`, `libopenblas-dev`.

## Key Commands

- `--install-llama-cpp`: Full automated setup (dependencies, clone, build).
- `--update-llama-cpp`: Pull latest upstream changes and rebuild.
- `--build [--container | --cpu]`: Re-run CMake build with optional containerization or CPU-only enforcement.
- `--run --model <path|url|-hf repo:file> [--optimize [file]] [--config file] [--mode cli|server]`: Execute inference or optimize parameters.
- `--status`: Comprehensive system audit and remediation guide.
- `--clean`: Remove build artifacts.
- `--clone`: Manually clone the source repository.

## Development Conventions

- **Logging:** All log output is directed to `stderr` to ensure `stdout` remains clean for programmatic data (like JSON).
- **Namespace:** All environment variables use the `LCM_` prefix (e.g., `LCM_LLAMA_DIR`).
- **Workarounds:** Always check `detect_backend_flags` for logic regarding GCC/glibc version handling.
- **Licensing:** MIT License - Rui Lima (ruilima.ai).

## Key Files

- `lcm`: The primary Bash entrypoint.
- `Dockerfile.lcm`: Stable build environment (Ubuntu 22.04 + CUDA 12).
- `docs/MANUAL.md`: Comprehensive user and technical guide.
- `docs/system-spec.md`: Original architecture specification.
- `GEMINI.md`: AI context and project guidelines (this file).
