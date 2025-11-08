[
  {
    "name": "${con_name}",
    "image": "${con_image}",
    "cpu": ${con_cpu},
    "memory": ${con_memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${con_port},
        "hostPort": ${con_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/aws/ecs/${con_name}",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
  }
]