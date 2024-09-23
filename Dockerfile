FROM python:3.10-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY app ./app
COPY .env .

EXPOSE 80
EXPOSE 5000

CMD ["/bin/sh", "-c", "service nginx start && uvicorn app.app:app --host 0.0.0.0 --port 5000 --workers 4"]

