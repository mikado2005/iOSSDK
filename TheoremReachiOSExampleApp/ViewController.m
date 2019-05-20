//
//  ViewController.m
//  TheoremReachiOSExampleApp
//
//  Created by Tom Hammond on 6/14/17.
//  Copyright © 2017 theoremreach. All rights reserved.
//

#import "ViewController.h"
#import <TheoremReachSDK/TheoremReach.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchTheoremReach:(id)sender {
    if ([[TheoremReach getInstance] isSurveyAvailable]) {
//        [TheoremReach showRewardCenter:@"be4aa618-3c11-498a-92f9-43bb01f2a4c9"];
        
        [TheoremReach showRewardCenter:@"d38c0152-126e-43af-875d-50e68eb04b1c"];
    }
}

@end
