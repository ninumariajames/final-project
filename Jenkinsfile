pipeline {
  agent any

  environment {
    EC2_HOST = "15.206.178.184"
    SSH_CRED = "ec2-ssh-key"
    REMOTE_BASE = "/home/ubuntu/app"
  }

  stages {

    stage('Pull from GitHub') {
      steps {
        checkout scm
      }
    }

    stage('SSH into server') {
      steps {
        sshagent(credentials: ["${SSH_CRED}"]) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} "echo SSH_OK && hostname && whoami"'
        }
      }
    }

    stage('Deploy docker-compose') {
      steps {
        sshagent(credentials: ["${SSH_CRED}"]) {
          sh """
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} 'mkdir -p ${REMOTE_BASE}/deploy ${REMOTE_BASE}/monitoring'
            scp -o StrictHostKeyChecking=no -r deploy/* ubuntu@${EC2_HOST}:${REMOTE_BASE}/deploy/
            scp -o StrictHostKeyChecking=no -r monitoring/* ubuntu@${EC2_HOST}:${REMOTE_BASE}/monitoring/
            ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
              cd ${REMOTE_BASE}/deploy &&
              docker compose --env-file .env up -d &&
              cd ${REMOTE_BASE}/monitoring &&
              docker compose up -d
            '
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ SUCCESS: Jenkins deployed WordPress + MySQL + Prometheus!"
    }
    failure {
      echo "❌ FAILED: Check Console Output."
    }
  }
}
