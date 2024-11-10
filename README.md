# AWS CodeDeploy with Terraform

<img src=cover.png>

This project demonstrates how to deploy a Node.js application to an EC2 instance using AWS CodeDeploy with Terraform and GitHub Actions. The setup includes automatic provisioning of AWS resources and deployment of the application using a simple CI/CD pipeline.

## Project Structure

```
.
├── appspec.yml                     # AWS CodeDeploy configuration file
├── myapp/                          # Node.js application files
│   ├── index.js
│   └── ...                         # Other application files
├── scripts/                        # Deployment scripts
│   ├── install_dependencies.sh     # Script to install dependencies
│   └── start_application.sh        # Script to start the Node.js application
├── terraform/                      # Terraform configuration files
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md                       # Project documentation
```


## Prerequisites

- AWS CLI configured with appropriate access.
- Terraform installed on your local machine.
- An AWS account with permissions to create and manage EC2, S3, IAM, and CodeDeploy resources.

## Setup Instructions

### 1. Configure Terraform

1. **Navigate to the `terraform/` directory:**

   ```bash
   cd terraform/
   ```

2. **Initialize Terraform:**

   ```bash
   terraform init
   ```

3. **Edit the `variables.tf` file:**

   - Define your desired settings for the deployment, such as the AWS region, EC2 instance type, and AMI ID.

4. **Create `terraform.tfvars` file:**

   - That include your public ssh key to be able to access the EC2.

5. **Apply the Terraform configuration:**
   ```bash
   terraform apply
   ```
   - This command will provision the necessary AWS resources, including an EC2 instance, S3 bucket, and IAM roles.

### 2. Prepare the Application for Deployment

1. **Zip your application files:**

   - Include the `appspec.yml`, `myapp/`, and `scripts/` directories in the root of the zip file.

   ```bash
   zip -r myapp.zip appspec.yml myapp/ scripts/
   ```

2. **Upload the zip file to S3:**
   - Use the AWS CLI to upload the deployment package to your S3 bucket.
   ```bash
   aws s3 cp myapp.zip s3://<your-s3-bucket>/myapp.zip
   ```

### 3. Deploy the Application with CodeDeploy

1. **Create a deployment using AWS CLI:**

   ```bash
   aws deploy create-deployment \
     --application-name MyCodeDeployApp \
     --deployment-config-name CodeDeployDefault.OneAtATime \
     --deployment-group-name MyDeploymentGroup \
     --s3-location bucket=<your-s3-bucket>,bundleType=zip,key=myapp.zip
   ```

2. **Monitor the Deployment:**
   - Use the AWS Management Console or the AWS CLI to monitor the progress of the deployment.
   - Check the logs if the deployment fails to troubleshoot issues.

### 4. Access Your Application

- Once the deployment is successful, access your application using the public IP or DNS of the EC2 instance:
  ```bash
  http://<public-ip-or-dns>
  ```