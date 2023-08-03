pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'develeapimg'
                    def imageTag = env.BUILD_ID
                    def dockerImage = docker.build("${imageName}:${imageTag}", '.')
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    def ecrCreds = awsCreds('aws-credentials-id')
                    docker.withRegistry('', ecrCreds) {
                        def imageName = 'develeapimg'
                        def imageTag = env.BUILD_ID
                        dockerImage.push("${imageName}:${imageTag}")
                    }
                }
            }
        }
    }
}
