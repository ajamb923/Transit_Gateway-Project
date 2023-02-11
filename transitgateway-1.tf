/*  Create Transit Gateway 1   */
#-------------------------------#

resource "aws_ec2_transit_gateway" "tg1" {
  description = "Transit gateway for vpcA & vpcB"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "TransitGateway-1"
  }
}


/*  Create Transit Gateway 1 - Route Table  */
#--------------------------------------------#

resource "aws_ec2_transit_gateway_route_table" "tg1-RT" {
  transit_gateway_id = aws_ec2_transit_gateway.tg1.id
  #default_association_route_table = "true"
  #default_association_propagation_route_table = "true"

  tags = {
    Name = "TransitGateway-RT"
  }
}





/*  Create Transit Gateway 1 - Attachment for vpcA  */
#----------------------------------------------------#

resource "aws_ec2_transit_gateway_vpc_attachment" "tg1-attach-vpcA" {
  subnet_ids         = [aws_subnet.vpcA-websubnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg1.id
  vpc_id             = aws_vpc.vpcA.id

  tags = {
    Name = "TG1-attach-vpcA"
  }
}


/*  Create Transit Gateway 1 - Attachment for vpcB  */
#----------------------------------------------------#

resource "aws_ec2_transit_gateway_vpc_attachment" "tg1-attach-vpcB" {
  subnet_ids         = [aws_subnet.vpcB-websubnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg1.id
  vpc_id             = aws_vpc.vpcB.id

  tags = {
    Name = "TG1-attach-vpcB"
  }
}






/*  Create Transit Gateway 1 - Association to Transit Gateway Route Table for vpcA  */
#------------------------------------------------------------------------------------#

resource "aws_ec2_transit_gateway_route_table_association" "tg1-assocc-vpcA" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcA.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}



/*  Create Transit Gateway 1 - Association to Transit Gateway Route Table for vpcB  */
#------------------------------------------------------------------------------------#

resource "aws_ec2_transit_gateway_route_table_association" "tg1-assocc-vpcB" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcB.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}





/*  Create Transit Gateway 1 - Propagation to Transit Gateway Route Table for vpcA  */
#------------------------------------------------------------------------------------#

resource "aws_ec2_transit_gateway_route_table_propagation" "tg1-propag-vpcA" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcA.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}

/*  Create Transit Gateway 1 - Propagation to Transit Gateway Route Table for vpcB  */
#------------------------------------------------------------------------------------#

resource "aws_ec2_transit_gateway_route_table_propagation" "tg1-propag-vpcB" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcB.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}




/*  Create Transit Gateway 1 - Route for vpcA  
#-----------------------------------------------#

resource "aws_ec2_transit_gateway_route" "tg1-route-vpcA" {
  destination_cidr_block         = "1.0.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcB.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}


/*  Create Transit Gateway 1 - Route for vpcB  
#-----------------------------------------------#

resource "aws_ec2_transit_gateway_route" "tg1-route-vpcB" {
  destination_cidr_block         = "2.0.0.0/16"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tg1-attach-vpcA.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tg1-RT.id
}

# Ended up not having to create these Routes since routes will be created after propagation*/