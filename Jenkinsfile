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
                sh 'docker run -d --name DeveleapProject -p 9080:80 develeapimg'
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
