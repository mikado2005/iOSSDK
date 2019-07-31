//
//  AppDelegate.m
//  TheoremReachiOSExampleApp
//
//  Created by Tom Hammond on 6/14/17.
//  Copyright © 2017 theoremreach. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [TheoremReach initWithApiKey:@"9148c4176f36f5302eb0a56695eb" userId:@"23344342252"];
    
    [[TheoremReach getInstance] setRewardListenerDelegate:self];
    
    [[TheoremReach getInstance] setSurveyListenerDelegate:self];
    
    [[TheoremReach getInstance] setSurveyAvailableDelegate:self];
        
    //customize navigation bar look
    [TheoremReach getInstance].navigationBarTextColor = @"#FFFFFF";
    [TheoremReach getInstance].navigationBarText = @"Demo Title";
    [TheoremReach getInstance].navigationBarColor = @"#211548";
    
    // If desired, register to receive Apple Push Notifications
    [self registerForPushNotifications];
    
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
        NSLog(@"TheoremReach Survey Available!");
    } else {
        NSLog(@"TheoremReach Survey Not Available!");
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

// MARK: Remote notifications

NSString *apnDeviceTokenKey = @"apnDeviceToken";

- (void)registerForPushNotifications {
    [[UNUserNotificationCenter currentNotificationCenter]
        requestAuthorizationWithOptions:(
            UNAuthorizationOptionAlert +
            UNAuthorizationOptionSound +
            UNAuthorizationOptionBadge)
        completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"Apple Push Notifications: Permission GRANTED");
            }
            else {
                NSLog(@"Apple Push Notifications: Permission REFUSED");
                return;
            }
            [self getNotificationSettings];
        }
     ];
}

- (void) getNotificationSettings {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) return;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        });
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *token = [NSString
                       stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Apple Push Notifications: Device Token: %@", token);
    
    // OPTIONAL: Save the APN device token in defaults file
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:apnDeviceTokenKey];

    // This is a good place to update the user's APNS DeviceToken on the remote server!
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog (@"Apple Push Notifications: Failed to register: %@", error);
}

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo
        fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    NSLog(@"**** didReceiveRemoteNotification");
    NSString *acuid = [userInfo valueForKey:@"acuid"];
    if (acuid) {
        ViewController *rvc = (ViewController *) [
            [(AppDelegate*) [[UIApplication sharedApplication] delegate] window]
            rootViewController];
        [rvc openHotSurvey:acuid];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
