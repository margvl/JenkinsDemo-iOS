node {
    ansiColor('xterm') {
        properties([
                buildDiscarder(logRotator(numToKeepStr: '15')),
                disableConcurrentBuilds()])
    
        loadUp('config.json')

        catchError {
            executeStageIfNeeded(setUpStage)
            executeStageIfNeeded(testStage)
            //executeTestStageIfNeeded()
            //executeBuildStageIfNeeded()
        }
    }
}


SetUpStage setUpStage = null
TestStage testStage = null
AnalyzeStage analyzeStage = null
BuildStage buildStage = null
//DistributionStage distributionStage = null


void loadUp(String filename) {
    checkout scm

    Map config = readJSON file: filename
    Map environment = config.environment
    Map setUp = config.stages.setUp
    Map test = config.stages.test
    Map analyze = config.stages.analyze
    
    println("config: " + config)
    println("environment: " + environment)
    println("setUp: " + setUp)
    println("test: " + test)
    println("analyze: " + analyze)

    setUpStage = new SetUpStage(setUp.title)
    TestCoverageStep testCoverage = new TestCoverageStep(
            test.isCoverageEnabled,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            test.scheme,
            environment.sourcePath,
            environment.reportPath + "/slather")
    testStage = new TestStage(
            test.isEnabled,
            test.title,
            getProjectFilename(environment.projectName),
            getWorkspaceFilename(environment.workspaceName),
            test.scheme,
            test.devices,
            environment.reportPath + "/scan",
            testCoverage)
    
    StageStep[] stepList = []
    analyzeStage = new AnalyzeStage(analyze.title, stepList)
}


void executeStageIfNeeded(Stage executableStage) {
    if (executableStage.isEnabled) {
        stage(executableStage.title) {
            String[] executionCommandList = executableStage.executionCommands()
            executionCommandList.each { executionCommand ->
                run(executionCommand)
            }
        }
    }
}


// --------------------
// --- Set Up Stage ---
// --------------------
void executeSetUpStage() {
    stage('Set up') {
        run('bundle install')
    }
}

class SetUpStage extends Stage {
    SetUpStage(String title) {
        super(true, title)
    }
    
    String[] executionCommands() {
        String[] executionCommandList = ["bundle install"]
        return executionCommandList
    }
}

// ------------------
// --- Test Stage ---
// ------------------
class TestStage extends Stage {
    String projectFilename
    String workspaceFilename
    String scheme
    String[] deviceList
    String reportPath
    StageStep coverageStep

    TestStage(
            Boolean isEnabled,
            String title,
            String projectFilename,
            String workspaceFilename,
            String scheme,
            String[] devices,
            String reportPath,
            StageStep coverageStep) {
            
        super(isEnabled, title)
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.scheme = scheme
        this.deviceList = devices
        this.reportPath = reportPath
        this.coverageStep = coverageStep
    }
    
    String[] executionCommands() {
        String[] executionCommandList = []
        executionCommandList += ("bundle exec fastlane test" +
                ParamBuilder.getProjectFilenameParam(projectFilename) +
                ParamBuilder.getWorkspaceFilenameParam(workspaceFilename) +
                ParamBuilder.getSchemeParam(scheme) +
                ParamBuilder.getDevicesParam(deviceList.join(',')) +
                ParamBuilder.getReportPathParam(reportPath))
        if (coverageStep.isEnabled) {
            executionCommandList += coverageStep.executionCommand()
        }
        return executionCommandList
    }
}

class TestCoverageStep implements StageStep {
    Boolean isEnabled
    String projectFilename
    String workspaceFilename
    String scheme
    String sourcePath
    String reportPath
    
    TestCoverageStep(
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
    
    String executionCommand() {
        return "bundle exec fastlane coverage" +
                ParamBuilder.getProjectFilenameParam(projectFilename) +
                ParamBuilder.getWorkspaceFilenameParam(workspaceFilename) +
                ParamBuilder.getSchemeParam(scheme) +
                ParamBuilder.getSourcePathParam(sourcePath) +
                ParamBuilder.getReportPathParam(reportPath)
    }
}


void executeTestStageIfNeeded() {
    TestStage test = getTestStage()
    if (testStage.isEnabled) {
        stage(testStage.title) {
            run(testStage.executionCommand())
            junit test.reportPath + "/*.junit"
        }
        executeTestCoverageStageIfNeeded()
    }
}

// ---------------------
// --- Analyze Stage ---
// ---------------------
class AnalyzeStage extends Stage {
    StageStep[] stepList
    
    AnalyzeStage(String title, StageStep[] steps) {
        // TODO: Decide `enabled` value dependend on enabled steps
        super(true, title)
        this.stepList = steps
    }
    
    String[] executionCommands() {
        return []
    }
}

class SwiftLintStep implements StageStep {
    Boolean isEnabled
    
    String executionCommand() {
        return ""
    }
}

class ClocStep implements StageStep {
    Boolean isEnabled

    String executionCommand() {
        return ""
    }
}

// ---------------------------
// --- Test Coverage Stage ---
// ---------------------------
/*
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
                ParamBuilder.getProjectFilenameParam(projectFilename) +
                ParamBuilder.getWorkspaceFilenameParam(workspaceFilename) +
                ParamBuilder.getSchemeParam(scheme) +
                ParamBuilder.getSourcePathParam(sourcePath) +
                ParamBuilder.getReportPathParam(reportPath)
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
*/

// -------------------
// --- Build Stage ---
// -------------------
class BuildStage extends Stage {
    String projectFilename
    String workspaceFilename
    String outputPath
    BuildItem[] itemList
    
    BuildStage(
            Boolean isEnabled,
            String title,
            String projectFilename,
            String workspaceFilename,
            String outputPath,
            BuildItem[] items) {
        
        super(isEnabled, title)
        this.projectFilename = projectFilename
        this.workspaceFilename = workspaceFilename
        this.outputPath = outputPath
        this.itemList = items
    }
    
    String[] executionCommands() {
        String[] executionCommandList = []
        itemList.each { item ->
            String executionCommand = "bundle exec fastlane build" +
                    ParamBuilder.getProjectFilenameParam(projectFilename) +
                    ParamBuilder.getWorkspaceFilenameParam(workspaceFilename) +
                    ParamBuilder.getConfigurationParam(item.configuration) +
                    ParamBuilder.getSchemeParam(item.scheme) +
                    ParamBuilder.getOutputPathParam(outputPath) +
                    ParamBuilder.getOutputNameParam(item.name) +
                    ParamBuilder.getExportMethodParam(item.exportMethod) +
                    ParamBuilder.getProvisioningProfilesParam(item.profilesValue())
            executionCommandList += executionCommand
        }
        return executionCommandList
    }
}

class BuildItem {
    String id
    String name
    String configuration
    String scheme
    String exportMethod
    BuildProfile[] profileList
    
    BuildItem(
            String id,
            String name,
            String configuration,
            String scheme,
            String exportMethod,
            BuildProfile[] profiles) {
    
        this.id = id
        this.name = name
        this.configuration = configuration
        this.scheme = scheme
        this.exportMethod = exportMethod
        this.profileList = profiles
    }
    
    String profilesValue() {
        String[] valueList = []
        profileList.each { profile ->
            valueList += profile.value()
        }
        String value = valueList.join(',')
        return value
    }
}

class BuildProfile {
    String id
    String name
    
    BuildProfile(String id, String name) {
        this.id = id
        this.name = name
    }
    
    String value() {
        return id + "=>" + name
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
                profile.id,
                profile.name
            )
            buildProfileList += buildProfile
        }
        
        BuildItem buildItem = new BuildItem(
                item.id,
                environment.projectName + "-" + item.id + ".ipa",
                item.configuration,
                item.scheme,
                item.exportMethod,
                buildProfileList
        )
        buildItemList += buildItem
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
        stage(buildStage.title) {
            String[] executionCommandList = buildStage.executionCommands()
            executionCommandList.each { executionCommand ->
                run(executionCommand)
            }
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

class ParamBuilder {
    static String getProjectFilenameParam(String projectFilename) {
        return " projectFilename:" + projectFilename
    }

    static String getWorkspaceFilenameParam(String workspaceFilename) {
        return (workspaceFilename == null) ? "" : (" workspaceFilename:" + workspaceFilename)
    }

    static String getSourcePathParam(String sourcePath) {
        return " sourcePath:" + sourcePath
    }

    static String getReportPathParam(String reportPath) {
        return " reportPath:" + reportPath
    }

    static String getOutputPathParam(String outputPath) {
        return " outputPath:" + outputPath
    }

    static String getConfigurationParam(String configuration) {
        return " configuration:" + configuration
    }

    static String getExportMethodParam(String exportMethod) {
        return " exportMethod:" + exportMethod
    }

    static String getProvisioningProfilesParam(String provisioningProfiles) {
        return " provisioningProfiles:" + "\"" + provisioningProfiles + "\""
    }

    static String getOutputNameParam(String outputName) {
        return " outputName:" + "\"" + outputName + "\""
    }

    static String getSchemeParam(String scheme) {
        return " scheme:" + "\"" + scheme + "\""
    }

    static String getDevicesParam(String devices) {
        return " devices:" + "\"" + devices + "\""
    }
}

// -------------
// --- Stage ---
// -------------
interface StageStep {
    Boolean isEnabled
    String executionCommand()
}

abstract class Stage {
    Boolean isEnabled
    String title
    
    Stage(Boolean isEnabled, String title) {
        this.isEnabled = isEnabled
        this.title = title
    }
    
    abstract String[] executionCommands()
}
