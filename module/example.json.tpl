[
  {
    "name": "${con_name}",
    "image": "${con_image}",
    "cpu": ${con_cpu},
    "memory": ${con_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${con_port},
        "hostPort": ${con_port}
      }
    ]
  }
]