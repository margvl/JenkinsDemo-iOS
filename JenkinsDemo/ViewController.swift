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

