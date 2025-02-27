################################################################################
# EC2 varaibles
################################################################################

variable "ami" {
  description = "This is a variable of type string"
  type        = string

}

variable "instance_type" {
  description = "This is a variable of type string"
  type        = string

}
variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string

}

variable "subnet_id" {
  description = "The ID of the existing subnet"
  type        = string

}

variable "security_group_id" {
  description = "The ID of the existing security group"
  type        = string

}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "This is a variable of type string"
  type        = string

}

variable "availability_zone" {
  description = "This is a variable of type string"
  type        = string

}


variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

/*variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = any
  default     = {}
}*/

/*variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = null
}*/

/*variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = null
}*/

/*variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(any)
  default     = []
}*/

/*variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}*/

/*variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  type        = bool
  default     = null
}*/

/*variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}*/

/*variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it"
  type        = bool
  default     = null
}*/

/*variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}*/
variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "AI-instance-key"
}
variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default = {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 2
    "http_tokens"                 = "optional"
  }
}

variable "cpu_options" {
  description = "Defines CPU options to apply to the instance at launch time."
  type        = any
  default     = {}
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance" # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)"
  type        = number
  default     = null
}

################################################################################
# IAM Role / Instance Profile
################################################################################

variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

/*variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}*/

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name` or `name`) is used as a prefix"
  type        = bool
  default     = true
}

/*variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}*/

/*variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}*/

/*variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}*/

variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}


################################################################################
# ECR variables
################################################################################
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "aisdlc"
}

variable "image_tag_mutability" {
  description = "Whether to allow image tag overwrites (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "image_retention_limit" {
  description = "Number of images to retain"
  type        = number
  default     = 10
}

variable "enable_repo_policy" {
  description = "Enable repository policy"
  type        = bool
  default     = false
}

variable "repository_policy" {
  description = "ECR repository policy as JSON"
  type        = string
  default     = "{*}"
}

variable "tags" {
  description = "Tags to apply to the repository"
  type        = map(string)
  default     = {}
}
