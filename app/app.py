import base64

import boto3
import random
import os

from dotenv import load_dotenv

from io import BytesIO
from fastapi import FastAPI
from fastapi.responses import JSONResponse, StreamingResponse
from PIL import Image
from fastapi.responses import HTMLResponse


from pathlib import Path

load_dotenv()
app = FastAPI()

BASE_DIR = Path(__file__).resolve().parent
TEMPLATE_PATH = BASE_DIR / 'templates' / 'welcome.html'


load_dotenv()


AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']
AWS_REGION = os.environ['AWS_REGION']
S3_BUCKET = os.environ['S3_BUCKET']


S3_CLIENT = boto3.client(
    's3',
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name=AWS_REGION)


@app.get('/')
def hellow_kitti_page():
    template_path = BASE_DIR / 'templates' / 'welcome.html'

    with open(template_path, 'r', encoding='utf-8') as file:
        html_content = file.read()
    return HTMLResponse(content=html_content)

@app.get('/random-image')
def get_random_image():
    template_path = BASE_DIR / 'templates' / 'random_cats.html'

    response = S3_CLIENT.list_objects_v2(Bucket=S3_BUCKET)

    if 'Contents' not in response:
        return JSONResponse({"error": "No images found in the bucket"}), 404

    keys = [obj['Key'] for obj in response['Contents']]

    random_key = random.choice(keys)

    image_object = S3_CLIENT.get_object(Bucket=S3_BUCKET, Key=random_key)

    image_data = image_object['Body'].read()


    with Image.open(BytesIO(image_data)) as img:
        img = img.resize((800, 600))
        img_byte_arr = BytesIO()
        img.save(img_byte_arr, format='JPEG', quality=90)
        img_byte_arr.seek(0)

    image_data_base64 = base64.b64encode(img_byte_arr.getvalue()).decode()

    with open(template_path, 'r', encoding='utf-8') as file:
        html_content = file.read()

    html_content = html_content.replace("{{ image_data }}", image_data_base64)

    return HTMLResponse(content=html_content)



if __name__ == '__main__':
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=5000)