### Requirements

    awscli
    docker
    kubectl
    skaffold
    terraform

### Login to ECR

    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

### Run the stack

    skaffold dev

### Deploy the stack (uploading dockerfile to ECR)

    skaffold run --default-repo ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

### Delete the stack (ECR images aren't removed, only the k8s objects from the manifests)

    kubectl delete -f k8s-manifest.yml
