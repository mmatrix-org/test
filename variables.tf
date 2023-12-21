
variable "aws_region" {
  default     = "eu-east-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}

variable "app_image" {
  default     = "933085737869.dkr.ecr.us-east-1.amazonaws.com/mpulse-backend-prod-green:1.0.0"
  description = "docker image to run in this ECS cluster"
}

variable "cidr_block" {
  default     = "172.16.0.0/16"
  description = "vpc for cluster"
}

variable "vpc_id" {
  default     = "vpc-07eb030ba672a7ecb"
  description = "vpc for cluster"
}

variable "app_port" {
  default     = "8000"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "0" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  default     = "2048"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "4096"
  description = "Fargate instance memory to provision (in MiB) not MB"
}