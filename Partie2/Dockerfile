FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY p1_flask.py .
EXPOSE 5000

CMD ["python", "p1_flask.py"]
