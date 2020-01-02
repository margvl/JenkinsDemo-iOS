node {
    ansiColor('xterm') {
        properties([
                buildDiscarder(logRotator(numToKeepStr: '15')),
                disableConcurrentBuilds()])
    
        catchError {
            executeSetUpStage()
            //executeTestStageIfNeeded()
            executeBuildStageIfNeeded()
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
    stage('SetUp') {
        checkout scm
        run('bundle install')
    }
}


// ------------------
// --- Test Stage ---
// ------------------

class TestStage extends Stage {
    String projectFilename
    String workspaceFilename
    String scheme
    String device
    String reportPath

    TestStage(
            Boolean isEnabled,
            String title,
            String projectFilename,
            String workspaceFilename,
            String scheme,
            String device,
            String reportPath) {
            
        super(isEnabled, title)
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.scheme = scheme
        this.device = device
        this.reportPath = reportPath
    }
    
    String executionCommand() {
        return "bundle exec fastlane test" +
                getProjectFilenameParam(projectFilename) +
                getWorkspaceFilenameParam(workspaceFilename) +
                getSchemeParam(scheme) +
                getDeviceParam(device) +
                getReportPathParam(reportPath)
    }
}

TestStage getTestStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def test = config.stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            test.title,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            test.scheme,
            test.device,
            environment.reportPath + "/scan")

    return testStage
}

void executeTestStageIfNeeded() {
    TestStage test = getTestStage()
    if (test.isEnabled) {
        stage(test.title) {
            run(test.executionCommand())
            junit test.reportPath + "/*.junit"
        }
        executeTestCoverageStageIfNeeded()
    }
}

// ---------------------------
// --- Test Coverage Stage ---
// ---------------------------

class TestCoverageStage extends Stage {
    String projectFilename
    String workspaceFilename
    String scheme
    String sourcePath
    String reportPath
    
    TestCoverageStage(
            Boolean isEnabled,
            String title,
            String projectFilename,
            String workspaceFilename,
            String scheme,
            String sourcePath,
            String reportPath) {
        
        super(isEnabled, title)
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.scheme = scheme
        this.sourcePath = sourcePath
        this.reportPath = reportPath
    }
    
    String executionCommand() {
        return "bundle exec fastlane coverage" +
                getProjectFilenameParam(projectFilename) +
                getWorkspaceFilenameParam(workspaceFilename) +
                getSchemeParam(scheme) +
                getSourcePathParam(sourcePath) +
                getReportPathParam(reportPath)
    }
}

TestCoverageStage getTestCoverageStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def testCoverage = config.stages.testCoverage
    
    TestCoverageStage testCoverageStage = new TestCoverageStage(
            testCoverage.isEnabled,
            testCoverage.title,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            testCoverage.scheme,
            environment.sourcePath,
            environment.reportPath + "/slather")

    return testCoverageStage
}

void executeTestCoverageStageIfNeeded() {
    TestCoverageStage testCoverage = getTestCoverageStage()
    if (testCoverage.isEnabled) {
        stage(testCoverage.title) {
            run(testCoverage.executionCommand())
            publishHTML([allowMissing: false,
                         alwaysLinkToLastBuild: false,
                         keepAll: false,
                         reportDir: testCoverage.reportPath,
                         reportFiles: "index.html",
                         reportName: testCoverage.title + " Report"])
        }
    }
}


// -------------------
// --- Build Stage ---
// -------------------

class BuildStage extends Stage {
    String projectFilename
    String workspaceFilename
    String outputPath
    String outputName
    
    BuildStage(
            Boolean isEnabled,
            String title,
            String projectFilename,
            String workspaceFilename,
            String outputPath) {
        
        super(isEnabled, title)
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.outputPath = outputPath
    }
    
    String executionCommand() {
        return "bundle exec fastlane build"
    }
}

class BuildItem {
    Integer index
    String name
    String configuration
    String scheme
    String exportMethod
    BuildProfile[] profiles
    
    BuildItem(
            Integer index,
            String name,
            String configuration,
            String scheme,
            String exportMethod,
            BuildProfile[] profiles) {
    
        this.index = index
        this.name = name
        this.configuration = configuration
        this.scheme = scheme
        this.exportMethod = exportMethod
        this.profiles = profiles
    }
}

class BuildProfile {
    String id
    String name
    
    BuildProfile(String id, String name) {
        this.id = id
        this.name = name
    }
}

BuildStage getBuildStage() {
    def config = readJSON file: 'config.json'
    def environment = config.environment
    def build = config.stages.build
    def itemList = build.items

    BuildItem[] buildItemList = []
    itemList.each { item ->
        def profileList = item.provisioningProfiles
        BuildProfile[] buildProfileList = []
        profileList.each { profile ->
            BuildProfile buildProfile = new BuildProfile(
                profile.bundleId,
                profile.name
            )
            buildProfileList.add(buildProfile)
        }
        
        BuildItem buildItem = new BuildItem(
                item.index,
                "name",
                item.configuration,
                item.scheme,
                item.exportMethod,
                buildProfileList
        )
        buildItemList.add(buildItem)
    }

    BuildStage buildStage = new BuildStage(
            build.isEnabled,
            build.title,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            environment.outputPath + "/gym",
            buildItemList)

    return buildStage
}

void executeBuildStageIfNeeded() {
    BuildStage buildStage = getBuildStage()
    if (buildStage.isEnabled) {
        stage(buildStage.name) {
            run(buildStage.executionCommand())
        }
    }
}

// ---------------
// --- Helpers ---
// ---------------

void run(String command) {
    sh command
}

def getProjectFilename(projectName) {
    return projectName + ".xcodeproj"
}

def getWorkspaceFilename(workspaceName) {
    return (workspaceName.getClass() == String) ? (workspaceName + ".xcworkspace") : null
}


// -------------
// --- Stage ---
// -------------

abstract class Stage {
    Boolean isEnabled
    String title
    
    Stage(Boolean isEnabled, String title) {
        this.isEnabled = isEnabled
        this.title = title
    }
    
    abstract String executionCommand()


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
}
