/*  Launch EC2 instance in vpcA   */
#----------------------------------#

resource "aws_instance" "vpcA-ec2" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone[0]
  user_data         = file("vpcA-userdata.sh")

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpcA-NIC1.id
  }

  key_name = var.key_name
  tags = {
    Name = "ec2vpcA"
  }

  depends_on = [aws_eip.vpcA-EIP1]
}




/*  Launch EC2 instance in vpcB   */
#----------------------------------#
resource "aws_instance" "vpcB-ec2" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = var.availability_zone[1]
  user_data         = file("vpcB-userdata.sh")

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.vpcB-NIC1.id
  }

  key_name = var.key_name
  tags = {
    Name = "ec2vpcB"
  }

  depends_on = [aws_eip.vpcB-EIP1]
}
