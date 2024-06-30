resource "aws_instance" "elk-proxy" {
  ami                    = "ami-0fff1012fc5cb9f25"
  key_name               = "keypair2"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.elk.id, aws_security_group.allow-all-egress.id]

  tags = {
    Name = "elk-proxy"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./files/keypair2.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo \"GatewayPorts clientspecified\" | sudo tee -a /etc/ssh/sshd_config", "sudo systemctl restart sshd"]
  }

  provisioner "remote-exec" {
    inline = ["echo connected"]
  }

  provisioner "local-exec" {
    command = "ssh -f -N -o \"StrictHostKeyChecking no\" -i ./files/keypair2.pem ubuntu@${self.public_ip} -R :9200:0.0.0.0:9200"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.13.2-linux-x86_64.tar.gz",
      "tar xzvf elastic-agent-8.13.2-linux-x86_64.tar.gz",
      "cd elastic-agent-8.13.2-linux-x86_64",
      "sudo ./elastic-agent install -n --fleet-server-es=https://localhost:9200 --fleet-server-service-token=${var.service-token} --fleet-server-policy=fleet-server-policy --fleet-server-port=8220 --fleet-server-es-insecure --insecure"
    ]
  }
}
