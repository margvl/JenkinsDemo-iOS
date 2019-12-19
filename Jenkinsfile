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
      junit '../test_output/report.junit'
      
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
