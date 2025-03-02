resource "aws_security_group_rule" "allow_alb_to_node" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.ingress-lb.alb_security_group_id
  description              = "Allow traffic from ALB to node port 8080"
  depends_on               = [module.eks, module.ingress-lb]
}
