### Requirements

    wget
    awscli
    kubectl
    docker

### Initialise terraform

    terraform init

### Create plan

    terraform plan --out=plan

### Apply Plan

    terraform apply "plan"

### Add context to kubectl for the new cluster

    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

### Install aws alb ingress controller

    https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

### Delete infra

    terraform destroy
