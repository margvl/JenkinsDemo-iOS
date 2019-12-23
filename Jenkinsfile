class TestStageConfiguration {
    Boolean isEnabled
    String projectName
    String workspaceName
    String device
    String reportPath

    TestStageConfiguration(
            Boolean isEnabled,
            String projectName,
            String workspaceName,
            String device,
            String reportPath) {

        this.isEnabled = isEnabled
        this.projectName = projectName
        this.workspaceName = workspaceName
        this.device = device
        this.reportPath = reportPath
    }
}

pipeline {
    agent any

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '15'))
        disableConcurrentBuilds()
    }
    
    environment {
    }
    
    stages {
        stage('SetUp') {
            steps {
                sh 'bundle install'
            }
        }
        stage('Test') {
            when {
                expression {
                    TestStageConfiguration testStage = getTestStageConfiguration()
                    testStage.isEnabled == true
                }
            }
            steps {
                executeTestStage()
            }
            post {
                always {
                    TestStageConfiguration testStage = getTestStageConfiguration()
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
            (environment.workspaceName.getClass() == String) ? environment.workspaceName : null,
            test.device,
            environment.reportPath)

    return testStage
}

void executeTestStage() {
    TestStageConfiguration configuration = getTestStageConfiguration()
    sh "bundle exec fastlane test" +
            " projectName:\"${configuration.projectName}.xcodeproj\"" +
            " workspaceName:\"${configuration.workspaceName}\"" +
            " device:\"${configuration.device}\"" +
            " reportPath:\"${configuration.reportPath}\""
}

