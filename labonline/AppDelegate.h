//
//  AppDelegate.h
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PPRevealSideViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) PPRevealSideViewController *revealSideViewController;

@end

