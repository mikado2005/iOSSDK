//
//  ViewController.swift
//  Swift Example App
//
//  Created by Tom Hammond on 4/24/19.
//  Copyright © 2019 theoremreach. All rights reserved.
//

import UIKit
import TheoremReachSDK

class ViewController: UIViewController {
    
    @IBAction func openSurveyButton(_ sender: Any) {
        openRewardsCenter()
    }
    
    @IBAction func openHotSurveyButton(_ sender: Any) {
        openHotSurvey("0bb25f4d-6579-4218-bb5f-202f6db32972")
    }
    
    func openRewardsCenter() {
        guard let theoremReach = TheoremReach.getInstance() else { return }
        if theoremReach.isSurveyAvailable {
            TheoremReach.showRewardCenter()
        }
    }
    
    func openHotSurvey(_ surveyAcuid: String) {
        guard surveyAcuid != "" else { return }
        guard let theoremReach = TheoremReach.getInstance() else { return }
        theoremReach.showHotSurvey(surveyAcuid)
    }

}

