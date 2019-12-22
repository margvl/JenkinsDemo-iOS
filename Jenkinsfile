class TestStageConfiguration {
    Boolean isEnabled
    String projectName
    String[] devices
    String reportPath

    TestStageConfiguration(
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

pipeline {
    agent any

    options {
        ansiColor('xterm')
    }
    
    environment {
        TestStageConfiguration testStage = getTestStageConfiguration()
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
                    junit '"${testStage.reportPath}"/scan/*.junit'
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

TestStageConfiguration getTestStageConfiguration() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def stages = config.stages
    def test = stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            test.devices,
            environment.reportPath)

    return testStage
}

void executeTestStage() {
    ProjectConfiguration configuration = getTestStageConfiguration()
    TestStage stage = configuration.testStage

    sh 'bundle exec fastlane test'
            + ' projectName:"${stage.projectName}"'
            + ' devices:"${stage.devices}"'
            + ' reportPath:"${stage.reportPath}"'
}

