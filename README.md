# Terraform Demo: Amazon ECS(Fargate) Autoscaling

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
cd aws

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform apply -auto-approve
# Outputs:
# dns_url = "https://demo-ecs-autoscaling.arguswatcher.net"

terraform destroy -auto-approve
```

---

## K6 - Testing

- Build k6

```sh
cd testing
docker build -t k6 .
```

- Test locally

```sh
# local
docker run --rm --name k6_con -p 5665:5665 -e TEST="ECS Autoscaling" -e VU=100 -e SCALE=300 -e DURATION=900 -e DOMAIN=https://demo-ecs-autoscaling.arguswatcher.net/ -e K6_WEB_DASHBOARD=true -e K6_WEB_DASHBOARD_EXPORT=report.html  -v ./:/app k6 run local_load.js
```

- Test on Cloud

```sh
# cloud
docker run --rm --name k6_con --env-file ./.env -e TEST="ECS Autoscaling" -e VU=100 -e SCALE=200 -e DURATION=1200 -e DOMAIN=https://demo-ecs-autoscaling.arguswatcher.net/ -v ./:/app k6 cloud run --include-system-env-vars=true local_load.js
```

![pic](./doc/ecs_task.png)

![pic](./doc/ecs_autoscaling.png)

![pic](./doc/testing.png)
