# Terraform_AWS_ECS_Fargate_ECR


```sh
cd example

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform apply -auto-approve
```

- Testing

```sh
cd testing
docker build -t k6 .

docker run --rm --name k6_con --net=host -p 5665:5665 -e MAX=2000 -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=load.html -e BASE_URL=http://demo-fargate-lb-814818424.ca-central-1.elb.amazonaws.com:80 -v ./:/app k6 run local_load.js
```