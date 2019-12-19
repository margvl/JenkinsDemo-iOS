#!groovy


pipeline {
  agent any

  options {
    applyConsoleStyling()
    def config = readJSON file: 'ci.configuration.json'
    sh 'echo ${config}'
  }

  stages {
    stage
    stage('Tests') {
      steps {
        executeTests()
      }
    }
  }

  post {
    always {
    
      sh 'echo $PWD'
    
      // Processing test results
      junit 'build/results/scan/report.junit'
      
      // Cleanup
      sh 'rm -rf build'
    }
    
    success {
      sh 'echo "success :)"'
    }
    
    failure {
      sh 'echo "failure :("'
    }
  }
}

void executeTests() {
    sh 'bundle exec fastlane test'
}

void applyConsoleStyling() {
    ansiColor("xterm")
}
