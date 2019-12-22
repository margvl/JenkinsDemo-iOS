#!groovy

class ProjectConfiguration {
    TestStage testStage
    
    ProjectConfiguration(TestStage testStage) {
        this.testStage = testStage
    }
}

class TestStage {
    String isEnabled
    String projectName
    String reportPath
    
    TestStage(isEnabled, projectName, reportPath) {
        this.isEnabed = isEnabled
        this.projectName = projectName
        this.reportPath = reportPath
    }
}

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        ProjectConfiguration configuration = getProjectConfiguration('config.json')
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            steps {
                executeTestStage(configuration.testStage)
            }
            post {
                always {
                    junit "${configuration.testStage.reportPath}/scan/*.junit"
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

ProjectConfiguration getProjectConfiguration(String configPath) {
    def config = readJSON file: configPath
    def environment = config.environment
    def stages = config.stages
    def test = stages.test
    def isEnabled = test.isEnabled

    println("Config: " + config.getClass())
    println("Environment: " + environment.getClass())
    println("ProjectName: " + environment.projectName.getClass())
    println("ReportPath: " + environment.reportPath.getClass())
    println("Stages: " + stages.getClass())
    println("Test: " + test.getClass())
    println("IsEnabled1: " + isEnabled.getClass())
    println("IsEnabled2: " + test.isEnabled.getClass())
    println("Devices: " + test.devices.getClass())

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            environment.reportPath)

    return new ProjectConfiguration(testStage)
}

void executeTestStage(TestStage stage) {
    println("Printing stage class:")
    println(configuration.getClass())
    sh "bundle exec fastlane test"
            + " projectName:${stage.projectName}"
            + " devices:${stage.devices}"
            + " reportPath:${stage.reportPath}"
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
