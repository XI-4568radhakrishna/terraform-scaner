/*output "ec2"{
  value = aws_ec2_instance.aisdlc_instance.id
 }*/

output "private_key_path" {
  value     = local_file.private_key.filename
  sensitive = true
}

output "instance_public_ip" {
  value = aws_instance.aisdlc_instance.public_ip
}

output "ecr_repository_url" {
  value = aws_ecr_repository.sdlc_repo.repository_url
}

output "bucket_name" {
  value = aws_s3_bucket.sdlc_terraform_state.id
}

output "cluster_id" {
  value = aws_eks_cluster.sdlc_eks_cluster.id
}