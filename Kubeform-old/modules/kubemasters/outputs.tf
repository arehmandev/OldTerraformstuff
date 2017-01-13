# outputs
output "aws_instance_kubemasters_id" {
  value = ["${aws_instance.kubemasters.*.id}"]
}
