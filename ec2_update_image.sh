#!/bin/bash
set -e

source .env

echo "Logging to ECR"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

echo "Build Docker image"
docker build -t devops-kitty-cat .

echo "Tag and Push docker image"
docker tag devops-kitty-cat:latest 058264474873.dkr.ecr.us-east-1.amazonaws.com/devops-kitty-cat:latest
docker push 058264474873.dkr.ecr.us-east-1.amazonaws.com/devops-kitty-cat:latest


REMOTE_COMMANDS=$(cat << EOF

    echo "Logging to ECR"
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

    echo "Stopping container"
    docker stop $CONTAINER_NAME && echo "Container $CONTAINER_NAME stopped " && docker rm $CONTAINER_NAME && echo "Container $CONTAINER_NAME deleted" || echo "Failed to stop or delete container $CONTAINER_NAME"

    echo "Pull docker image"
    docker pull $ECR_REPO_URL:latest

    echo "Reload  docker-kitty-cat.service"
    sudo systemctl daemon-reload
    sudo systemctl restart docker-kitty-cat.service


    echo "Deleted images without tag latest."
    docker images --format '{{.Repository}}:{{.Tag}} {{.ID}}' | grep -v "latest" | awk '{print \$2}' | xargs -I {} docker rmi -f {}


    echo "Update completed."
EOF
)

echo "Connect to instance"
ssh -i $PATH_PEM_FILE ubuntu@ec2-54-172-220-31.compute-1.amazonaws.com "$REMOTE_COMMANDS"
