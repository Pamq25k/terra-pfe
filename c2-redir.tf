resource "aws_instance" "c2-redir" {
  ami                    = "ami-0fff1012fc5cb9f25"
  key_name               = "keypair2"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.c2-redir.id, aws_security_group.allow-all-egress.id]
  user_data              = file("files/sysmon4linux.sh")

  tags = {
    Name = "c2-redirector"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./files/keypair2.pem")
    host        = self.public_ip
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "ip_address=\"${aws_instance.elk-proxy.public_ip}\"",
      "hostnames=\"elasticsearch fleet-server\"",
      "host_entry=\"$ip_address   $hostnames\"",
      "echo \"Adding new host entry...\"",
      "echo \"$host_entry\" | sudo tee -a /etc/hosts",
    ]
  }

  /*
  provisioner "remote-exec" {
    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = "ssh -f -N -i ./files/keypair2.pem ubuntu@${self.public_ip} -R 8080:0.0.0.0:8080"
  }

  provisioner "local-exec" {
    command = "ssh -f -N -i ./files/keypair2.pem ubuntu@${self.public_ip} -R 8081:0.0.0.0:8081"
  }
*/

  provisioner "remote-exec" {
    inline = [
      "curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.13.2-linux-x86_64.tar.gz",
      "tar xzvf elastic-agent-8.13.2-linux-x86_64.tar.gz",
      "cd elastic-agent-8.13.2-linux-x86_64",
      "sudo ./elastic-agent install -n -i --url=https://${aws_instance.elk-proxy.public_ip}:8220 --enrollment-token=${var.enrollment-token}"
    ]
  }
}
