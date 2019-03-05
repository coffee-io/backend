#!groovy

pipeline {

    agent any

    environment {
        CI                    = true
        HOME                  = '.'
        AWS_ID                = credentials("aws")
        AWS_ACCESS_KEY_ID     = "${env.AWS_ID_USR}"
        AWS_SECRET_ACCESS_KEY = "${env.AWS_ID_PSW}"
        AWS_DEFAULT_REGION    = "us-east-1"
    }

    stages {

        stage('Build base go image') {
            steps {
                sh 'docker build -t gobuild-lambda .'
            }
        }

        /*
        stage('Build and deploy reset.zip') {
            steps {
                sh """
                    cd reset
                    docker build -t reset .
                    docker run --env AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID} --env AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY} --env AWS_REGION=${env.AWS_DEFAULT_REGION} reset
                """
            }
        }
        */

        stage('Deploy infrastructure') {
            steps {
                sh """
                    cd terraform
                    terraform init -no-color -input=false 
                    terraform apply -no-color -input=false -auto-approve -lock=false
                """
            }
        }

        stage('Build and deploy lambdas') {
            steps {
                sh './publish_lambda.sh hello'
            }
        }

    }
}

// vim:st=4:sts=4:sw=4:expandtab
