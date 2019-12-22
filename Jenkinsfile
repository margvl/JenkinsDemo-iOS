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

