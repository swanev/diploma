

resource "aws_codebuild_project" "front-docker-build" {
  name          = "front-docker-build"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
        name = "AWS_DEFAULT_REGION" 
        value = var.vpc_region
    }  
    environment_variable {
        name = "AWS_ACCOUNT_ID" 
        value = var.aws_account_id
     }  

    environment_variable {
        name = "IMAGE_REPO_NAME" 
        value = var.ecr_name
     }  

    environment_variable {
        name = "IMAGE_TAG" 
        value = "front"
     }                    
 }


  source {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/front-buildspec.yml")
  }
}

resource "aws_codebuild_project" "back-docker-build" {
  name          = "back-docker-build"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
        name = "AWS_DEFAULT_REGION" 
        value = var.vpc_region
    }  
    environment_variable {
        name = "AWS_ACCOUNT_ID" 
        value = var.aws_account_id
     }  

    environment_variable {
        name = "IMAGE_REPO_NAME" 
        value = var.ecr_name
     }  

    environment_variable {
        name = "IMAGE_TAG" 
        value = "back"
     }  

 }
  source {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/back-buildspec.yml")
  }
}

resource "aws_codebuild_project" "back-deploy" {
  name          = "back-deploy"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
        name = "AWS_DEFAULT_REGION" 
        value = var.vpc_region
    }  
    environment_variable {
        name = "AWS_ACCOUNT_ID" 
        value = var.aws_account_id
     }  

    environment_variable {
        name = "IMAGE_REPO_NAME" 
        value = var.ecr_name
     }  

    environment_variable {
        name = "IMAGE_TAG" 
        value = "back"
     }
    environment_variable {
        name = "EKS_KUBECTL_ROLE_ARN" 
        value = "arn:aws:iam::$AWS_ACCOUNT_ID:role/terraform-eks-diploma-cluster"
     }

    environment_variable {
        name = "EKS_CLUSTER_NAME" 
        value = var.cluster-name
     }     

    environment_variable {
        name = "KUBECTL_URL" 
        value = "https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl"
     }           

 }
  source {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/back-deploy.yml")
  }
}

resource "aws_codebuild_project" "front-deploy" {
  name          = "front-deploy"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
        name = "AWS_DEFAULT_REGION" 
        value = var.vpc_region
    }  
    environment_variable {
        name = "AWS_ACCOUNT_ID" 
        value = var.aws_account_id
     }  

    environment_variable {
        name = "IMAGE_REPO_NAME" 
        value = var.ecr_name
     }  

    environment_variable {
        name = "IMAGE_TAG" 
        value = "back"
     }

    environment_variable {
        name = "EKS_KUBECTL_ROLE_ARN" 
        value = "arn:aws:iam::$AWS_ACCOUNT_ID:role/terraform-eks-diploma-cluster"
     }

    environment_variable {
        name = "EKS_CLUSTER_NAME" 
        value = var.cluster-name
     }      

    environment_variable {
        name = "KUBECTL_URL" 
        value = "https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl"
     }     

 }
  source {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/front-deploy.yml")
  }
}

resource "aws_codepipeline" "cicd_pipeline" {

    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["Docker-container"]
            configuration = {
                FullRepositoryId = "swanev/diploma"
                BranchName   = "master"
                ConnectionArn = var.codestar_connector_credentials
#                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name ="Front"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["Docker-container"]
            configuration = {
                ProjectName = "front-docker-build"
            }
        }
    }

    stage {
        name ="Back"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["Docker-container"]
            configuration = {
                ProjectName = "back-docker-build"
            }
        }
    }

    stage {
        name ="Back-deploy"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["Docker-container"]
            configuration = {
                ProjectName = "back-deploy"
            }
        }
    }

    stage {
        name ="Front-deploy"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["Docker-container"]
            configuration = {
                ProjectName = "front-deploy"
            }
        }
    }    

}