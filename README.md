# IaCForLetCodeSpeakForItself


The repository is an attempt at completing the IaC part for this [app](https://github.com/yuanrenc/letCodeSpeakForItself).

## Pre-requisites

* Install docker-compose.
* Create an IAM user and attach the following managed policies directly from the console:
  * AmazonEC2FullAccess
  * ElasticLoadBalancingFullAccess
  * AmazonVPCFullAccess
  * AmazonRDSFullAccess
  * AmazonS3FullAccess
  * CloudWatchLogsFullAccess
  * IAMFullAccess
  * AmazonECS_FullAccess

*Strongly recommend* to only execute the repository in a test environment due to the large scope of IAM policies.

* With the existing IAM user created, create a set of AWS API keys for us to load into the environment.

```shell
# Type in the aws access key id
read -s AWS_ACCESS_KEY_ID && export AWS_ACCESS_KEY_ID

# Type in the aws secret key
read -s AWS_SECRET_ACCESS_KEY && export AWS_SECRET_ACCESS_KEY
```

* Populate the database/password.txt for the Postgresql Master password by:

```shell
echo 'changeme' > database/password.txt
```

## High Level Design

* Application will be fronted by an ALB. The ALB will be responsible for the healthcheck and round robin distribution of traffic to ensure the application is highly available.
* The backend will consists of:
  * Database being deployed RDS with multi availability zones.
  * ECS Service for Fargate we can ensure the application is spread across all availability zones.
* Application Subnet will have Internet routing to allow us to directly fetch the image from Dockerhub.

## Execution Order

To deploy the stack, execute the commands in the following order:

```shell
# create the s3 remote state bucket
make plan-state
make apply-state

# create the network
make plan-network
make apply-network

# create the database
make plan-database
make apply-database

# deploy the application
make plan-application
make apply-application
```

## Deployment of application

To deploy a specific version of the application, run the following:

```shell
make plan-application DEPLOY_VERSION=v.0.8.0
make apply-application
```

## Removal

To cleanup, execute `make destroy-application destroy-database destroy-network destroy-state`.

## Future improvements

* Include awspec tests.
* Use AWS secretmanager to store the RDS database password - The password currently appears in plain sight in the terraform plan.
* Database subnet should not include a route to NAT gateway.
* Use HTTPS traffic for application load balancer instead.
* Scope down permissions of the IAM user that is used to deploy the infrastructure.
