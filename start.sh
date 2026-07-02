#!/bin/bash
uvicorn server.main:app --host 0.0.0.0 --port 8000 &

# Wait for backend to be ready before starting frontend
for i in $(seq 1 30); do
    if curl -s http://localhost:8000/ > /dev/null 2>&1; then
        echo "Backend ready"
        break
    fi
    echo "Waiting for backend... ($i)"
    sleep 1
done

streamlit run client/main.py --server.port $PORT --server.address 0.0.0.0
