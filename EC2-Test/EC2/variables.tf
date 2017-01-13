// Module specific variables

variable "instance_name" {
  description = "Used to populate the Name tag. This is done in main.tf"
}

variable "instance_type" {}

variable "key_name" {}

variable "ami_id" {
  description = "The AMI to use"
}

variable "number_of_instances" {
  description = "The path to a file with user_data for the instances"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  default = {
    created_by = "terraform"
  }
}
