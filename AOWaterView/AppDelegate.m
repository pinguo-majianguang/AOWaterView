//
//  AppDelegate.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MLNavigationController.h"
#import "oneViewController.h"

@implementation AppDelegate

UIViewController *thisViewController;
NSMutableArray *totalArr;
MLNavigationController *navCtrl;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    // Override point for customization after application launch.
    //    self.window.backgroundColor = [UIColor whiteColor];
    
    //ViewController *viewCtrl = [[ViewController alloc]init];
    
    self.mainView = [[oneViewController alloc] init];
    
    navCtrl = [[MLNavigationController alloc]initWithRootViewController:self.mainView];
    //self.navCtrl = [[UINavigationController alloc] initWithRootViewController:self.mainView];
    
    self.window.rootViewController = navCtrl;
    self.window.backgroundColor = [UIColor colorWithRed:59.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
    [self.window makeKeyAndVisible];
    
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
