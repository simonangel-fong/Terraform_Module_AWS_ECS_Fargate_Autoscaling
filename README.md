# Terraform Module: Amazon ECS Fargate

## FastAPI & Image

```sh
# build locally
cd fastapi
docker build -t demo_fargate .
docker run -d --name demo_fargate -p 8000:80 demo_fargate
docker rm -f demo_fargate

# push image
docker tag demo_fargate simonangelfong/demo-fargate-app
docker push simonangelfong/demo-fargate-app
```

---

## Terraform - Deploy

```sh
cd example

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform apply -auto-approve
# Outputs:
# cdn_domain = "d19tn7iec1lu1l.cloudfront.net"

terraform delete -auto-approve
```

---

## K6 - Testing

```sh
cd testing
docker build -t k6 .

docker run --rm --name k6_con --net=host -p 5665:5665 -e MAX=2000 -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=load.html -e BASE_URL=https://demo-fargate.arguswatcher.net/ -e DURATION=60 -v ./:/app k6 run local_load.js
```
