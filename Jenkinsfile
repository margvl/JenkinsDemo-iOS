#!groovy

def configPath = 'config.json'

class Environment {
    String projectName
    String sourcePath
    String reportPath = "./build/report/"
    String outputPath = "./build/output/"
    
    Environment(projectName, sourcePath) {
        this.projectName = projectName
        this.sourcePath = sourcePath
    }
}

pipeline {
    agent any

    options {
        ansiColor("xterm")
    }
    
    environment {
        def config = readJSON file: configPath
        Environment environment = getEnvironment()
        
        
        def projectName = "${config.environment.projectName}"
        def sourcePath = "${config.environment.sourcePath}"
        def reportPath = "./build/report/"
        def outputPath = "./build/output/"
        
        def isTestStageEnabled = "${config.stages.test.isEnabled}"
        def isTestCoverageStageEnabled = "${config.stages.test.coverage.isEnabled}"
    }

    stages {
        stage('SetUp') {
            steps {
                sh "bundle install"
            }
        }

        stage('Test') {
            when { expression { isTestStageEnabled > 0 } }
            steps {
                sh "echo ${environment.projectName}"
            }
            post {
                always {
                    junit "$reportPath/scan/report.junit"
                }
            }
        }
        
        stage('Coverage') {
            when { expression { isTestCoverageStageEnabled > 0 } }
            steps {
                sh "echo ${environment.sourcePath}"
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

Environment getEnvironment() {
    def config = readJSON file: configPath
    return new Environment(config.environment.projectName, config.environment.sourcePath)
}

void executeTestStage(def json) {
    def config = readJSON text: json
    println("Will print config:")
    println(config)
    String projectName = "${config.environment.projectName}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane test projectName:$projectName reportPath:$reportPath"
}

void executeTestCoverageStage(def json) {
    def config = readJSON text: json
    String projectName = "${config.environment.projectName}"
    String sourcePath = "${config.environment.sourcePath}"
    String reportPath = "${config.environment.reportPath}"

    sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
}
