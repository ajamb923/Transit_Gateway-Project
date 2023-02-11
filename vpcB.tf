/*  Create 2 VPCs in us-east-1 region  */
#-------------------------------------------------------------------#

#
#
#
#
#


/*  Create VPC B   */
#-----------------#

resource "aws_vpc" "vpcB" {
  cidr_block           = "2.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "VPC-B"
  }
}



/*  Create IGW  */
#----------------#

resource "aws_internet_gateway" "vpcB-IGW" {
  vpc_id = aws_vpc.vpcB.id

  tags = {
    Name = "VPC-B-IGW"
  }
}



/*  Create Webtier Route Table  */
#--------------------------------#

resource "aws_route_table" "vpcB-webtier-route-table" {
  vpc_id = aws_vpc.vpcB.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcB-IGW.id
  }

  route {
    cidr_block = "1.0.0.0/16"
    gateway_id = aws_ec2_transit_gateway.tg1.id
  }

  tags = {
    Name = "VPC-B_WEB_RT"
  }

  depends_on = [aws_vpc.vpcA, aws_ec2_transit_gateway.tg1]
}


/*  Create a Subnets  */
#---------------------#

resource "aws_subnet" "vpcB-websubnet1" {
  vpc_id            = aws_vpc.vpcB.id
  cidr_block        = var.subnet_cidr[1]
  availability_zone = var.availability_zone[1]

  tags = {
    Name = "vpcB-websubnet1"
  }
}


/*  Associate subnet with Route Table  */
#---------------------------------------#

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.vpcB-websubnet1.id
  route_table_id = aws_route_table.vpcB-webtier-route-table.id
}



/*  Create a network interface with an IP in the subnet created above  */
#-----------------------------------------------------------------------#

resource "aws_network_interface" "vpcB-NIC1" {
  subnet_id       = aws_subnet.vpcB-websubnet1.id
  private_ips     = ["2.0.20.23"]
  security_groups = [aws_security_group.vpcB-websg.id]
}





/*  Assign elastic IPs to the network interfaces  */
#--------------------------------------------------#


resource "aws_eip" "vpcB-EIP1" {
  vpc                       = true
  network_interface         = aws_network_interface.vpcB-NIC1.id
  associate_with_private_ip = "2.0.20.23"
  depends_on                = [aws_internet_gateway.vpcB-IGW]
}

