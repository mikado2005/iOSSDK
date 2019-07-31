//
//  ViewController.m
//  TheoremReachiOSExampleApp
//
//  Created by Tom Hammond on 6/14/17.
//  Copyright © 2017 theoremreach. All rights reserved.
//

#import "ViewController.h"
#import <TheoremReachSDK/TheoremReach.h>

@implementation ViewController

- (IBAction)openSurveyButton: (id)sender {
    [self openRewardsCenter];
}

- (IBAction)openHotSurveyButton: (id)sender {
    [self openHotSurvey:@"0bb25f4d-6579-4218-bb5f-202f6db32972"];
}

- (void)openRewardsCenter {
    if ([[TheoremReach getInstance] isSurveyAvailable]) {
        //placement example for additional targeting
        //        [TheoremReach showRewardCenter:@"be4aa618-3c11-498a-92f9-43bb01f2a4c9"];
        [TheoremReach showRewardCenter];
    }
}

- (void)openHotSurvey: (NSString *)acuid {
    if ([acuid length] < 1) { return; }
    TheoremReach *theoremReach = [TheoremReach getInstance];
    if (theoremReach == nil) { return; }
    [theoremReach showHotSurvey:acuid];
 }

@end
