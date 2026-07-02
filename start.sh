#!/bin/bash
uvicorn server.main:app --host 0.0.0.0 --port 8000 &
streamlit run client/main.py --server.port $PORT --server.address 0.0.0.0
