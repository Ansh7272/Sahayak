#!/bin/bash
ROOT=$(pwd)

(cd "$ROOT/server" && uvicorn main:app --host 0.0.0.0 --port 8000) &

for i in $(seq 1 30); do
    if curl -s http://localhost:8000/ > /dev/null 2>&1; then
        echo "Backend ready"
        break
    fi
    echo "Waiting for backend... ($i)"
    sleep 1
done

cd "$ROOT"
streamlit run client/main.py --server.port $PORT --server.address 0.0.0.0
