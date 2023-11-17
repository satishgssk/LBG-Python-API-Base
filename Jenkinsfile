pipeline{
    agent any
    stages {
    stage('Build_Run'){
        steps{
            sh ssh jenkins@satish-deploy <<EOF
            sh setup.sh
        }
    }
    }
}