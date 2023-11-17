pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t satishgssk/lbg-py .
                '''
           }
        }
        stage('Push') {
            steps {
                sh '''
                docker push satishgssk/lbg-py
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                ssh jenkins@satish-deploy <<EOF
                docker stop py-app && echo "Python app stopped" || echo "Python app is not up and running"
                docker run -d -p 80:80 --name py-app satishgssk/lbg-py
                '''
            }
        }
    }
}
