pipeline {
  agent {
    docker {
      image 'openjdk:8-oraclelinux8'
    }

  }
  stages {
    stage('error') {
      steps {
        sh 'env | sort'
      }
    }

  }
}