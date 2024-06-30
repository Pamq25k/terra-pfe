output "outputs" {
  value = [
    "smtp redirection server ${aws_instance.smtp-redir.public_dns} - ${aws_instance.smtp-redir.public_ip}"
  ]
}
