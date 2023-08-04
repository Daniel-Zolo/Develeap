pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
    stages {
         stage('Clone repository') { 
            steps { 
                script{
                checkout scm
                }
            }
        }

        stage('Build') { 
            steps { 
                script{
                 app = docker.build("develeapimg")
                }
            }
        }
        stage('Run') { 
            steps { 
                sh 'docker build -t docker run -p 8080:8080 develeapimg:latest .'
                }
            }
        stage('Deploy') {
            steps {
                script{
                        docker.withRegistry('https://069301198269.dkr.ecr.eu-north-1.amazonaws.com/develeapimg', 'ecr:eu-north-1:Develeap') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("latest")
                    }
                }
            }
        }
    }
}
