pipeline {
    agent any

        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'refs/remotes/origin/main']],
                    userRemoteConfigs: [[
                        credentialsId: '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',
                        url: 'https://github.com/Daniel-Zolo/Develeap.git'
                    ]]
                ])
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'develeapimg'
                    def imageTag = env.BUILD_ID
                    def dockerImage = docker.build("${imageName}:${imageTag}", '.')
                    echo "Docker image built: ${imageName}:${imageTag}"
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    def ecrCreds = awsCreds('AKIARAIVMLW6SAWR5O5H')
                    docker.withRegistry('', ecrCreds) {
                        def imageName = 'develeapimg'
                        def imageTag = env.BUILD_ID
                        dockerImage.push("${imageName}:${imageTag}")
                        echo "Docker image pushed to ECR: ${imageName}:${imageTag}"
                    }
                }
            }
        }
    }
