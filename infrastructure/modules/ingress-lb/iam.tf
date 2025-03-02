resource "aws_iam_policy" "lb_controller_additional" {
  name   = "AWSLoadBalancerControllerAdditionalPolicy"
  description = "Additional permissions for AWS Load Balancer Controller"
  policy = file("${path.module}/alb-controller-policy.json")
}

# Create IAM role for the AWS Load Balancer Controller
module "lb_controller_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "~> 5.3.0"

  role_name = "eks-alb-controller-role"
  
  attach_load_balancer_controller_policy = true

  role_policy_arns = {
    additional = aws_iam_policy.lb_controller_additional.arn
  }
  
  oidc_providers = {
    ex = {
      provider_arn               = var.provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  
  tags = {
    Project   = "Pharmakart"
    ManagedBy = "Terraform"
  }
}