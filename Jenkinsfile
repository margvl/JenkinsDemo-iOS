node {
    ansiColor('xterm') {
        properties([
                buildDiscarder(logRotator(numToKeepStr: '15')),
                disableConcurrentBuilds()])
    
        catchError {
            stage('SetUp') {
                executeSetUpStage()
            }
            stage('Test') {
                executeTestStage()
            }
        }
    }
}

/*
pipeline {
    agent any

    options {
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '15'))
        disableConcurrentBuilds()
    }
    
    environment {
        TestStage testStage = getTestStage()
        TestCoverageStage testCoverageStage = getTestCoverageStage()
    }
    
    stages {
        stage('SetUp') {
            steps { executeSetUpStage() }
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
*/




// --------------------
// --- Set Up Stage ---
// --------------------

void executeSetUpStage() {
    checkout scm
    sh 'bundle install'
}


// ------------------
// --- Test Stage ---
// ------------------


class TestStage {
    Boolean isEnabled
    String projectFilename
    String workspaceFilename
    String scheme
    String device
    String reportPath

    TestStage(
            Boolean isEnabled,
            String projectFilename,
            String workspaceFilename,
            String scheme,
            String device,
            String reportPath) {

        this.isEnabled = isEnabled
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.scheme = scheme
        this.device = device
        this.reportPath = reportPath
    }
    
    Boolean isExecutable() {
        return isEnabled
    }
    
    String executionCommand() {
        return "bundle exec fastlane test" +
                getProjectFilenameParam(projectFilename) +
                getWorkspaceFilenameParam(workspaceFilename) +
                getSchemeParam(scheme) +
                getDeviceParam(device) +
                getReportPathParam(reportPath)
    }
    
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

    String getProjectFilename(projectName) {
        return projectName + ".xcodeproj"
    }

    String getWorkspaceFilename(workspaceName) {
        return (workspaceName.getClass() == String) ? (workspaceName + ".xcworkspace") : null
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
            test.scheme,
            test.device,
            environment.reportPath + "/scan")

    return testStage
}

void executeTestStage(TestStage stage) {
    /*
    TestStage stage = getTestStage()
    sh stage.executionCommand()
    
    sh "bundle exec fastlane test" +
            getProjectFilenameParam(stage.projectFilename) +
            getWorkspaceFilenameParam(stage.workspaceFilename) +
            getSchemeParam(stage.scheme) +
            getDeviceParam(stage.device) +
            getReportPathParam(stage.reportPath)
    */
}

void reportTestStageResults(String reportPath) {
    junit reportPath + "/*.junit"
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

// ---------------
// --- Helpers ---
// ---------------
/*
def getProjectFilename(projectName) {
    return projectName + ".xcodeproj"
}

def getWorkspaceFilename(workspaceName) {
    return (workspaceName.getClass() == String) ? (workspaceName + ".xcworkspace") : null
}
*/
// ---------------------------
// --- Fastfile Parameters ---
// ---------------------------

/*
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
*/
