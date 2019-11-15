node {
    def server
    def buildInfo
    def rtMaven

    stage("Cleanup Workspace") {
      deleteDir()
    }

    stage("Download Code") {
        checkout scm
        commitId = sh(returnStdout: true, script: 'git rev-parse HEAD')
    }

    stage('SonarQube analysis') {
      withSonarQubeEnv('SonarQube') {
        sh 'mvn clean package sonar:sonar'
      } // submitted SonarQube taskId is automatically attached to the pipeline context
    }
  }
    
    // No need to occupy a node
    stage("Quality Gate"){
      timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
        if (qg.status != 'OK') {
          error "Pipeline aborted due to quality gate failure: ${qg.status}"
        }
      }
 
    stage ('Artifactory configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage:
        server = Artifactory.newServer url 'http://artifactory-jfrog-artifactory.artifactory:8081'

        rtMaven = Artifactory.newMavenBuild()
        rtMaven.tool = MAVEN_TOOL // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'libs-release-local', snapshotRepo: 'libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot', server: server
        rtMaven.deployer.deployArtifacts = false // Disable artifacts deployment during Maven run

        buildInfo = Artifactory.newBuildInfo()
    }
 
    stage ('Test') {
        rtMaven.run pom: 'maven-example/pom.xml', goals: 'clean test'
    }
        
    stage ('Install') {
        rtMaven.run pom: 'maven-example/pom.xml', goals: 'install', buildInfo: buildInfo
    }

    stage ('Deploy') {
        rtMaven.deployer.deployArtifacts buildInfo
    }
        
    stage ('Publish build info') {
        server.publishBuildInfo buildInfo
    }
}