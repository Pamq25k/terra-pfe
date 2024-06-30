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
  records = ["${aws_instance.smtp-redir.public_ip}"]
}

resource "aws_route53_record" "mail" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "mail.${var.domain}"
  type    = "A"
  ttl     = "30"
  records = ["${aws_instance.smtp-redir.public_ip}"]
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "MX"
  ttl     = "30"
  records = ["10 mail.${var.domain}"]
}
