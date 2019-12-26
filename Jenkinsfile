class TestCoverageStage {
    Boolean isEnabled
    String projectName
    String workspaceName
    String sourcePath
    String reportPath
    
    TestCoverageStage(
            Boolean isEnabled,
            String projectName,
            String workspaceName,
            String sourcePath,
            String reportPath) {
        
        this.isEnabled = isEnabled
        this.projectName = projectName
        this.workspaceName = workspaceName
        this.sourcePath = sourcePath
        this.reportPath = reportPath
    }
}

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
    
    void execute() {
    
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
        TestCoverageStage testCoverageStage =
        TestStage testStage = getTestStage()
    }
    
    stages {
        stage('SetUp') {
            steps { sh 'bundle install' }
        }
        
        stage('Test') {
            when { expression { return testStage.isEnabled } }
            steps { executeTestStage() }
            post { always { reportTestStageResults(testStage.reportPath) } }
        }
    }

    post {
        success { sh 'echo "success :)"' }
        failure { sh 'echo "failure :("' }
    }
}


TestCoverageStage getTestCoverageStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def coverage = config.stages.testCoverage
    
    TestCoverageStage testCoverageStage = new TestCoverageStage(
            coverage.isEnabled,
            environment.projectName,
            (environment.workspaceName.getClass() == String) ? environment.workspaceName : null,
            environment.sourcePath,
            environment.reportPath + "/slather")

    return testCoverageStage
}

TestStage getTestStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def test = config.stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            (environment.workspaceName.getClass() == String) ? environment.workspaceName : null,
            test.device,
            environment.reportPath + "/scan")

    return testStage
}

void executeTestStage() {
    TestStage stage = getTestStage()
    sh "bundle exec fastlane test" +
            " projectName:\"${stage.projectName}.xcodeproj\"" +
            ((stage.workspaceName == null) ? "" : " workspaceName:\"${stage.workspaceName}\"") +
            " device:\"${stage.device}\"" +
            " reportPath:\"${stage.reportPath}\"/"
}

void reportTestStageResults(String reportPath) {
    junit reportPath + "/*.junit"
}

