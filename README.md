# PharmaKart E-Commerce Platform - AWS EKS Deployment with Terraform

This repository contains the Terraform code to deploy the PharmaKart e-commerce platform to AWS using Amazon EKS.

## Project Structure
- **modules/**: Contains reusable Terraform modules for VPC, EKS, RDS, and S3.
- **main.tf, variables.tf, outputs.tf**: Main Terraform configuration files.

## Steps to Deploy

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan Deployment
```bash
terraform plan
```

### 3. Apply Deployment
```bash
terraform apply
```


## Cleanup
To destroy all resources:
```bash
terraform destroy
```