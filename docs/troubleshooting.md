# Troubleshooting

**Author:** Rui Lima (ruilima.ai)

This document provides solutions for common issues encountered when using `llama-cpp-manager` (lcm).

## 1. Permission Denied (sudo)

The script requires `sudo` only for installing system dependencies via `apt` (on Linux). If you cannot use `sudo`, you must manually ensure that the following dependencies are installed:

- `git`
- `cmake`
- `build-essential`
- `pkg-config`
- `python3`
- `libopenblas-dev`

## 2. Hardware Acceleration Not Detected

### CUDA (Linux)

If `nvcc` is not in your `PATH`, the script will fall back to CPU. Ensure the NVIDIA CUDA Toolkit is installed and its `bin` directory is in your `PATH`.

```bash
export PATH=/usr/local/cuda/bin:$PATH
```

### Metal (MacOS)

Metal should be automatically enabled on all modern MacOS installations. Ensure you are running on MacOS 13.0+ as per the system specification.

## 3. Build Failures

If the build fails, try cleaning the build directory and re-running:

```bash
rm -rf ~/.local/src/llama.cpp/build
lcm --build
```

Common build failures are often due to missing header files or incompatible compiler versions. Ensure your system meets the requirements (Ubuntu 22.04+ or MacOS 13.0+).

## 4. Binaries Not Found

If you can't run `llama-cli` after a successful build, ensure `~/.local/bin` is in your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## 5. Model Errors

If `--run` fails, verify that:
- The model file path is correct.
- The model is in GGUF format.
- You have enough RAM/VRAM to load the model.
