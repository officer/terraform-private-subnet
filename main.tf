locals {
  natgateway_count  = "${var.nat_gateway_enabled == "true" ? 1 : 0}"
  subnet_count      = "${length(var.availability_zones)}"
}


resource "aws_subnet" "private" {
  count             = "${local.subnet_count}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(local.subnet_count, 2)), count.index)}"

  tags = "${
    merge(
      var.tags,
      map(
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "private"
      )
    )
  }"
}

resource "aws_network_acl" "private" {
  count      = "${local.subnet_count > 0 ? 1 : 0}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = "${aws_subnet.private.*.id}"
  
  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  depends_on = [
    "aws_subnet.private"
  ]

  tags = "${
    merge(
      var.tags,
      map(
        "VPC", "${var.vpc_id}"
      )
    )
  }"
}

resource "aws_route_table" "private" {
  count     = "${local.subnet_count}"
  vpc_id    = "${var.vpc_id}"
}

resource "aws_route" "private" {
  count                  = "${local.natgateway_count > 0 ? local.subnet_count : 0}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${local.natgateway_count > 0 ? var.nat_gateway_id : "" }"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}

resource "aws_route_table_association" "private" {
  count          = "${local.natgateway_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}
