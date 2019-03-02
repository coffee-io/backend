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

        stage('Deploy infrastructure') {
            steps {
                sh """
                    cd terraform
                    rm -rf .terraform
                    terraform init -no-color -input=false 
                    terraform apply -no-color -input=false -auto-approve -lock=false
                """
            }
        }

    }
}

// vim:st=4:sts=4:sw=4:expandtab
