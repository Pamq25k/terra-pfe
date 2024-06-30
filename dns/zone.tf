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
  records = ["192.44.44.44"]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain}"
  type    = "A"
  ttl     = "30"
  records = ["192.44.44.45"]
}
