#!/bin/bash

# Ensure we are in the directory where the script is located
cd "$(dirname "$0")"

if [ ! -f "lcm" ]; then
    echo "Error: lcm script not found in current directory."
    exit 1
fi

echo "Starting LCM servers in separate Konsole instances..."

# 1. Chat Server (Port 8080)
konsole --hold -e ./lcm --run --config production.json --chat --port 8080 --threads 6 --mode server &

# 2. Embedding Server (Port 8081)
konsole --hold -e ./lcm --run --config production.json --embedding --port 8081 --threads 2 --mode server &

# 3. Reranker Server (Port 8082)
konsole --hold -e ./lcm --run --config production.json --re-ranker --port 8082 --threads 2 --mode server &

echo "Done."
