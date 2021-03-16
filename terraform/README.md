### Requirements

    wget
    awscli
    eksctl
    kubectl
    docker
    openssl

### Initialise terraform

    terraform init

### Create plan

    terraform plan --out=plan

### Apply Plan (it will stop before creating the alb ingress controller, for which you need to run the next steps)

    terraform apply "plan"

### Add context to kubectl for the new cluster

    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

### Create an OIDC provider (before creating the alb ingress controller)

    aws eks describe-cluster --name $(terraform output -raw cluster_name) --query "cluster.identity.oidc.issuer" --output text
    eksctl utils associate-iam-oidc-provider --cluster $(terraform output -raw cluster_name) --approve

### Continue deploying the rest of resources (the alb ingress controller and reqs)

    terraform plan --out=plan
    terraform apply "plan"

### Install ssm agent worker nodes

    eksctl create iamserviceaccount --name ssm-sa --cluster $(terraform output -raw cluster_name) --namespace kube-system \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM \
    --override-existing-serviceaccounts \
    --approve

    # to start ssm on nodes
    kubectl apply -f ssm_daemonset.yaml

    # to stop ssm on nodes
    kubectl delete -f ssm_daemonset.yaml

### Install EFS CSI driver for EKS

    https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

    If you want to use EFS simply as a mounted volume without the CSI driver https://www.c2labs.com/post/persistent-storage-on-kubernetes-for-aws

### Install metrics collector && datadog for the cluster

    https://github.com/kubernetes/kube-state-metrics
    https://www.datadoghq.com/blog/eks-monitoring-datadog/

### Install the AWS EFS & EBS CSI driver (to allow EFS & EBS volume management for the cluster)

    https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html

### Install the cluster-autoscaler

    https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html

### Some helping articles

    https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html
    https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
    https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

### Delete infra

    terraform destroy
