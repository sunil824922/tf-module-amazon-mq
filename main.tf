resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "RABBITMQ"
    from_port   = var.port_no
    to_port     = var.port_no
    protocol    = "tcp"
    cidr_blocks = var.allow_db_cidr
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {Name = "${var.name}-${var.env}-sg" })
}


resource "aws_instance" "rabbitmq" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnets[0]
  vpc_security_group_ids = [ aws_security_group.main.id ]

  tags = merge(var.tags, {Name = "${var.name}-${var.env}-sg" })
  root_block_device {
    encrypted = true
    kms_key_id = var.kms_arn
  }
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    rabbitmq_appuser_password = "rabbitmq"
  }))
}











