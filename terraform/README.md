### Creating the EKS cluster

    terraform init

    terraform plan -var 'access_key=key' -var 'secret_key=key' -out=plan

### Executing the planned changes

    terraform apply "plan"

### Destroying the EKS cluster

    terraform destroy -var 'access_key=key' -var 'secret_key=key'
