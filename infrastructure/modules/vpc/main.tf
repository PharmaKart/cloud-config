module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  manage_default_security_group = false

  tags = {
    Name        = var.vpc_name
    Project     = "Pharmakart"
    "ManagedBy" = "Terraform"
  }

  database_subnet_group_name = "${var.vpc_name}-database-subnet-group"

  public_subnet_tags_per_az = { for az in var.availability_zones :
    az => {
      Role = "public"
      Name = "${var.vpc_name}-public-subnet-${az}"
    }
  }

  private_subnet_tags_per_az = { for az in var.availability_zones :
    az => {
      Role = "private"
      Name = "${var.vpc_name}-private-subnet-${az}"
    }
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  database_subnet_tags = {
    Role = "database"
    Name = "${var.vpc_name}-database-subnet"
  }

  private_route_table_tags = {
    Name = "${var.vpc_name}-private-route-table"
  }

  database_route_table_tags = {
    Name = "${var.vpc_name}-database-route-table"
  }

  igw_tags = {
    Name = "${var.vpc_name}-igw"
  }

  nat_gateway_tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}
