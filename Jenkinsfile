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
    // No need to occupy a node
    stage("Quality Gate"){
      timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
        def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
        if (qg.status != 'OK') {
          error "Pipeline aborted due to quality gate failure: ${qg.status}"
        }
      }
    }
    stage ('Artifactory configuration') {
        // Obtain an Artifactory server instance, defined in Jenkins --> Manage:
        server = Artifactory.server 'Artifactory'

        rtMaven = Artifactory.newMavenBuild()
        rtMaven.tool = 'maven3' // Tool name from Jenkins configuration
        rtMaven.deployer releaseRepo: 'automateops-libs-release-local', snapshotRepo: 'automateops-libs-snapshot-local', server: server
        rtMaven.resolver releaseRepo: 'automateops-libs-release', snapshotRepo: 'automateops-libs-snapshot', server: server
        rtMaven.deployer.deployArtifacts = false // Disable artifacts deployment during Maven run

        buildInfo = Artifactory.newBuildInfo()
    } 
    
    stage('Build & Test') {
            withMaven(maven: 'maven3', mavenSettingsConfig: '9e9534d7-fac4-4fa7-8264-86d23809f9d1') {
                sh "mvn clean install"
            }
          }

    stage ('Deploy') {
        rtMaven.deployer.deployArtifacts buildInfo
    }
        
    stage ('Publish build info') {
        server.publishBuildInfo buildInfo
    }

}
