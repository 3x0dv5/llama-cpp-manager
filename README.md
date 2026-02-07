# llama-cpp-manager

A repeatable, idempotent, user-local manager for the upstream [llama.cpp](https://github.com/ggerganov/llama.cpp) project on Linux and MacOS.

## Features

- **Repeatable:** Idempotent installation that converges to a stable state.
- **GPU Auto-Detection:** Automatically enables CUDA if `nvcc` is present, falling back to CPU if not. Metal is automatically enabled on MacOS.
- **User-Local:** Installs artifacts to `~/.local` to avoid cluttering system directories.
- **Simple CLI:** Manage the entire lifecycle of `llama.cpp` binaries with a single script.

## Installation

Download the `lcm` script and make it executable:

```bash
chmod +x lcm
```

## Usage

### Install llama.cpp
This will install dependencies (requires `sudo` for `apt`), clone the repository, and build the binaries.

```bash
./lcm --install-llama-cpp
```

### Update llama.cpp
Pull the latest upstream changes and rebuild.

```bash
./lcm --update-llama-cpp
```

### Build Only
Re-run the build process without updating the source.

```bash
# Standard build (auto-detects GPU)
./lcm --build

# Force CPU-only build
./lcm --build --cpu

# Build inside a stable container (GPU supported if Docker is ready)
./lcm --build --container
```

### Check System Status
Verify system readiness, missing dependencies, and GPU detection.

```bash
./lcm --status
```

### Clean Build
Remove build artifacts to ensure a fresh compilation.

```bash
./lcm --clean
```

### Clone Repository
Manually clone the llama.cpp repository (useful if previous clones failed).

```bash
./lcm --clone
```

### Run Sanity Check
Execute a minimal inference to ensure everything is working correctly.

```bash
./lcm --run --model /path/to/model.gguf
```

### Download and run from Hugging Face
Use the `-hf` identifier syntax (requires `--download-dir`).

```bash
./lcm --run --model -hf unsloth/Qwen3-Coder-Next-GGUF:Q4_K_M --download-dir ./models
```

## Configuration

You can override default paths using environment variables:

| Variable | Default | Purpose |
| --- | --- | --- |
| `LCM_LLAMA_DIR` | `~/.local/src/llama.cpp` | Source checkout directory |
| `LCM_BIN_DIR` | `~/.local/bin` | Directory for binary symlinks |
| `LCM_REPO_URL` | Upstream URL | `llama.cpp` repository URL |
| `LCM_CC` | (auto) | Override C compiler (e.g., `gcc-14`) |
| `LCM_CXX` | (auto) | Override C++ compiler (e.g., `g++-14`) |

## Documentation

- [System Specification](docs/system-spec.md)
- [Troubleshooting](docs/troubleshooting.md)

## License

MIT
