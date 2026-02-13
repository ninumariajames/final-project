pipeline {
  agent any

  environment {
    EC2_HOST = "15.206.178.184"
    REMOTE_BASE = "/home/ubuntu/app"
  }

  stages {
    stage('Pull from GitHub') {
      steps { checkout scm }
    }

    stage('SSH into server') {
      steps {
        withCredentials([string(credentialsId: 'EC2_PRIVATE_KEY', variable: 'KEYTEXT')]) {
          powershell '''
            $keyPath = "$env:TEMP\\wp-key"
            $KEYTEXT | Out-File -FilePath $keyPath -Encoding ascii

            ssh -o StrictHostKeyChecking=no -i $keyPath ubuntu@15.206.178.184 "echo SSH_OK && hostname && whoami"
          '''
        }
      }
    }

    stage('Deploy docker-compose') {
      steps {
        withCredentials([string(credentialsId: 'EC2_PRIVATE_KEY', variable: 'KEYTEXT')]) {
          powershell '''
            $keyPath = "$env:TEMP\\wp-key"
            $KEYTEXT | Out-File -FilePath $keyPath -Encoding ascii

            ssh -o StrictHostKeyChecking=no -i $keyPath ubuntu@15.206.178.184 "mkdir -p /home/ubuntu/app/deploy /home/ubuntu/app/monitoring"
            scp -o StrictHostKeyChecking=no -i $keyPath -r deploy/* ubuntu@15.206.178.184:/home/ubuntu/app/deploy/
            scp -o StrictHostKeyChecking=no -i $keyPath -r monitoring/* ubuntu@15.206.178.184:/home/ubuntu/app/monitoring/
            ssh -o StrictHostKeyChecking=no -i $keyPath ubuntu@15.206.178.184 "cd /home/ubuntu/app/deploy && docker compose --env-file .env up -d && cd /home/ubuntu/app/monitoring && docker compose up -d"
          '''
        }
      }
    }
  }

  post {
    success { echo "✅ SUCCESS: Jenkins deployed WordPress + MySQL + Prometheus to EC2!" }
    failure { echo "❌ FAILED: Check Console Output." }
  }
}
