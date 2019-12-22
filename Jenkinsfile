class ProjectConfiguration {
    TestStage testStage
    
    ProjectConfiguration(TestStage testStage) {
        this.testStage = testStage
    }
}

class TestStage {
    Boolean isEnabled
    String projectName
    String[] devices
    String reportPath
    
    TestStage(
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
        ProjectConfiguration configuration = getProjectConfiguration('config.json')
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'bundle install'
            }
        }

        stage('Test') {
            steps {
                executeTestStage(${configuration.testStage})
            }
            post {
                always {
                    junit '${configuration.testStage.reportPath}/scan/*.junit'
                }
            }
        }
    }

    post {
        success {
            sh 'echo success :)'
        }

        failure {
            sh 'echo failure :('
        }
    }
}

ProjectConfiguration getProjectConfiguration(String configPath) {
    def config = readJSON file: configPath
    def environment = config.environment
    def stages = config.stages
    def test = stages.test

    TestStage testStage = new TestStage(
            test.isEnabled,
            environment.projectName,
            test.devices,
            environment.reportPath)

    println("TestStage: " + testStage.getClass())
    return new ProjectConfiguration(testStage)
}

void executeTestStage(TestStage stage) {
    println("TestStage: " + stage.getClass())
    
    sh 'bundle exec fastlane test'
            + ' projectName:${stage.projectName}'
            + ' devices:${stage.devices}'
            + ' reportPath:${stage.reportPath}'
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
