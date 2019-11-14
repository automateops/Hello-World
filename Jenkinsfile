 node {
    try {
        currentBuild.result = "SUCCESS"
        commitId = ""

        stage("Preparation") {
          env.M2_HOME="${tool 'maven3'}"
          env.MAVEN_OPTS="-Drepo.url=http://artifactory-jfrog-artifactory.artifactory:8081 -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"
        }

        stage("Cleanup Workspace") {
          deleteDir()
        }

        stage("Download Code") {
            checkout scm
            commitId = sh(returnStdout: true, script: 'git rev-parse HEAD')
        }

        if (params.env!="prod" && params.env!="staging") {
          stage('Build & Test') {
                sh "mvn clean package -Djenkins.build.number=${BUILD_NUMBER}"
            }
          }
        }

        currentBuild.result = "SUCCESS"

    } catch (e) {
      currentBuild.result = "FAILED"
      throw e
    } finally {
    }
 }