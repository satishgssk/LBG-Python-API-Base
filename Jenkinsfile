pipeline{
    agent any
    stages {
    stage('Build_Run'){
        steps{
            sh '''
            ssh jenkins@satish-deploy <<EOF
            ./setup1.sh
            '''
        }
    }
    }
}