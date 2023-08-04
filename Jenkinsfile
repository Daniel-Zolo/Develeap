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
                        sh '''
                            eval $(aws ecr get-login --no-include-email --region ${AWS_REGION})
                            docker tag develeapimg:${BUILD_ID} ${DOCKER_REGISTRY}/${ECR_REPO_NAME}:${BUILD_ID}
                            docker push ${DOCKER_REGISTRY}/${ECR_REPO_NAME}:${BUILD_ID}
                        '''
                    }
                }
            }
        }
    }
}
