pipeline {
    agent any
    environment {
        GCR_CREDENTIALS_ID = "satish-jenkins-gcr" // The ID you provided in Jenkins credentials
        IMAGE_NAME = "satish-py-restapi"
        GCR_URL = "eu.gcr.io/lbg-mea-a5"
    }
    stages {
        stage('Build and Push to GCR') {
            steps {
              script{
                // Authenticate with Google Cloud
                withCredentials([file(credentialsId: GCR_CREDENTIALS_ID, variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) 
                {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                }
                // Configure Docker to use gcloud as a credential helper
                sh 'gcloud auth configure-docker --quiet'
                // Build the Docker image
                sh "docker build -t ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                // Push the Docker image to GCR
                sh "docker push ${GCR_URL}/${IMAGE_NAME}:${BUILD_NUMBER}"
               }
            }
        }
        // stage('Staging Deploy') {
        //     steps {
        //        sh '''
        //         sed -e 's,{{userName}},'${YOUR_NAME}', g;' -e 's,{{version}},'${BUILD_NUMBER}',g;' task1-app-manifest.yaml | kubectl apply -f - --namespace staging
        //         kubectl apply -f task1-nginx-manifest.yaml --namespace staging
        //         '''
        //     }
        // }
        // stage('Quality Check') {
        //     steps {
        //        sh '''
        //         sleep 50
        //         export STAGING_IP=\$(kubectl get svc -o json --namespace staging | jq '.items[] | select(.metadata.name == "task1-nginx") | .status.loadBalancer.ingress[0].ip' | tr -d '"')
        //         pip3 install requests
        //         python3 test-app.py
        //         '''
        //     }
        // }
        // stage('Prod Deploy') {
        //     steps { 
        //         sh '''
        //         sed -e 's,{{userName}},'${YOUR_NAME}', g;' -e 's,{{version}},'${BUILD_NUMBER}',g;' task1-app-manifest.yaml | kubectl apply -f - --namespace prod
        //         kubectl apply -f task1-nginx-manifest.yaml --namespace prod
        //         sleep 50
        //         kubectl get services --namespace prod
        //         '''
        //     }
        // }
    }

}