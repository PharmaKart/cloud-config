# Cloud Configuration for PharmaKart

The **Cloud Config Repository** is Repository containing Terraform-based solution for deploying PharmaKart's infrastructure on AWS. It is designed to provide scalability, security, and high availability while utilizing AWS services such as ECS, EKS, RDS, and S3.

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Modules](#modules)
4. [Prerequisites](#prerequisites)
5. [Setup and Installation](#setup-and-installation)
6. [Running the Service](#running-the-service)
7. [Terraform Destroy (Staging/Development Environments)](#terraform-destroy-stagingdevelopment-environments)
8. [Contributing](#contributing)
9. [License](#license)

---

## Overview

This **Cloud Configuration** automates the deployment of infrastructure components using Terraform. The configuration is designed to:

- Deploy scalable and secure cloud infrastructure with AWS services like ECS, EKS, and RDS.
- Implement a robust CI/CD pipeline using AWS CodePipeline and CodeBuild.
- Set up a Virtual Private Cloud (VPC) with proper networking and security configurations.

---

## Features

- **Scalable Infrastructure**:

  - Utilizes ECS for frontend deployments and EKS for backend microservices.
  - Includes auto-scaling policies to handle varying traffic loads.

- **CI/CD Pipeline**:

  - Automates build and deployment processes using AWS CodePipeline and CodeBuild.
  - Pushes Docker images to ECR for seamless container management.

- **VPC and Networking**:

  - Configures a secure VPC with public and private subnets, route tables, and security groups.
  - Implements load balancing using AWS Application Load Balancer (ALB) and internal ingress load balancers.

- **Security**:
  - Configures IAM roles and policies for secure access to AWS resources.
  - Ensures access control by assigning appropriate permissions to different components of the infrastructure.

---

## Modules

Each module in this repository is designed to manage a specific AWS resource. Below are the descriptions of each module:

- **`alb`**: Configures an **Application Load Balancer (ALB)** to route frontend traffic to ECS tasks, ensuring high availability and scalability.
- **`bastion`**: Deploys a **Bastion Host** that serves as a secure access point to manage AWS resources like the EKS cluster and RDS database. It includes SSH key management and security group configurations.
- **`codebuild`**: Configures **AWS CodeBuild** to automate the build process. Integrates with CodePipeline to push built Docker images to Amazon ECR.
- **`codepipeline`**: Defines **AWS CodePipeline** configurations to set up a continuous integration and continuous delivery pipeline for seamless deployments.
- **`ecr`**: Creates an **Elastic Container Registry (ECR)** repository for storing Docker images, which are then used in ECS or EKS.
- **`ecs`**: Configures an **Elastic Container Service (ECS)** cluster for deploying and managing Docker containers, specifically for the frontend application.
- **`eks`**: Configures an **Elastic Kubernetes Service (EKS)** cluster for deploying backend microservices, managing the Kubernetes infrastructure on AWS.
- **`ingress-lb`**: Deploys an **Ingress Load Balancer** to route internal traffic within the Kubernetes cluster, managing traffic exposure through defined ingress rules.
- **`k8s-manifests`**: Contains **Kubernetes manifests** for deploying backend microservices, including configurations for services, deployments, secrets, and configmaps.
- **`rds`**: Configures a **Relational Database Service (RDS)** instance, setting up PostgreSQL (or another supported database) for backend storage.
- **`s3`**: Creates an **S3 bucket** for storing static content, code artifacts, and other related files used in the pipeline.
- **`vpc`**: Defines the **Virtual Private Cloud (VPC)**, including subnets, route tables, and network interfaces to ensure network isolation and secure communication between resources.

---

## Prerequisites

Before setting up the configuration, ensure the following tools are installed:

- **Terraform**: [Download Terraform](https://developer.hashicorp.com/terraform/install)
- **AWS CLI**: [Install AWS CLI](https://aws.amazon.com/cli/)
- **Git**: [Download Git](https://git-scm.com/downloads)

### Configuring AWS CLI

To interact with AWS, configure your AWS CLI with your credentials by running the following command:

```bash
aws configure
```

You will be prompted to enter:

- **AWS Access Key ID**: Your AWS access key.
- **AWS Secret Access Key**: Your AWS secret access key.
- **Default region name**: The AWS region you want to use (e.g., `ca-central-1`).
- **Default output format**: Set to `json` or another preferred format.

---

## Setup and Installation

### 1. Clone the Repository

Clone the repository and navigate to the `infrastructure` directory:

```bash
git clone https://github.com/PharmaKart/Cloud-config.git
cd Cloud-config/infrastructure
```

### 2. Update `terraform.tfvars`

- Copy `terraform.tfvars.bak` to `terraform.tfvars`.
- Edit the `terraform.tfvars` file to configure the following:
  - `account_id`: Your AWS account ID.
  - `bastion_private_key_path`: Path to your private SSH key for Bastion host access.
  - Other sensitive values such as AWS credentials, region, and networking settings.

**Important:** The `terraform.tfvars` file often contains sensitive information such as credentials, keys, and passwords. Avoid committing this file to version control. Instead, add `terraform.tfvars` to your `.gitignore` file to ensure it remains private.

### 3. Generate SSH Key

If you do not already have an SSH key pair, generate one by running:

```bash
ssh-keygen -t rsa -b 2048 -f bastion_key
```

- Copy the generated public key to the Bastion module directory:

```bash
cp bastion_key.pub infrastructure/modules/bastion/bastion_key.pub
```

- Set the `bastion_private_key_path` in `terraform.tfvars` to the path of the generated private key.

### 4. Initialize Terraform

Run the following command to initialize Terraform:

```bash
terraform init
```

### 5. Plan Changes

To preview the changes Terraform will make, run:

```bash
terraform plan
```

### 6. Apply Configuration

To apply the infrastructure configuration, run:

```bash
terraform apply
```

### 7. After Deployment

Upon successful deployment, Terraform will print important outputs such as:

- **Load Balancer DNS Name** for accessing the frontend and backend.
- **Bastion Host IP** for secure access to the infrastructure.
- **RDS Endpoint** for database connections.

---

## Running the Service

Once the configuration is applied, your AWS infrastructure will be provisioned, and services will be deployed.

### Accessing the Services

- **ECS**: The frontend application will be deployed using **Amazon ECS**. You can access the application via the **Application Load Balancer (ALB)** DNS name.
- **EKS**: The backend microservices will be deployed on the **Amazon EKS** cluster. These services can be accessed through the **Application Load Balancer (ALB)** DNS name, which is provisioned by the **ingress-lb** module.
- **RDS**: The **Amazon RDS** relational database service can be securely accessed within the **VPC** or through the **Bastion Host** for administrative access.

---

## Terraform Destroy (Staging/Development Environments)

If you are working in a **staging** or **development** environment and need to tear down the infrastructure, you can use `terraform destroy` to remove all resources created by Terraform.

### Steps to Destroy the Infrastructure

1. **Navigate to the infrastructure directory** (where your `main.tf` and other Terraform files are located).

2. **Run the following command** to destroy the infrastructure:

   ```bash
   terraform destroy
   ```

3. **Confirm the destruction**: You will be prompted to confirm the destruction. Type `yes` to proceed.

   ```bash
   Do you really want to destroy all resources? (y/n) yes
   ```

### Important Considerations

- **Data Loss**: Running `terraform destroy` will delete all AWS resources created by the configuration (e.g., ECS services, EKS clusters, RDS instances). Ensure that no critical data is lost, or back up important data before running this command.
- **Environment Specific**: This is typically used for non-production environments (staging or development). For production environments, always ensure proper backup and review before destroying any resources.

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Support

For any questions or issues, please open an issue in the repository or contact the maintainers.
