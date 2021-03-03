### Create plan

    terraform plan -var 'access_key=AKIAJIWAOJFINGDMBVGA' -var 'secret_key=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' --out=plan

### Apply Plan

    terraform apply "plan"

### Delete infra

    terraform destroy -var 'access_key=AKIAJIWAOJFINGDMBVGA' -var 'secret_key=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'
