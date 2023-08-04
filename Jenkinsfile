pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = '069301198269.dkr.ecr.eu-north-1.amazonaws.com/develeapimg'
        ECR_REPO_NAME = 'develeapimg'
        AWS_REGION = 'eu-north-1'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
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
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'Develeap', accessKeyVariable: 'AKIARAIVMLW6SAWR5O5H', secretKeyVariable: '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']]) {
                        def awsLogin = sh(script: "aws ecr get-login --no-include-email --region eu-north-1", returnStdout: true).trim()
                        sh(script: "${awsLogin}")
                        sh(script: "docker tag develeapimg:21 069301198269.dkr.ecr.eu-north-1.amazonaws.com/develeapimg/develeapimg:21")
                        sh(script: "docker push 069301198269.dkr.ecr.eu-north-1.amazonaws.com/develeapimg/develeapimg:21")
                    }
                }
            }
        }
    }
}
