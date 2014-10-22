//
//  AppDelegate.m
//  Events
//
//  Created by Brian Huynh
//  Copyright (c) 2014 Brian Huynh. All rights reserved.

#import "AppDelegate.h"
#import "MainViewController.h"
#include <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Create an instance of our MainViewController and initialize it 
    MainViewController *vc = [[MainViewController alloc] initWithStyle:UITableViewStylePlain];
    /*Create a navigation controller so we can manage display of multiple controllers
     and initialize it with our 'vc' as its' rootviewcontroller */
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.window makeKeyAndVisible];
    // Set the windows rootviewcontroller as our navigation controller
    [self.window setRootViewController:navController];
    // Insert Google Maps API Key here
    [GMSServices provideAPIKey:@"AIzaSyDT9Bdn1WiNwtK46KRVML6JrEMEYLMgu9M"];
   
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
