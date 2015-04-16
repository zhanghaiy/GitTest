//
//  UIView+Category.m
//  labonline
//
//  Created by cocim01 on 15/4/14.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "UIView+Category.h"
#import "HZActivityIndicatorView.h"


@implementation UIView (Category)


+(void)removeLoadingVIewInView:(UIView *)superV
{
    UIView *loadingV = [superV viewWithTag:12345];
    [loadingV removeFromSuperview];
}

+ (void)addLoadingViewInView:(UIView *)superView
{
    NSInteger wid = superView.frame.size.width;
    NSInteger height = superView.frame.size.height;
    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wid, height-64)];//[[UIView alloc]initWithFrame:superView.frame]; //[[UIView alloc]initWithFrame:CGRectMake(0, 0, wid-20, 200)];
    loadingView.tag = 12345;
    loadingView.backgroundColor = [UIColor colorWithWhite:100/255.0 alpha:0.6];
//    loadingView.layer.masksToBounds =  YES;
//    loadingView.layer.cornerRadius = 5;
//    loadingView.layer.borderColor = [UIColor colorWithRed:36/255.0 green:57/255.0 blue:121/255.0 alpha:0.8].CGColor;
//    loadingView.layer.borderWidth = 1;
//    loadingView.center = CGPointMake(wid/2, height/3);
    [superView addSubview:loadingView];
    
    HZActivityIndicatorView *activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.opaque = YES;
    activityIndicator.steps = 16;
    activityIndicator.finSize = CGSizeMake(4, 20);
    activityIndicator.indicatorRadius = 15;
    activityIndicator.stepDuration = 0.100;
    activityIndicator.color = [UIColor colorWithRed:0.0 green:34.0/255.0 blue:85.0/255.0 alpha:1.000];
    activityIndicator.roundedCoreners = UIRectCornerTopRight;
    activityIndicator.cornerRadii = CGSizeMake(10, 10);
    activityIndicator.center = CGPointMake((NSInteger)wid/2, (height-64)/2);
    [loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}


@end
