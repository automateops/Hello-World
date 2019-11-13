pipeline {
  agent any
  tools {
    maven 'M3'
  }

  options {
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '3')
  
  }
    stages {
        stage('Build Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
