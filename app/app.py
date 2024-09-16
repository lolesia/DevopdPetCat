import boto3
import random
import os

from dotenv import load_dotenv

from io import BytesIO
from fastapi import FastAPI
from fastapi.responses import JSONResponse, StreamingResponse
load_dotenv()

app = FastAPI()

AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']
AWS_REGION = os.environ['AWS_REGION']
S3_BUCKET = os.environ['S3_BUCKET']


S3_CLIENT = boto3.client(
    's3',
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name=AWS_REGION)


@app.get('/random-image')
def get_random_image():

    response = S3_CLIENT.list_objects_v2(Bucket=S3_BUCKET)

    if 'Contents' not in response:
        return JSONResponse({"error": "No images found in the bucket"}), 404

    keys = [obj['Key'] for obj in response['Contents']]

    random_key = random.choice(keys)

    image_object = S3_CLIENT.get_object(Bucket=S3_BUCKET, Key=random_key)

    image_data = image_object['Body'].read()

    return StreamingResponse(BytesIO(image_data), media_type="image/jpeg")


if __name__ == '__main__':
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=5000, workers=4)