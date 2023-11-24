pipeline {
    agent any
    environment {
        GCR_CREDENTIALS_ID = "satish-gcr" // The ID you provided in Jenkins credentials
        IMAGE_NAME = "satish-py-restapi"
        GCR_URL = 'eu.gcr.io/lbg-mea-15'
        PROJECT_ID = 'lbg-mea-15'
        CLUSTER_NAME = 'satish-cluster'
        LOCATION = 'europe-west2-b'
        CREDENTIALS_ID = '1eb6a6e2-6fed-4099-89fa-896cb91bdc39'
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
        stage('Deploy - Staging') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([
                        $class: 'KubernetesEngineBuilder', 
                        projectId: env.PROJECT_ID, 
                        clusterName: env.CLUSTER_NAME, 
                        location: env.LOCATION, 
                        manifestPattern: 'kubernetes/deployment.yaml', 
                        credentialsId: env.CREDENTIALS_ID, 
                        verifyDeployments: true,
                        namespace: 'staging'])
                }
            }
        }
        stage('Quality Check') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    sh '''
                        gcloud config set account satish-jenkins@lbg-mea-15.iam.gserviceaccount.com
                        sleep 50
                        export STAGING_IP=\$(kubectl get svc -o json --namespace staging | jq '.items[] | select(.metadata.name == "flask-deployment") | .status.loadBalancer.ingress[0].ip' | tr -d '"')
                        pip3 install requests
                        python3 lbg.test.py
                    '''
                }
            }
        }

        stage('Deploy to GKE - prod') {
            steps {
                script {
                    // Deploy to GKE using Jenkins Kubernetes Engine Plugin
                    step([
                        $class: 'KubernetesEngineBuilder', 
                        projectId: env.PROJECT_ID, 
                        clusterName: env.CLUSTER_NAME, 
                        location: env.LOCATION, 
                        manifestPattern: 'kubernetes/deployment.yaml', 
                        credentialsId: env.CREDENTIALS_ID, 
                        verifyDeployments: true,
                        namespace: 'prod'])
                }
            }
        }
    }

}