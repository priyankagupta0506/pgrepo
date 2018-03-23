# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default = "us-east-1"
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster. Leave blank to not include a Key Pair."
  default = "mysql"
}

variable "demo_frontend_image" {
  description = "The name of the Docker image to deploy for the frontend"
  default = "785295575848.dkr.ecr.us-east-1.amazonaws.com/iac_front"
}

variable "demo_frontend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the frontend (e.g. latest, 12345)"
  default = "latest"
}

variable "demo_backend_image" {
  description = "The name of the Docker image to deploy for the  backend "
  default = "785295575848.dkr.ecr.us-east-1.amazonaws.com/iac_back"
}

variable "demo_backend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the backend (e.g. latest, 12345)"
  default = "latest"
}

variable "demo_frontend_port" {
  description = "The port the frontend Docker container listens on for HTTP requests (e.g. 3000)"
  default = 3000
}

variable "demo_backend_port" {
  description = "The port the backend Docker container listens on for HTTP requests (e.g. 4567)"
  default = 4567
}
