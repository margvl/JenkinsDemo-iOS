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
    
    static func duplicateFuncValue() -> String {
        print("We are adding more text so we could consider it as a duplicate1")
        print("We are adding more text so we could consider it as a duplicate2")
        print("We are adding more text so we could consider it as a duplicate3")
        print("We are adding more text so we could consider it as a duplicate4")
        print("We are adding more text so we could consider it as a duplicate5")
        return "Duplicate"
    }
}



//




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





