//
//  AppDelegate.h
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "MainViewController.h"
#import "oneViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    //MLNavigationController *navCtrl;
}

@property (strong, nonatomic)IBOutlet UIWindow *window;

@property (nonatomic, retain) oneViewController *mainView;
@end
