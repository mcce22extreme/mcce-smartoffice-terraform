variable "azure_location" {
  type        = string
  default     = "westeurope"
}

variable "azure_resourcegroup" {
  type        = string
}

variable "smartoffice_mqtt_hostname" {
  type        = string
}

variable "smartoffice_mqtt_port" {
  type        = string
  default     = "1883"
}

variable "smartoffice_mqtt_username" {
  type        = string
  default     = "iot"
}

variable "smartoffice_mqtt_password" {
  type        = string
}

variable "smartoffice_databasename" {
  type        = string
  default     = "Smartoffice"
}

variable "smartoffice_databasetype" {
  type        = string
  default     = "CosmosDb"
}

variable "smartoffice_authurl" {
  type        = string
}

variable "smartoffice_authclientid" {
  type        = string
  default     = "smartoffice"
}
