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

ProjectConfiguration configuration

pipeline {
    agent any

    options {
        ansiColor('xterm')
    }
    
    environment {
        configuration = getProjectConfiguration('config.json')
    }

    stages {
        stage('SetUp') {
            steps {
                sh 'bundle install'
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

    println("TestStage1: " + testStage.getClass())
    return new ProjectConfiguration(testStage)
}



