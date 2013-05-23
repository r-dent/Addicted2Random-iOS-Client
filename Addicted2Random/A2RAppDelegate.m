//
//  a2rAppDelegate.m
//  Addicted2Random
//
//  Created by Roman Gille on 10.04.13.
//  Copyright (c) 2013 Roman Gille. All rights reserved.
//

#import "A2RAppDelegate.h"

#import "A2RServerListController.h"
#import "A2RSplashViewController.h"

@implementation A2RAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //[self.window addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]]];
    self.viewController = [[A2RServerListController alloc] initWithNibName:@"A2RServerListController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    
    [[UINavigationBar appearance] setTintColor:A2R_BLUE];
    [[UIBarButtonItem appearance] setTintColor:A2R_YELLOW];
    
    [self.window makeKeyAndVisible];
    
    A2RSplashViewController *splashVC = [[A2RSplashViewController alloc] init];
    [self.viewController presentViewController:splashVC animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.f target:splashVC selector:@selector(disappear) userInfo:nil repeats:NO];
    
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
