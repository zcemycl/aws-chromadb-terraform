variable "aws_region" {
  default = "eu-west-2"
  type    = string
}

variable "vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "vpc_r53_resolver_ip" {
  description = "vpc cidr +2 is the vpc route 53 resolver ip"
  default     = "10.1.0.2"
}

variable "aws_az" {
  default = "eu-west-2a"
}

variable "author" {
  default = "Leo"
}

variable "instance_type" {
  default = "t3.small"
}

variable "public_subnets_cidr" {
  default = ["10.1.0.0/21"]
}

variable "chroma_subnets_cidr" {
  default = ["10.1.16.0/21"]
}

variable "vpn_cidr_block" {
  default = "10.1.144.0/22"
}

variable "availability_zones" {
  default = ["eu-west-2a"]
}

variable "fargate_ephemeral_storage_size" {
  default = 24
}

variable "internal_domain_name" {
  default = "service.internal"
}

variable "internal_serv_name" {
  default = "test"
}

variable "acme_server_url" {
  description = "default currently set to the lets encrypt staging environment, comment below is production environment."
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "api_port" {
  default = 3000
}

variable "server_crt_path" {
  default = "~/my-vpn-files/server.crt"
}

variable "server_key_path" {
  default = "~/my-vpn-files/server.key"
}

variable "ca_cert_path" {
  default = "~/my-vpn-files/ca.crt"
}

variable "client_crt_path" {
  default = "~/my-vpn-files/client1.domain.tld.crt"
}

variable "client_key_path" {
  default = "~/my-vpn-files/client1.domain.tld.key"
}
