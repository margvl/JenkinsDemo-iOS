#!groovy

pipeline {
  agent any

  stages {
    stage('Tests') {
      steps {
        sh 'bundle exec fastlane test'
      }
    }
  }

  post {
    always {
      // Processing test results
      junit 'fastlane/test_output/report.junit'
      
      // Cleanup
      // sh 'rm -rf build'
    }
    
    success {
      sh 'echo "success :)"'
    }
    
    failure {
      sh 'echo "failure :("'
    }
  }
}
