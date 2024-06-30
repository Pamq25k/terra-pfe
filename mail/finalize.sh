ssh -o StrictHostKeyChecking=no -i ../files/keypair2.pem ubuntu@13.60.26.60 sudo certbot certonly --standalone -d definitelynotpwc.com --register-unsafely-without-email --agree-tos
ssh -o StrictHostKeyChecking=no -i ../files/keypair2.pem ubuntu@13.60.26.60 sudo cat /root/dkim.txt
