### Requirements

    wget
    awscli
    eksctl
    kubectl
    docker
    openssl
    helm

### Initialise terraform

    terraform init

### On first creation

Before planning and creating the entire infrastructure, comment out the resource `aws_efs_mount_target` inside `efs.tf` using `/*` and `*/`. That resource depends on the VPC being created first. After the VPC has been created, you can uncomment it and run `terraform plan` and `terraform apply` to update the EFS volume and create the mount targets for each of the private subnets in the new VPC.

### Create and apply plan

    terraform plan --out=plan
    terraform apply "plan"

If the process exits with `Error: error reading EKS Cluster`, just plan and apply again for the remaining resources

### Add context to kubectl for the new cluster

    aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

### Create an OIDC provider manually

This shouldn't be needed explicitly.

    aws eks describe-cluster --name $(terraform output -raw cluster_name) --query "cluster.identity.oidc.issuer" --output text
    eksctl utils associate-iam-oidc-provider --cluster $(terraform output -raw cluster_name) --approve

### Install EFS CSI driver for EKS

https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

    kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.1"

If you want to use EFS simply as a mounted volume without the CSI driver https://www.c2labs.com/post/persistent-storage-on-kubernetes-for-aws

### Install metrics collector and dashboard

https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html

    kubectl apply -f metrics-server.yaml

https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
    kubectl apply -f eks-metrics-admin.yaml

To view the dashboard run:

    kubectl proxy -p 8080
    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

You can then access the dashboard at (using the retrieved token from above):

    http://localhost:8080/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login

### Install the cluster-autoscaler

https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html
https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/irsa

    helm repo add autoscaler https://kubernetes.github.io/autoscaler
    helm repo update

Generate a helm values file based on `cluster-autoscaler-chart-values-template.yaml` and then install the autoscaler using those values:

    helm install cluster-autoscaler --namespace kube-system autoscaler/cluster-autoscaler-chart --values=cluster-autoscaler-chart-values.yaml

### Install ssm agent worker nodes

    eksctl create iamserviceaccount --name ssm-sa --cluster $(terraform output -raw cluster_name) --namespace kube-system \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM \
    --override-existing-serviceaccounts \
    --approve

    # to start ssm on nodes
    kubectl apply -f ssm_daemonset.yaml

    # to stop ssm on nodes
    kubectl delete -f ssm_daemonset.yaml

### Some helping articles

https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html
https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/

### Delete infra

    terraform destroy
