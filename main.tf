provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_instance" {

  ami                    = "ami-0e86e20dae9224db8"
  instance_type          = "t2.micro"
  key_name               = "test_devops"
  subnet_id              = "subnet-0f0e7d188e79c4d30"
  vpc_security_group_ids = ["sg-03f4c38755df47a73"]

  security_groups = [
    "launch-wizard-1",
  ]

  source_dest_check = true

  tags = {
    "Name" = "test_devops"
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  enclave_options {
    enabled = false
  }

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  root_block_device {
    delete_on_termination = true
    iops                  = 3000
    throughput            = 125
    volume_size           = 8
    volume_type           = "gp3"
  }
}

resource "aws_s3_bucket" "cats_bucket" {
  bucket = "devops-random-cats"
  grant {
    id = "1d56aeaa9b88ca08088efdec1f59195c7bbcda4b0a60a4412cca3bb45488565a"
    permissions = [
      "FULL_CONTROL",
    ]
    type = "CanonicalUser"

  }

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = false
    mfa_delete = false
  }
}

resource "aws_ecr_repository" "cat_container_repo" {

  image_tag_mutability = "MUTABLE"
  name                 = "devops-kitty-cat"

  encryption_configuration {
    encryption_type = "AES256"
    kms_key         = null
  }

  image_scanning_configuration {
    scan_on_push = false
  }
}


