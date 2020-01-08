node {
    ansiColor('xterm') {
        applyJenkinsOptions()
        checkoutContent()
        loadUp('config.json')

        catchError {
            executeSetUpStage()
            executeTestStageIfNeeded()
            executeAnalyzeStageIfNeeded()
            executeBuildStageIfNeeded()
            executeDistributionStageIfNeeded()
        }
    }
}


SetUpStage setUpStage = null
TestStage testStage = null
AnalyzeStage analyzeStage = null
BuildStage buildStage = null
DistributionStage distributionStage = null

void applyJenkinsOptions() {
    properties([
            buildDiscarder(logRotator(numToKeepStr: '15')),
            disableConcurrentBuilds()])
}

void checkoutContent() {
    checkout scm
}

void loadUp(String filename) {
    Map config = readJSON file: filename
    Map environment = config.environment
    Map stages = config.stages
    Map setUp = stages.setUp
    Map test = stages.test
    Map analyze = stages.analyze
    Map build = stages.build
    Map distribution = stages.distribution

    setUpStage = getSetUpStage(setUp)
    testStage = getTestStage(environment, test)
    analyzeStage = getAnalyzeStage(environment, analyze)
    buildStage = getBuildStage(environment, build)
    distributionStage = getDistributionStage(distribution)
}

void executeSetUpStage() {
    stage(setUpStage.title) {
        run(setUpStage.dependenciesInstallationCommand())
        executeCocoapodsStepIfNeeded()
        executeCarthageStepIfNeeded()
    }
}

void executeCocoapodsStepIfNeeded() {
    CocoaPodsStep cocoaPodsStep = setUpStage.cocoaPodsStep
    if (cocoaPodsStep.isEnabled) {
        run(cocoaPodsStep.executionCommand())
    }
}

void executeCarthageStepIfNeeded() {
    CarthageStep carthageStep = setUpStage.carthageStep
    if (carthageStep.isEnabled) {
        run(carthageStep.executionCommand())
    }
}

void executeTestStageIfNeeded() {
    if (testStage.isEnabled) {
        stage(testStage.title) {
            run(testStage.executionCommand())
            junit testStage.reportPath + "/*.junit"
            
            executeTestCoverageStepIfNeeded()
        }
    }
}

void executeTestCoverageStepIfNeeded() {
    TestCoverageStep coverageStep = testStage.coverageStep
    if (coverageStep.isEnabled) {
        run(coverageStep.executionCommand())
        publishHTML([allowMissing: false,
                     alwaysLinkToLastBuild: false,
                     keepAll: false,
                     reportDir: coverageStep.reportPath,
                     reportFiles: "index.html",
                     reportName: "Coverage Report"])
    }
}

void executeAnalyzeStageIfNeeded() {
    if (analyzeStage.isEnabled) {
        stage(analyzeStage.title) {
            executeSwiftLintStepIfNeeded()
            executeClocStepIfNeeded()
        }
    }
}

void executeSwiftLintStepIfNeeded() {
    SwiftLintStep swifLintStep = analyzeStage.swiftLintStep
    if (swifLintStep.isEnabled) {
        run(swifLintStep.executionCommand())
        step([$class: 'hudson.plugins.checkstyle.CheckStylePublisher',
              canComputeNew: false,
              defaultEncoding: '',
              healthy: '',
              pattern: "${swifLintStep.reportPath}/result.xml",
              unHealthy: ''])
    }
}

void executeClocStepIfNeeded() {
    ClocStep clocStep = analyzeStage.clocStep
    if (clocStep.isEnabled) {
        run(clocStep.executionCommand())
        sloccountPublish encoding: '', pattern: "${clocStep.reportPath}/cloc.xml"
    }
}

void executeBuildStageIfNeeded() {
    if (buildStage.isEnabled) {
        stage(buildStage.title) {
            String[] executionCommandList = buildStage.executionCommands()
            executionCommandList.each { executionCommand ->
                run(executionCommand)
            }
        }
    }
}

void executeDistributionStageIfNeeded() {

}

// --------------------
// --- Set Up Stage ---
// --------------------
class SetUpStage extends Stage {
    CocoaPodsStep cocoaPodsStep
    CarthageStep carthageStep

    SetUpStage(
            String title,
            CocoaPodsStep cocoaPodsStep,
            CarthageStep carthageStep) {
        super(true, title)
        this.cocoaPodsStep = cocoaPodsStep
        this.carthageStep = carthageStep
    }
    
    String dependenciesInstallationCommand() {
        return "bundle install"
    }
}

class CocoaPodsStep implements StageStep {
    Boolean isEnabled
    String podFile
    
    CocoaPodsStep(Boolean isEnabled, String podFile) {
        this.isEnabled = isEnabled
        this.podFile = podFile
    }
    
    String executionCommand() {
        return "bundle exec fastlane CocoaPods" +
                ParamBuilder.getPodFileParam(podFile)
    }
}

class CarthageStep implements StageStep {
    Boolean isEnabled
    String platform

    CarthageStep(Boolean isEnabled, String platform) {
        this.isEnabled = isEnabled
        this.platform = platform
    }
    
    String executionCommand() {
        return "bundle exec fastlane Carthage" +
                ParamBuilder.getPlatformParam(platform)
    }
}

SetUpStage getSetUpStage(Map setUp) {
    Map cocoaPods = setUp.cocoaPods
    CocoaPodsStep cocoaPodsStep = new CocoaPodsStep(
            cocoaPods.isEnabled,
            cocoaPods.podFile)
            
    Map carthage = setUp.carthage
    CarthageStep carthageStep = new CarthageStep(
            carthage.isEnabled,
            carthage.platform)

    return new SetUpStage(setUp.title, cocoaPodsStep, carthageStep)
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
    
    String executionCommand() {
        return "bundle exec fastlane test" +
                ParamBuilder.getProjectFilenameParam(projectFilename) +
                ParamBuilder.getWorkspaceFilenameParam(workspaceFilename) +
                ParamBuilder.getSchemeParam(scheme) +
                ParamBuilder.getDevicesParam(deviceList.join(',')) +
                ParamBuilder.getReportPathParam(reportPath)
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

TestStage getTestStage(Map environment, Map test) {
    TestCoverageStep testCoverage = new TestCoverageStep(
            test.isCoverageEnabled,
            NameBuilder.getProjectFilename(environment.projectName),
            NameBuilder.getWorkspaceFilename(environment.workspaceName),
            test.scheme,
            environment.sourcePath,
            environment.reportPath + "/slather")
            
    String[] deviceList = []
    test.devices.each { device ->
        deviceList += device
    }
    TestStage testStage = new TestStage(
            test.isEnabled,
            test.title,
            NameBuilder.getProjectFilename(environment.projectName),
            NameBuilder.getWorkspaceFilename(environment.workspaceName),
            test.scheme,
            deviceList,
            environment.reportPath + "/scan",
            testCoverage)
    return testStage
}

// ---------------------
// --- Analyze Stage ---
// ---------------------
class AnalyzeStage extends Stage {
    StageStep swiftLintStep
    StageStep clocStep
    
    AnalyzeStage(
            Boolean isEnabled,
            String title,
            StageStep swiftLintStep,
            StageStep clocStep) {
            
        super(isEnabled, title)
        this.swiftLintStep = swiftLintStep
        this.clocStep = clocStep
    }
}

class SwiftLintStep implements StageStep {
    Boolean isEnabled
    String configFile
    String reportPath
    
    SwiftLintStep(
            Boolean isEnabled,
            String configFile,
            String reportPath) {
            
        this.isEnabled = isEnabled
        this.configFile = configFile
        this.reportPath = reportPath
    }
    
    String executionCommand() {
        return "bundle exec fastlane lint" +
                ParamBuilder.getReportPathParam(reportPath) +
                ParamBuilder.getConfigFileParam(configFile)
    }
}

class ClocStep implements StageStep {
    Boolean isEnabled
    String sourcePath
    String reportPath

    ClocStep(
            Boolean isEnabled,
            String sourcePath,
            String reportPath) {
    
        this.isEnabled = isEnabled
        this.sourcePath = sourcePath
        this.reportPath = reportPath
    }

    String executionCommand() {
        return "bundle exec fastlane count" +
                ParamBuilder.getSourcePathParam(sourcePath) +
                ParamBuilder.getReportPathParam(reportPath)
    }
}

AnalyzeStage getAnalyzeStage(Map environment, Map analyze) {
    Map swiftLint = analyze.swiftLint
    SwiftLintStep swiftLintStep = new SwiftLintStep(
            swiftLint.isEnabled,
            NameBuilder.getConfigFile(swiftLint.configFile),
            environment.reportPath + "/swiftlint")
            
    Map cloc = analyze.cloc
    ClocStep clocStep = new ClocStep(
            cloc.isEnabled,
            environment.sourcePath,
            environment.reportPath + "/cloc")
    
    return new AnalyzeStage(
            swiftLintStep.isEnabled || clocStep.isEnabled,
            analyze.title,
            swiftLintStep,
            clocStep)
}

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

BuildStage getBuildStage(Map environment, Map build) {
    List itemList = build.items
    
    BuildItem[] buildItemList = []
    itemList.each { item ->
        List profileList = item.provisioningProfiles
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
                NameBuilder.getOutputName(environment.projectName, item.id),
                item.configuration,
                item.scheme,
                item.exportMethod,
                buildProfileList
        )
        buildItemList += buildItem
    }

    return new BuildStage(
            build.isEnabled,
            build.title,
            NameBuilder.getProjectFilename(environment.projectName),
            NameBuilder.getWorkspaceFilename(environment.workspaceName),
            environment.outputPath + "/gym",
            buildItemList)
}


// --------------------------
// --- Distribution Stage ---
// --------------------------
class DistributionStage extends Stage {
    DistributionStage(Boolean isEnabled, String title) {
        super(isEnabled, title)
    }
}

DistributionStage getDistributionStage(Map distribution) {
    return new DistributionStage(distribution.isEnabled, distribution.title)
}


// ---------------
// --- Helpers ---
// ---------------
interface StageStep {
    Boolean isEnabled
    String executionCommand()
}

class Stage {
    Boolean isEnabled
    String title
    
    Stage(Boolean isEnabled, String title) {
        this.isEnabled = isEnabled
        this.title = title
    }
}

class NameBuilder {
    static String getProjectFilename(projectName) {
        return projectName + ".xcodeproj"
    }

    static String getWorkspaceFilename(workspaceName) {
        return (workspaceName.getClass() == String) ? (workspaceName + ".xcworkspace") : null
    }
    
    static String getConfigFile(configFile) {
        return (configFile.getClass() == String) ? configFile : null
    }
    
    static String getOutputName(projectName, buildId) {
        return projectName + "-" + buildId + ".ipa"
    }
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

    static String getPlatformParam(String platform) {
        return " platform:" + "\"" + platform + "\""
    }

    static String getDevicesParam(String devices) {
        return " devices:" + "\"" + devices + "\""
    }
    
    static String getConfigFileParam(String configFile) {
        return (configFile == null) ? "" : (" configFile:" + configFile)
    }
    
    static String getExcludeDirectoriesParam(String excludeDirectories) {
        return " excludeDirectories:" + "\"" + excludeDirectories + "\""
    }
    
    static String getPodFileParam(String podFile) {
        return " podFile:" + "\"" + podFile + "\""
    }
}

void run(String command) {
    sh command
}
