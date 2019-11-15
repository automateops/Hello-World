node {
    def server Artifactory.newServer url 'http://artifactory-jfrog-artifactory.artifactory:8081'
    def rtMaven Artifactory.newMavenBuild()
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

    stage("SonarQube Analysis") {
      steps {
        withSonarQubeEnv('SonarQube') {
          bat 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar'
        }
      }
    }

    stage("Artifactory Configuration") {
      steps {
        script {
          rtMaven.tool = 'maven3'
          rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
          rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
          rtMaven.deployer.artifactDeploymentPatterns.addExclude("pom.xml")
          buildInfo = Artifactory.newBuildInfo()
          buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
          buildInfo.env.capture = true
        }
      }
    }

    if (params.env!="prod" && params.env!="staging") {
      stage('Build & Test') {
        script {
          rtMaven.run pom: 'pom.xml', goals: 'clean install', buildInfo: buildInfo
        }
      }
    }

    stage("Publish build info") {
      steps {
        script {
          server.publishBuildInfo buildInfo
        }
      }
    }
}