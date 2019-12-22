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

    TestStageConfiguration testStage = new TestStageConfiguration(
            test.isEnabled,
            environment.projectName,
            test.devices,
            environment.reportPath)

    return testStage
}

void executeTestStage() {
    TestStageConfiguration configuration = getTestStageConfiguration()
    sh "bundle exec fastlane test"
            + " projectName:${configuration.projectName}"
            + " devices:${configuration.devices}"
            + " reportPath:${configuration.reportPath}"
}

