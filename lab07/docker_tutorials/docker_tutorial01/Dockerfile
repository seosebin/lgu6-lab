FROM python:3.10-slim
WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements

COPY . .

EXPOSE 8501

CMD ['streamlit', 'run', 'app.py', '--server.port=8501', '--server.adress=0.0.0.0']