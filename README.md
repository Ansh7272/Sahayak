# Sahayak

Sahayak is an AI-powered learning platform that lets teachers upload PDFs and students ask questions about the content. It uses retrieval-augmented generation (RAG) to find relevant information from uploaded documents and answer questions in natural language. Students can also generate and attempt quizzes based on the material.

## How it works

Teachers upload PDF documents through the web interface. The system breaks each document into chunks, generates embeddings using Google's Gemini model, and stores everything in two places — MongoDB keeps the full text, and Pinecone stores the vector embeddings for semantic search.

When a student asks a question, the system converts their query into an embedding, searches Pinecone for the most relevant chunks, pulls the full text from MongoDB, and feeds it as context to a language model (Llama 3.3 via Groq) to generate an answer. The response includes the answer and a list of source documents.

The same pipeline powers quiz generation — students pick a topic and get multiple-choice questions with answer keys.

## Tech stack

- **Backend**: FastAPI (Python)
- **Frontend**: Streamlit
- **Database**: MongoDB Atlas (user data, document chunks, chat history, quizzes)
- **Vector store**: Pinecone (embeddings for semantic search)
- **Embeddings**: Google Gemini (`models/gemini-embedding-001`)
- **LLM**: Llama 3.3 70B via Groq
- **Auth**: HTTP Basic Auth with bcrypt password hashing

## Project structure

```
├── client/              # Streamlit frontend
│   ├── main.py          # App with login, signup, upload, chat, quiz pages
│   └── assets/          # UI images
├── server/              # FastAPI backend
│   ├── main.py          # App entrypoint, router registration
│   ├── auth/            # User authentication (signup, login, hashing)
│   ├── chat/            # Chat and quiz endpoints, RAG query logic
│   ├── config/          # MongoDB connection setup
│   ├── docs/            # PDF upload, chunking, vector store indexing
│   └── upload_docs/     # Uploaded PDF files
├── requirements.txt     # Python dependencies
├── start.sh             # Entrypoint script (used on Render)
└── .env                 # Environment variables (not committed)
```

## API endpoints

| Method | Path | Auth | What it does |
|---|---|---|---|
| POST | `/signup/student` | No | Register a student account |
| POST | `/signup/teacher` | No | Register a teacher account |
| GET | `/login` | Basic Auth | Authenticate and get user role |
| POST | `/upload_docs` | No | Upload a PDF (teacher) |
| POST | `/chat` | Basic Auth | Ask a question (student) |
| POST | `/quiz` | Basic Auth | Generate a quiz (student) |
| POST | `/quiz/check` | Basic Auth | Submit quiz answers (student) |
| GET | `/quiz/history` | Basic Auth | View past quiz attempts (student) |
| GET | `/` | No | Health check |

## Quick start

```bash
# Install dependencies
pip install -r requirements.txt

# Start the backend
cd server
uvicorn main:app --reload --port 8000

# In another terminal, start the frontend
cd client
streamlit run main.py
```

Point your browser to `http://localhost:8501`. The frontend expects the backend at `http://localhost:8000` — set `BACKEND_URL` if needed.

## Environment variables

| Variable | Required | Description |
|---|---|---|
| `MONGO_URI` | Yes | MongoDB Atlas connection string |
| `DB_NAME` | No | Database name (default: `Sahayak`) |
| `GOOGLE_API_KEY` | Yes | Google Generative AI key for embeddings |
| `PINECONE_API_KEY` | Yes | Pinecone API key |
| `PINECONE_INDEX_NAME` | No | Index name (default: `tutor-rags`) |
| `GROQ_API_KEY` | Yes | Groq API key for LLM inference |
| `BACKEND_URL` | No | Backend URL for frontend (default: `http://localhost:8000`) |

## Deployment

The project is designed to deploy on Render as a single web service. The `start.sh` script launches both the FastAPI backend (port 8000) and the Streamlit frontend (on Render's assigned port).
