output "outputs" {
  value = [
    "elk proxy server ${aws_instance.elk-proxy.public_dns} - ${aws_instance.elk-proxy.public_ip}",
    "c2 redirection server ${aws_instance.c2-redir.public_dns} - ${aws_instance.c2-redir.public_ip}"
  ]
}
