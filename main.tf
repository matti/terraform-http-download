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

resource "null_resource" "start" {
  triggers = {
    depends_id = "${var.depends_id}"
  }
}

data "external" "http" {
  depends_on = ["null_resource.start"]
  program    = ["ruby", "${path.module}/http.rb"]

  query = {
    depends_id  = "${var.depends_id}"
    uri         = "${var.uri}"
    max_tries   = "${var.max_tries}"
    interval    = "${var.interval}"
    target_path = "${path.module}/download.${null_resource.start.id}"
  }
}

output "path" {
  value = "${data.external.http.result["path"]}"
}
