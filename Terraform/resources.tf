resource "aws_iam_user" "DeveleapIAM" {
  name = "DeveleapIAM"
}

resource "aws_iam_role" "DeveleapRole" {
  name = "DeveleapRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
EOF  
}


resource "aws_iam_policy" "DeveleapPolicy" {
  name        = "DeveleapIAMPloicy"
  description = "IAM policy for Develeap role"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "DeveleapRolePolicyAttachment" {
  role       = aws_iam_role.DeveleapRole.name
  policy_arn = aws_iam_policy.DeveleapPolicy.arn
}

resource "aws_iam_user_policy_attachment" "DeveleapUserPolicyAttachment" {
  user       = aws_iam_user.DeveleapIAM.name
  policy_arn = aws_iam_policy.DeveleapPolicy.arn
}

resource "aws_iam_role_policy_attachment" "DeveleapClusterPolicyAttachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.DeveleapRole.name
}

resource "tls_private_key" "Private" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "KeyPair" {
  key_name   = "DeveleapKey"
  public_key = tls_private_key.Private.public_key_openssh
}

resource "aws_instance" "DeveleapInstance" {
  ami           = "ami-0384d2fb286d0a376"
  instance_type = "t3.small"
  key_name      = aws_key_pair.KeyPair.key_name

  tags = {
    Name = "DeveleapV2"
  }
}

resource "aws_eks_cluster" "DeveleapCluster" {
  name     = "DeveleapNewEKS"
  role_arn = aws_iam_role.DeveleapRole.arn

   vpc_config {
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
 }
  depends_on = [
  aws_iam_role.DeveleapRole,
 ]
}