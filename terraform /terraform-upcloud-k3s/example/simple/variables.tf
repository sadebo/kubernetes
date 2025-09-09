variable "upcloud_username" {
  type        = string
  description = "UpCloud API username"
  default     = "" # fallback, use env if not set
}

variable "upcloud_password" {
  type        = string
  description = "UpCloud API password"
  sensitive   = true
  default     = "" # fallback, use env if not set
}
