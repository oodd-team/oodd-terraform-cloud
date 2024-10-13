module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "eks-cluster"
  cluster_version = "1.21"
  subnet_ids      = [aws_subnet.private_subnet.id]
  vpc_id          = aws_vpc.main_vpc.id
  eks_managed_node_groups = {
    dev_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = aws_key_pair.bastion_key.key_name
      security_groups  = [aws_security_group.dev_sg.id]
    },
    prod_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      key_name         = aws_key_pair.bastion_key.key_name
      security_groups  = [aws_security_group.prod_sg.id]
    }
  }
}