pipeline {
    agent any

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '15'))
        disableConcurrentBuilds()
    }
    
    environment {
        TestCoverageStage testCoverageStage = getTestCoverageStage()
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
        
        stage('Test Coverage') {
            when { expression { return testCoverageStage.isEnabled } }
            steps { executeTestCoverageStage() }
        }
    }

    post {
        success { sh 'echo "success :)"' }
        failure { sh 'echo "failure :("' }
    }
}





// ---------------------------
// --- Test Coverage Stage ---
// ---------------------------

class TestCoverageStage {
    Boolean isEnabled
    String projectFilename
    String workspaceFilename
    String scheme
    String sourcePath
    String reportPath
    
    TestCoverageStage(
            Boolean isEnabled,
            String projectFilename,
            String workspaceFilename,
            String scheme,
            String sourcePath,
            String reportPath) {
        
        this.isEnabled = isEnabled
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.scheme = scheme
        this.sourcePath = sourcePath
        this.reportPath = reportPath
    }
}

TestCoverageStage getTestCoverageStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def coverage = config.stages.testCoverage
    
    TestCoverageStage testCoverageStage = new TestCoverageStage(
            coverage.isEnabled,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            coverage.scheme,
            environment.sourcePath,
            environment.reportPath + "/slather")

    return testCoverageStage
}

void executeTestCoverageStage() {
    TestCoverageStage stage = getTestCoverageStage()
    sh "bundle exec fastlane coverage" +
            getProjectFilenameParam(stage.projectFilename) +
            getWorkspaceFilenameParam(stage.workspaceFilename) +
            getSchemeParam(stage.scheme) +
            getSourcePathParam(stage.sourcePath) +
            getReportPathParam(stage.reportPath)
}


// ------------------
// --- Test Stage ---
// ------------------

class TestStage {
    Boolean isEnabled
    String projectFilename
    String workspaceFilename
    String device
    String reportPath

    TestStage(
            Boolean isEnabled,
            String projectFilename,
            String workspaceFilename,
            String device,
            String reportPath) {

        this.isEnabled = isEnabled
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.device = device
        this.reportPath = reportPath
    }
}

TestStage getTestStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def test = config.stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            test.device,
            environment.reportPath + "/scan")

    return testStage
}

void executeTestStage() {
    TestStage stage = getTestStage()
    sh "bundle exec fastlane test" +
            getProjectFilenameParam(stage.projectFilename) +
            getWorkspaceFilenameParam(stage.workspaceFilename) +
            getDeviceParam(stage.device) +
            getReportPathParam(stage.reportPath)
}

void reportTestStageResults(String reportPath) {
    junit reportPath + "/*.junit"
}

// ---------------
// --- Helpers ---
// ---------------

def getProjectFilename(projectName) {
    return projectName + ".xcodeproj"
}

def getWorkspaceFilename(workspaceName) {
    return (workspaceName.getClass() == String) ? (workspaceName + ".xcworkspace") : null
}

// ---------------------------
// --- Fastfile Parameters ---
// ---------------------------

String getProjectFilenameParam(String projectFilename) {
    return " projectFilename:" + projectFilename
}

String getWorkspaceFilenameParam(String workspaceFilename) {
    return (workspaceFilename == null) ? "" : (" workspaceFilename:" + workspaceFilename)
}

String getSourcePathParam(String sourcePath) {
    return " sourcePath:" + sourcePath
}

String getReportPathParam(String reportPath) {
    return " reportPath:" + reportPath
}

String getOutputPathParam(String outputPath) {
    return " outputPath:" + outputPath
}

String getSchemeParam(String scheme) {
    return " scheme:" + "\"" + scheme + "\""
}

String getDeviceParam(String device) {
    return " device:" + "\"" + device + "\""
}
