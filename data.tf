data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["973714476881"]
  name_regex = "Centos-8-DevOps-Practice"
}