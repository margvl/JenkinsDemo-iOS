#!groovy

pipeline {
  agent any

  options {
    ansiColor("xterm")
  }

  stages {
    stage('Tests') {
      steps {
        sh 'bundle exec fastlane test'
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
