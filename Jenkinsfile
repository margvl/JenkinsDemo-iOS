class ProjectConfiguration {
    TestStage testStage

    ProjectConfiguration(TestStage testStage) {
        this.testStage = testStage
    }
}

class TestStage {
    Boolean isEnabled
    String projectName
    String[] devices
    String reportPath

    TestStage(
            Boolean isEnabled,
            String projectName,
            String[] devices,
            String reportPath) {

        this.isEnabled = isEnabled
        this.projectName = projectName
        this.devices = devices
        this.reportPath = reportPath
    }
}

def configPath = 'config.json'

pipeline {
    agent any

    options {
        ansiColor('xterm')
    }
    
    environment {
        ProjectConfiguration configuration = getProjectConfiguration()
    }
    
    stages {
        stage('SetUp') {
            steps {
                sh 'bundle install'
            }
        }
        stage('Test') {
            steps {
                executeTestStage()
            }
            post {
                always {
                    junit '"${configuration.testStage.reportPath}"/scan/*.junit'
                }
            }
        }
    }

    post {
        success {
            sh 'echo "success :)"'
        }

        failure {
            sh 'echo "failure :("'
        }
    }
}

ProjectConfiguration getProjectConfiguration() {
    def config = readJSON file: configPath
    def environment = config.environment
    def stages = config.stages
    def test = stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            test.devices,
            environment.reportPath)

    return new ProjectConfiguration(testStage)
}

void executeTestStage() {
    ProjectConfiguration configuration = getProjectConfiguration()
    TestStage stage = configuration.testStage

    sh 'bundle exec fastlane test'
            + ' projectName:"${stage.projectName}"'
            + ' devices:"${stage.devices}"'
            + ' reportPath:"${stage.reportPath}"'
}

