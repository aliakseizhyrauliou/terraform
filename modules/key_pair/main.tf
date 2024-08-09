resource "aws_key_pair" "deployer" {
  key_name   = "my_key"
  public_key = var.pub_key
}