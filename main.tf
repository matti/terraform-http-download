variable "depends_id" {
  default = ""
}

variable "uri" {}

variable "max_tries" {
  default = "3"
}

variable "interval" {
  default = "1"
}

data "external" "http" {
  program = ["ruby", "${path.module}/http.rb"]

  query = {
    depends_id = "${var.depends_id}"
    uri        = "${var.uri}"
    max_tries  = "${var.max_tries}"
    interval   = "${var.interval}"
  }
}

output "path" {
  value = "${data.external.http.result["path"]}"
}
