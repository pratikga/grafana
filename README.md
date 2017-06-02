# Network Analytics

Parse system logs and monitor system metrics

## Getting started

These instructions will get you a copy of the docker image with grafana  up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Make sure  docker to be running on the local system

```
sudo yum install docker

sudo systemctl start docker
```

## Deployment

```
docker build --rm -t grafana .
docker run -d --privileged grafana
docker exec -it container_id /bin/bash
```
