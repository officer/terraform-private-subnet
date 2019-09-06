output "subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "route_tables" {
  value = "${aws_route_table.private.*}"
}

