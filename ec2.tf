data "aws_subnet_ids" "my_subnet_ids" {
  vpc_id = "${aws_vpc.default.id}"
}

data "aws_subnet" "subnets" {
  count = "${length(data.aws_subnet_ids.my_subnet_ids.ids)}"
  id    = "${data.aws_subnet_ids.my_subnet_ids.ids[count.index]}"
}

resource "aws_instance" "servers" {
    count = 3
    ami = "${lookup(var.amis, var.aws_region)}"
    #availability_zone = "${element(var.azs, count.index)}"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    subnet_id = "${element(data.aws_subnet_ids.my_subnet_ids.ids, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true	
    tags {
        Name = "Terraform-Server-${count.index+1}"
        Env = "Prod"
        Owner = "Sree"
    }
}
