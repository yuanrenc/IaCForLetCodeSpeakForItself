
[
  {
    "name": "letCodeSpeakForItself",
    "image": "${image}:${deploy_version}",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-southeast-2",
        "awslogs-stream-prefix": "${env}",
        "awslogs-group": "${log_group}"
      }
    },
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port},
        "protocol": "tcp"
      }
    ],
    "cpu": 1,
    "environment": [
      {
        "name": "SD_LISTENHOST",
        "value": "0.0.0.0"
      },
      {
        "name": "SD_DBHOST",
        "value": "${db_endpoint}"
      },{
        "name": "SD_DBPASSWORD",
        "value": "${db_password}"
      }
    ],
    "entrypoint": [
        "sh",
        "-c"
    ],
    "command": [
        "./App database && ./App server"
    ],
    "mountPoints": [],
    "volumesFrom": []
  }
]