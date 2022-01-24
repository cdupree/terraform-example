

# create a VPC
resource "aws_vpc" "three_tier" {
  cidr_block = "172.16.0.0/16"
}

# and split it into 2 parts.  The first part
# can directly access the internet.
resource "aws_subnet" "three_tier_public" {
  vpc_id = aws_vpc.three_tier.id
  cidr_block = "172.16.0.0/17"
}

# the second part will need to use NAT (Network Address Translation)
resource "aws_subnet" "three_tier_private" {
  vpc_id = aws_vpc.three_tier.id
  cidr_block = "172.16.128.0/17"
}

# the public subnet will use a Internet Gateway to directly access
# the Internet.
resource "aws_internet_gateway" "three_tier" {
  vpc_id = aws_vpc.three_tier.id
}

resource "aws_route_table" "three_tier_public" {
  vpc_id = aws_vpc.three_tier.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_internet_gateway.three_tier.id
  }
}

resource "aws_route_table_association" "three_tier_public" {
  subnet_id = aws_subnet.three_tier_public.id
  route_table_id = aws_route_table.three_tier_public.id
}

# and the second way to connect is via a NAT gateway 
# which writes the instanace IP to a public IP.  To do
# this we need to allocate that public IP.

resource "aws_eip" "three_tier_nat_gateway" {
  vpc = true
}

# and we need a route table
resource "aws_route_table" "three_tier_private" {
  vpc_id = aws_vpc.three_tier.id
  route {
    cidr_block = "0.0.0.0./0"
    nat_gateway_id = aws_nat_gateway.three_tier.id
  }
}

# and we need to associate with our subnet
resource "aws_route_table_association" "three_tier_private" {
  subnet_id = aws_subnet.three_tier_private.id
  route_table_id = aws_route_table.three_tier_private.id  
}


# and now we can set up the NAT gateway
resource "aws_nat_gateway" "three_tier" {
  allocation_id = aws_eip.three_tier_nat_gateway.id
  subnet_id = aws_subnet.three_tier_private.id
}




