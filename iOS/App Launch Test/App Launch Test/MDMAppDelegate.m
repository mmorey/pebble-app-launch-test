//
//  MDMAppDelegate.m
//  App Launch Test
//
//  Created by Matthew Morey on 11/23/13.
//  Copyright (c) 2013 Matthew Morey. All rights reserved.
//

#import "MDMAppDelegate.h"
#import <PebbleKit/PebbleKit.h>

@implementation MDMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    
    uuid_t myAppUUIDbytes;
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"24a1618a-4dfa-419b-b8cf-45776ea33e3b"];
    [myAppUUID getUUIDBytes:myAppUUIDbytes];
    [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];

    PBWatch *lastWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
    
    [lastWatch getVersionInfo:^(PBWatch *watch, PBVersionInfo *versionInfo ) {
        NSLog(@"Pebble name: %@", [watch name]);
        NSLog(@"Pebble serial number: %@", [watch serialNumber]);
        NSLog(@"Pebble firmware os version: %li", (long)versionInfo.runningFirmwareMetadata.version.os);
        NSLog(@"Pebble firmware major version: %li", (long)versionInfo.runningFirmwareMetadata.version.major);
        NSLog(@"Pebble firmware minor version: %li", (long)versionInfo.runningFirmwareMetadata.version.minor);
        NSLog(@"Pebble firmware suffix version: %@", versionInfo.runningFirmwareMetadata.version.suffix);
    } onTimeout:^(PBWatch *watch) {
        NSLog(@"Timed out trying to get version info from Pebble.");
    }];
    
    [lastWatch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        
        if (isAppMessagesSupported) {
            
            [watch appMessagesLaunch:^(PBWatch *watch, NSError *error) {
                
                if (error) {
                    NSLog(@"ERROR: Could not launch watch app\n%@\n%@",[error localizedDescription], [error userInfo]);
                } else {
                    NSLog(@"Watch app launched");
                }
                
            }]; // appMessagesLaunch
        } // if (isAppMessagesSupported) {
    }]; // appMessagesGetIsSupported
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
