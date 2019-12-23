class TestStage {
    Boolean isEnabled
    String projectName
    String workspaceName
    String device
    String reportPath

    TestStage(
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
        TestStage testStage = getTestStage()
    }
    
    stages {
        stage('SetUp') {
            steps { sh 'bundle install' }
        }
        stage('Test') {
            when { expression { return testStage.isEnabled } }
            steps { executeTestStage() }
            post { success { reportTestStageResults(testStage.reportPath) } }
        }
    }

    post {
        success { sh 'echo "success :)"' }
        failure { sh 'echo "failure :("' }
    }
}

TestStage getTestStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def stages = config.stages
    def test = stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            (environment.workspaceName.getClass() == String) ? environment.workspaceName : null,
            test.device,
            environment.reportPath)

    return testStage
}

void executeTestStage() {
    TestStage stage = getTestStage()
    sh "bundle exec fastlane test" +
            " projectName:\"${stage.projectName}.xcodeproj\"" +
            ((stage.workspace == null) ? "" : " workspaceName:\"${stage.workspaceName}\"") +
            " device:\"${stage.device}\"" +
            " reportPath:\"${stage.reportPath}\""
}

void reportTestStageResults(String reportPath) {
    junit '"${reportPath}"/scan/*.junit'
}

