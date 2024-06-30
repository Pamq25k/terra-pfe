resource "aws_route53_zone" "primary" {
  name = var.domain

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "30"
  records = ["${aws_instance.elk-proxy.public_ip}"]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain}"
  type    = "A"
  ttl     = "30"
  records = ["${aws_instance.elk-proxy.public_ip}"]
}
