data "aws_ami" "latest_amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y

  # Install AWS CLI
  sudo yum install -y aws-cli

  # Install PostgreSQL client
  sudo yum install -y postgresql16

  # Install K9s
  sudo -u ec2-user bash << 'EOS'
    curl -sS https://webi.sh/k9s | bash
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
  EOS

  # Install kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/

  # Create a script to configure kubectl later
  echo '#!/bin/bash' > /home/ec2-user/configure-kubectl.sh
  echo 'aws eks update-kubeconfig --region ${var.aws_region} --name ${var.eks_cluster_name}' >> /home/ec2-user/configure-kubectl.sh
  chmod +x /home/ec2-user/configure-kubectl.sh

  echo "EKS is not available yet. Run /home/ec2-user/configure-kubectl.sh after EKS is deployed."
EOF

  tags = {
    Name      = var.bastion_name
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.bastion_name}-key"
  public_key = file("${path.module}/bastion_key.pub")

  tags = {
    Name      = "${var.bastion_name}-key"
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}
