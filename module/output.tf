output "subnets"{
    value =  [for subnet in aws_subnet.subnets : subnet.id]
}