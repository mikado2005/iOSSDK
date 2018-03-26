//
//  AppDelegate.m
//  TheoremReachiOSExampleApp
//
//  Created by Tom Hammond on 6/14/17.
//  Copyright © 2017 theoremreach. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [TheoremReach initWithApiKey:@"9148c4176f36f5302eb0a56695eb" userId:@"ExampleUniqueUserID"];
        
    [[TheoremReach getInstance] setRewardListenerDelegate:self];
    
    [[TheoremReach getInstance] setSurveyListenerDelegate:self];
    
    [[TheoremReach getInstance] setSurveyAvailableDelegate:self];
    
    //customize navigation bar look
    [TheoremReach getInstance].navigationBarTextColor = @"#FFFFFF";
    [TheoremReach getInstance].navigationBarText = @"iOS Demo App";
    [TheoremReach getInstance].navigationBarColor = @"#17b4b3";
    
    return YES;
}

- (void)onReward: (NSNumber* )quantity {
    // award user the content!
    NSLog(@"TheoremReach onReward: %@", quantity);
}

- (void)onRewardCenterOpened {
    // reward center opened! Time to take surveys!
    NSLog(@"TheoremReach onRewardCenterOpened");
}

- (void)onRewardCenterClosed {
    // reward center opened! Back to the app to use our coins!
    NSLog(@"TheoremReach onRewardCenterClosed");
}

-(void)theoremreachSurveyAvailable: (BOOL) surveyAvailable {
    if (surveyAvailable) {
        NSLog(@"TheoremReach survey available!");
    } else {
        NSLog(@"TheoremReach survey not available!");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
