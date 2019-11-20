# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
}

# create the 4 Subnets
resource "aws_subnet" "public" {
  count = "${length(var.subnet_cidrs_public)}"

  vpc_id = "${aws_vpc.My_VPC.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
}

resource "aws_subnet" "private" {
  count = "${length(var.subnet_cidrs_private)}"

  vpc_id = "${aws_vpc.My_VPC.id}"
  cidr_block = "${var.subnet_cidrs_private[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
}

# Create the Route Table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.My_VPC.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.My_VPC.id
}

# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
} 

#create the elasticIP
resource "aws_eip" "nat" {
  vpc      = true
}

# Create the NAT Gateways
resource "aws_nat_gateway" "My_NAT_GW" {
  count = 2
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = [aws_internet_gateway.My_VPC_GW]

  tags = {
    Name = "My NAT Gateway"
  }
}


# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id        = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.My_VPC_GW.id}"
}

resource "aws_route" "My_VPC_NAT_access" {
  count = 2
  route_table_id        = "${element(aws_route_table.private_route_table.*.id, count.index)}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  nat_gateway_id             = "${element(aws_nat_gateway.My_NAT_GW.*.id, count.index)}"
}


# Associate the Route Tables with the Subnet
resource "aws_route_table_association" "public" {
  count = "${length(var.subnet_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.subnet_cidrs_private)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_route_table.*.id, count.index)}"
}