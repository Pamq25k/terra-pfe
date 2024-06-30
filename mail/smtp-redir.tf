resource "aws_instance" "smtp-redir" {
  ami                    = "ami-0fff1012fc5cb9f25"
  key_name               = "keypair2"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.mail-redir.id, aws_security_group.allow-all-egress.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../files/keypair2.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      # postfix
      #"export DEBIAN_FRONTEND=noninteractive; sudo apt update && sudo apt-get -y -qq install socat postfix opendkim opendkim-tools certbot",
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt -y -qq install socat postfix opendkim opendkim-tools certbot",

      #"echo \"@reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.phishing.ipv4_address}:80\" | sudo tee -a /etc/cron.d/mdadm",
      #"echo \"@reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.phishing.ipv4_address}:443\" | sudo tee -a /etc/cron.d/mdadm"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${var.domain}' | sudo tee /etc/mailname",
      "echo '${self.public_ip} ${var.domain}' | sudo tee /etc/hosts",
      "sudo postconf -e myhostname=${var.domain}",
      "sudo postconf -e milter_protocol=2",
      "sudo postconf -e milter_default_action=accept",
      "sudo postconf -e smtpd_milters=inet:localhost:12345",
      "sudo postconf -e non_smtpd_milters=inet:localhost:12345",
      "sudo postconf -e mydestination=\"${var.domain}, $myhostname, localhost.localdomain, localhost\"",
      "sudo postconf -e mynetworks=\"127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128\"",
      #"postconf -e mynetworks=\"127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ${digitalocean_droplet.phishing.ipv4_address}\"",

      # "postconf -e smtpd_tls_cert_file=/etc/letsencrypt/live/${var.domain}/fullchain.pem",
      # "postconf -e smtpd_tls_key_file=/etc/letsencrypt/live/${var.domain}/privkey.pem",
      # "postconf -e smtpd_tls_security_level=may",
      # "postconf -e smtp_tls_security_level=encrypt",    	
      # "postconf -e smtpd_use_tls=no",    	

      # dkim
    ]
  }

  provisioner "file" {
   source = "./files/dkim_setup.sh"
   destination = "/tmp/dkim_setup.sh"
}

  provisioner "remote-exec" {
    inline = [
     "chmod +x /tmp/dkim_setup.sh; sudo /tmp/dkim_setup.sh ${var.domain}"
    ]
  }

  provisioner "file" {
    source      = "./configs/header_checks"
    destination = "/home/ubuntu/header_checks"
  }

  provisioner "file" {
    source      = "./configs/master.cf"
    destination = "/home/ubuntu/master.cf"
  }

  provisioner "file" {
    source      = "./configs/opendkim.conf"
    destination = "/home/ubuntu/opendkim.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/header_checks /etc/postfix/header_checks",
      "sudo mv /home/ubuntu/master.cf /etc/postfix/master.cf",
      "sudo mv /home/ubuntu/opendkim.conf /etc/opendkim.conf"
    ]
  }

  provisioner "local-exec" {
    command = "echo ssh -o StrictHostKeyChecking=no -i ../files/keypair2.pem ubuntu@${self.public_ip} sudo certbot certonly --standalone -d ${var.domain} --register-unsafely-without-email --agree-tos > finalize.sh"
  }

  provisioner "local-exec" {
    command = "echo ssh -o StrictHostKeyChecking=no -i ../files/keypair2.pem ubuntu@${self.public_ip} sudo cat /root/dkim.txt >> finalize.sh"
  }

  /*  provisioner "local-exec" {
    command = "echo rm finalize.sh >> finalize.sh; chmod +x finalize.sh"
  } */

  provisioner "remote-exec" {
    inline = [
      # "postmap /etc/postfix/header_checks",
      # "postfix reload",
      # "service postfix restart; service opendkim restart"
      "sudo shutdown -r"
    ]
  }
}
