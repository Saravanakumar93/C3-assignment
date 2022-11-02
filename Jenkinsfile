pipeline {
    agent { label 'App-node' }
    environment {
        AWS_ACCOUNT_ID="980716488215"
        AWS_DEFAULT_REGION="us-east-1" 
        IMAGE_REPO_NAME="c3-assignment-sara"
        IMAGE_TAG="Latest"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
   
    stages {
        
         stage('Logging into AWS ECR') {
            steps {
                script {
                sh "sudo aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | sudo docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
                 
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Saravanakumar93/C3-assignment.git']]])     
            }
        }
  
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          //dockerImage = sudo docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
          sh "sudo docker build . -t ${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
     steps{  
         script {
                sh "sudo docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "sudo docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }
    
    // Subtask 3 
    stage('Deploy to app host') {
     steps{  
         script {
              sh '''if [ $(sudo docker ps -a | grep app-new | wc -l) -gt 0 ]; then
              sudo docker stop app-new
              sudo docker rm -f app-new
              fi ''' 
              sh "sudo docker run -itd -p 8080:8080 --name app-new ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
         }
        }
      }
    }
}
