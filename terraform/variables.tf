variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "wp-key"
}

variable "public_key_path" {
  type = string
}

variable "my_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR, e.g. 103.184.238.249/32"
}
