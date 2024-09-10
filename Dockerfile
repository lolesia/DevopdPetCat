FROM python:3.10-slim


COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
COPY .env .

CMD ["python", "app/app.py"]