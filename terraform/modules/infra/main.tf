terraform {
  required_version = ">= 0.12.0"
}

locals {
    artifacts_lib = "../../../../dist/Beyond_ETL-0.1-py3-none-any.whl"
    artifacts_job1 = "../../../../example/jobs/job1/pipeline.yml"
    artifacts_job2 = "../../../../example/jobs/job2/pipeline.yml"
    artifacts_jobs2_transform = "../../../../example/jobs/job2/transform"
    artifacts_conf = "../../../../example/conf/glue_infra.conf"
    etl_script = "../../../../belong_etl.py"
    s3_artifacts_lib_key = "artifacts"
    s3_artifacts_example_key = "example"
    s3_etl_scripts_key = "scripts"
    server_side_encryption = "AES256"
    config_bucket_name = "<enter-config-bucket>"
}

/*
resource "aws_s3_bucket" "glue_job_config" {
  bucket = var.config_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "data_storage" {
  bucket = var.data_bucket_name
  force_destroy = true
}*/


resource "aws_s3_bucket_object" "artifacts_lib" {
  bucket = local.config_bucket_name
  key    = "${local.s3_artifacts_lib_key}/Beyond_ETL-0.1-py3-none-any.whl"
  source = local.artifacts_lib
  server_side_encryption = local.server_side_encryption
}



resource "aws_s3_bucket_object" "artifacts_job1" {
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_artifacts_example_key}/jobs/job1/pipeline.yml"
  source                  = local.artifacts_job1
  server_side_encryption  = local.server_side_encryption
}

resource "aws_s3_bucket_object" "artifacts_job1_transform" {
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_artifacts_example_key}/jobs/job1/transform/"
  server_side_encryption  = local.server_side_encryption
}


resource "aws_s3_bucket_object" "artifacts_job2" {
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_artifacts_example_key}/jobs/job2/pipeline.yml"
  source                  = local.artifacts_job2
  server_side_encryption  = local.server_side_encryption
}

resource "aws_s3_bucket_object" "artifacts_job2_transform" {
  for_each                = fileset("${local.artifacts_jobs2_transform}","*.sql")
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_artifacts_example_key}/jobs/job2/transform/${each.value}"
  source                  = "${local.artifacts_jobs2_transform}/${each.value}"
  server_side_encryption  = local.server_side_encryption
}

resource "aws_s3_bucket_object" "artifacts_glue_conf" {
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_artifacts_example_key}/conf/glue_infra.conf"
  source                  = local.artifacts_conf
  server_side_encryption  = local.server_side_encryption

}

resource "aws_s3_bucket_object" "etl_scripts" {
  bucket                  = local.config_bucket_name
  key                     = "${local.s3_etl_scripts_key}/belong_etl.py"
  source                  = local.etl_script
  server_side_encryption  = local.server_side_encryption
}


resource "aws_iam_role" "belong_glue_role" {
  name = "${var.env}_belong_code_challenge_glue_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


resource "aws_iam_policy" "belong_code_challenge_policy" {
  name        = "${var.env}_belong_code_challenge_policy"
  description = "Generic Policy for belong_code_challenge_policy "

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:*",
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:ListAllMyBuckets",
                "s3:GetBucketAcl",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeRouteTables",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-glue-*/*",
                "arn:aws:s3:::*/*aws-glue-*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::crawler-public*",
                "arn:aws:s3:::aws-glue-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:/aws-glue/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ],
            "Condition": {
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "aws-glue-service-resource"
                    ]
                }
            },
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:instance/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "athena:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:CreateDatabase",
                "glue:DeleteDatabase",
                "glue:GetDatabase",
                "glue:GetDatabases",
                "glue:UpdateDatabase",
                "glue:CreateTable",
                "glue:DeleteTable",
                "glue:BatchDeleteTable",
                "glue:UpdateTable",
                "glue:GetTable",
                "glue:GetTables",
                "glue:BatchCreatePartition",
                "glue:CreatePartition",
                "glue:DeletePartition",
                "glue:BatchDeletePartition",
                "glue:UpdatePartition",
                "glue:GetPartition",
                "glue:GetPartitions",
                "glue:BatchGetPartition"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket",
                "s3:PutObject",
                "s3:PutBucketPublicAccessBlock"
            ],
            "Resource": [
                "arn:aws:s3:::aws-athena-query-results-*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::athena-examples*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:ListTopics",
                "sns:GetTopicAttributes"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lakeformation:GetDataAccess"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "belong_code_challenge_glue_role" {
  role       = aws_iam_role.belong_glue_role.name
  policy_arn = aws_iam_policy.belong_code_challenge_policy.arn
}


resource "aws_glue_job" "belong_code_challenge_glue_job_1" {
  name     = "${var.env}_belong_code_challenge_upload_to_s3"
  role_arn = aws_iam_role.belong_glue_role.arn
  glue_version = "2.0"

  command {
    name = "glueetl"
    script_location = "s3://${local.config_bucket_name}/${local.s3_etl_scripts_key}/belong_etl.py"
    python_version = "3"
  }

  default_arguments = {
    "--TempDir": "s3://${local.config_bucket_name}/tmp"
    "--job-language" : "python"
    "--extra-py-files" : "s3://${local.config_bucket_name}/${local.s3_artifacts_lib_key}/Beyond_ETL-0.1-py3-none-any.whl"
    "--pipeline":"s3://${local.config_bucket_name}/${local.s3_artifacts_example_key}/jobs/job1/pipeline.yml"
    "--run_mode": "glue"
    "--config" : "s3://${local.config_bucket_name}/${local.s3_artifacts_example_key}/conf/glue_infra.conf"
    "--enable-glue-datacatalog" : ""
  }
}

resource "aws_glue_job" "belong_code_challenge_glue_job_2" {
  name     = "${var.env}_belong_code_challenge_stats"
  role_arn = aws_iam_role.belong_glue_role.arn
  glue_version = "2.0"

  command {
    name = "glueetl"
    script_location = "s3://${local.config_bucket_name}/${local.s3_etl_scripts_key}/belong_etl.py"
    python_version = "3"
  }

  default_arguments = {
    "--TempDir": "s3://${local.config_bucket_name}/tmp"
    "--job-language" : "python"
    "--extra-py-files" : "s3://${local.config_bucket_name}/${local.s3_artifacts_lib_key}/Beyond_ETL-0.1-py3-none-any.whl"
    "--pipeline":"s3://${local.config_bucket_name}/${local.s3_artifacts_example_key}/jobs/job2/pipeline.yml"
    "--run_mode": "glue"
    "--config" : "s3://${local.config_bucket_name}/${local.s3_artifacts_example_key}/conf/glue_infra.conf"
    "--enable-glue-datacatalog" : ""
  }
}



/*
resource "aws_glue_job" "refresh-partition" {
  name     = "${var.env}_refresh_partitions"
  role_arn = aws_iam_role.dlib_glue_role.arn
  glue_version = "1.0"
  max_capacity = "1.0"

  command {
    name = "pythonshell"
    script_location = "s3://${var.bucket_name}/artifacts/refresh_partitions.py"
    python_version = "3"
  }

  default_arguments = {
    "--bucket=${var.bucket_name}" : "--database=${var.database_name}"
  }
}
*/

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = var.database_name
  depends_on = [aws_glue_job.belong_code_challenge_glue_job_1]
}

/*
resource "null_resource" "create_glue_tables" {
  depends_on = [aws_glue_catalog_database.aws_glue_catalog_database]
  provisioner "local-exec" {
    command = <<EOF
      export AWS_PROFILE=${var.aws_profile}
      export AWS_DEFAULT_REGION=${var.region}
      python3 -m pip install boto3
      python3 -m pip install pyyaml
      python3 -m pip install pyhocon
      python3 ../../../../glue_table_creator.py --env=${var.env}
    EOF
  }
}

*/
