from flask import Flask, jsonify, send_file
import boto3
import random
import os
from io import BytesIO

app = Flask(__name__)
S3_BUCKET = 'devops-random-cat'
S3_CLIENT = boto3.client('s3', region_name='eu-central-1')
