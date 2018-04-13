terraform {
  required_version = "> 0.9.0"
}

provider "aws" {
  region = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "ecs_cluster" {
  source = "./ecs-cluster"

  name = "ecs-demo"
  size = 2
  instance_type = "t2.micro"
  key_pair_name = "${var.key_pair_name}"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  allow_ssh_from_cidr_blocks = ["0.0.0.0/0"]

# you should lock this down to just the IP addresses of the ELB and other trusted parties.
 
  allow_inbound_ports_and_cidr_blocks = "${map(
    var.demo_frontend_port, "0.0.0.0/0",
    var.demo_backend_port, "0.0.0.0/0"
  )}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SINATRA BACKEND APP AND AN ELB FOR IT
# ---------------------------------------------------------------------------------------------------------------------

module "demo_backend" {
  source = "./ecs-service"

  name = "demo-backend"
  ecs_cluster_id = "${module.ecs_cluster.ecs_cluster_id}"
  
  image = "${var.demo_backend_image}"
  image_version = "${var.demo_backend_version}"
  cpu = 1024
  memory = 768
  desired_count = 1
  
  container_port = "${var.demo_backend_port}"
  host_port = "${var.demo_backend_port}"
  elb_name = "${module.demo_backend_elb.elb_name}"

  num_env_vars = 1
  env_vars = "${map("RACK_ENV", "production")}"
}

module "demo_backend_elb" {
  source = "./elb"

  name = "demo-backend-elb"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  instance_port = "${var.demo_backend_port}"
  health_check_path = "health"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE RAILS FRONTEND APP AND AN ELB FOR IT
# ---------------------------------------------------------------------------------------------------------------------

module "demo_frontend" {
  source = "./ecs-service"

  name = "demo-frontend"
  ecs_cluster_id = "${module.ecs_cluster.ecs_cluster_id}"

  image = "${var.demo_frontend_image}"
  image_version = "${var.demo_frontend_version}"
  cpu = 1024
  memory = 768
  desired_count =1 

  container_port = "${var.demo_frontend_port}"
  host_port = "${var.demo_frontend_port}"
  elb_name = "${module.demo_frontend_elb.elb_name}"

  # Provide the URL of the sinatra-backend ELB using the same environment variable name and format as docker-compose
  num_env_vars = 2
  env_vars = "${map(
    "RACK_ENV", "production",
    "SINATRA_BACKEND_PORT", "tcp://${module.demo_backend_elb.elb_dns_name}"
  )}"
}

module "demo_frontend_elb" {
  source = "./elb"

  name = "demo-frontend-elb"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  instance_port = "${var.demo_frontend_port}"
  health_check_path = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC and subnet IDs above.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {}

# Look up the default subnets in the AZs available to this account (up to a max of 3)
data "aws_subnet" "default" {
  count = "${min(length(data.aws_availability_zones.available.names), 3)}"
  default_for_az = true
  vpc_id = "${data.aws_vpc.default.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
}
