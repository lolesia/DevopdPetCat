FROM python:3.10-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y nginx

COPY app ./app
COPY .env .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 5000

CMD ["sh", "-c", "uvicorn app.app:app --host 0.0.0.0 --port 5000 --workers 4 & nginx -g 'daemon off;'"]