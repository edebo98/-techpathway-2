pipeline {
    agent any
    
    environment {
        // ECR Details
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '502376765306'
        ECR_BACKEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/techpathway-backend"
        ECR_FRONTEND = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/techpathway-frontend"
        
        // ECS Details
        ECS_CLUSTER = 'techpathway-cluster'
        BACKEND_SERVICE = 'techpathway-backend-service'
        FRONTEND_SERVICE = 'techpathway-frontend-service'
        
        // AWS Credentials
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📦 Pulling code from GitHub...'
                checkout scm
            }
        }
        
        stage('Login to ECR') {
            steps {
                script {
                    echo '🔐 Logging into AWS ECR...'
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }
        
        stage('Build Backend Image') {
            steps {
                script {
                    echo '🔨 Building backend Docker image...'
                    sh '''
                        cd backend
                        docker build -t techpathway-backend:${BUILD_NUMBER} .
                        docker tag techpathway-backend:${BUILD_NUMBER} ${ECR_BACKEND}:latest
                        docker tag techpathway-backend:${BUILD_NUMBER} ${ECR_BACKEND}:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Build Frontend Image') {
            steps {
                script {
                    echo '🔨 Building frontend Docker image...'
                    sh '''
                        cd frontend
                        docker build -t techpathway-frontend:${BUILD_NUMBER} .
                        docker tag techpathway-frontend:${BUILD_NUMBER} ${ECR_FRONTEND}:latest
                        docker tag techpathway-frontend:${BUILD_NUMBER} ${ECR_FRONTEND}:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    echo '📤 Pushing images to ECR...'
                    sh '''
                        docker push ${ECR_BACKEND}:latest
                        docker push ${ECR_BACKEND}:${BUILD_NUMBER}
                        docker push ${ECR_FRONTEND}:latest
                        docker push ${ECR_FRONTEND}:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Deploy to ECS') {
            steps {
                script {
                    echo '🚀 Triggering ECS deployment...'
                    sh '''
                        aws ecs update-service \
                            --cluster ${ECS_CLUSTER} \
                            --service ${BACKEND_SERVICE} \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                        
                        aws ecs update-service \
                            --cluster ${ECS_CLUSTER} \
                            --service ${FRONTEND_SERVICE} \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo 'Frontend URL: http://techpathway-frontend-alb-2090297865.us-east-1.elb.amazonaws.com'
        }
        failure {
            echo '❌ Pipeline failed. Check logs above.'
        }
        always {
            echo '🧹 Cleaning up Docker images...'
            sh 'docker system prune -f || true'
        }
    }
}