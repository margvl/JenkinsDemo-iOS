//
//  ViewController.swift
//  JenkinsDemo
//
//  Created by Martynas Gavelis on 2019-12-17.
//  Copyright © 2019 Martynas Gavelis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


//class ProjectConfiguration {
//    TestStage testStage
//
//    ProjectConfiguration(TestStage testStage) {
//        this.testStage = testStage
//    }
//}
//
//class TestStage {
//    Boolean isEnabled
//    String projectName
//    String[] devices
//    String reportPath
//
//    TestStage(
//            Boolean isEnabled,
//            String projectName,
//            String[] devices,
//            String reportPath) {
//
//        this.isEnabled = isEnabled
//        this.projectName = projectName
//        this.devices = devices
//        this.reportPath = reportPath
//    }
//}
// 
// stage('Test') {
//     steps {
//         executeTestStage()
//     }
//     post {
//         always {
//             junit '${configuration.testStage.reportPath}/scan/*.junit'
//         }
//     }
// }

// void executeTestStage() {
//    TestStage stage = configuration.testStage
//    println("TestStage3: " + stage.getClass())
//
//    sh 'bundle exec fastlane test'
//            + ' projectName:${stage.projectName}'
//            + ' devices:${stage.devices}'
//            + ' reportPath:${stage.reportPath}'
//}

//
// void executeTestCoverageStage(def json) {
//     def config = readJSON text: json
//     String projectName = "${config.environment.projectName}"
//     String sourcePath = "${config.environment.sourcePath}"
//     String reportPath = "${config.environment.reportPath}"
//
//     sh "bundle exec fastlane coverage projectName:$projectName sourcePath:$sourcePath reportPath:$reportPath"
// }
//

//environment {
//    ProjectConfiguration configuration = getProjectConfiguration('config.json')
//}

//ProjectConfiguration getProjectConfiguration(String configPath) {
//    def config = readJSON file: configPath
//    def environment = config.environment
//    def stages = config.stages
//    def test = stages.test
//
//    TestStage testStage = new TestStage(
//            test.isEnabled,
//            environment.projectName,
//            test.devices,
//            environment.reportPath)
//
//    println("TestStage1: " + testStage.getClass())
//    return new ProjectConfiguration(testStage)
//}

