/*  Create 2 VPCs in us-east-1 region  */
#-------------------------------------------------------------------#

#
#
#
#
#


/*  Create VPC A   */
#-----------------#

resource "aws_vpc" "vpcA" {
  cidr_block           = "1.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "VPC-A"
  }
}



/*  Create IGW  */
#----------------#

resource "aws_internet_gateway" "vpcA-IGW" {
  vpc_id = aws_vpc.vpcA.id

  tags = {
    Name = "VPC-A-IGW"
  }
}



/*  Create Webtier Route Table  */
#--------------------------------#

resource "aws_route_table" "vpcA-webtier-route-table" {
  vpc_id = aws_vpc.vpcA.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpcA-IGW.id
  }

  route {
    cidr_block = "2.0.0.0/16"
    gateway_id = aws_ec2_transit_gateway.tg1.id
  }

  tags = {
    Name = "VPC-A_WEB_RT"
  }

  depends_on = [aws_vpc.vpcB, aws_ec2_transit_gateway.tg1]
}


/*  Create a Subnets  */
#---------------------#

resource "aws_subnet" "vpcA-websubnet1" {
  vpc_id            = aws_vpc.vpcA.id
  cidr_block        = var.subnet_cidr[0]
  availability_zone = var.availability_zone[0]

  tags = {
    Name = "vpcA-websubnet1"
  }
}


/*  Associate subnet with Route Table  */
#---------------------------------------#

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.vpcA-websubnet1.id
  route_table_id = aws_route_table.vpcA-webtier-route-table.id
}



/*  Create a network interface with an IP in the subnet created above  */
#-----------------------------------------------------------------------#

resource "aws_network_interface" "vpcA-NIC1" {
  subnet_id       = aws_subnet.vpcA-websubnet1.id
  private_ips     = ["1.0.10.23"]
  security_groups = [aws_security_group.vpcA-websg.id]
}





/*  Assign elastic IPs to the network interfaces  */
#--------------------------------------------------#


resource "aws_eip" "vpcA-EIP1" {
  vpc                       = true
  network_interface         = aws_network_interface.vpcA-NIC1.id
  associate_with_private_ip = "1.0.10.23"
  depends_on                = [aws_internet_gateway.vpcA-IGW]
}




