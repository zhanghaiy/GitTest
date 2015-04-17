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


//+(void)removeLoadingVIewInView:(UIView *)superV
//{
//    UIView *loadingV = [superV viewWithTag:12345];
//    [loadingV removeFromSuperview];
//}
//
//+ (void)addLoadingViewInView:(UIView *)superView
//{
//    NSInteger wid = superView.frame.size.width;
//    NSInteger height = superView.frame.size.height;
//    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wid, height-64)];
//    loadingView.tag = 12345;
//    loadingView.backgroundColor = [UIColor colorWithWhite:100/255.0 alpha:0.6];
//    [superView addSubview:loadingView];
//    
//    HZActivityIndicatorView *activityIndicator = [[HZActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    activityIndicator.backgroundColor = [UIColor clearColor];
//    activityIndicator.opaque = YES;
//    activityIndicator.steps = 16;
//    activityIndicator.finSize = CGSizeMake(4, 20);
//    activityIndicator.indicatorRadius = 15;
//    activityIndicator.stepDuration = 0.100;
//    activityIndicator.color = [UIColor colorWithRed:0.0 green:34.0/255.0 blue:85.0/255.0 alpha:1.000];
//    activityIndicator.roundedCoreners = UIRectCornerTopRight;
//    activityIndicator.cornerRadii = CGSizeMake(10, 10);
//    activityIndicator.center = CGPointMake((NSInteger)wid/2, (height-64)/2);
//    [loadingView addSubview:activityIndicator];
//    [activityIndicator startAnimating];
//}

- (void)addLoadingViewInSuperView:(UIView *)superView andTarget:(UIViewController*)taget
{
    NSInteger wid = superView.frame.size.width;
    NSInteger height = superView.frame.size.height-64;
    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wid, height)];
    loadingView.tag = 112233;
    loadingView.backgroundColor = [UIColor colorWithWhite:80/255.0 alpha:0.8];
    [superView addSubview:loadingView];

    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 200)];
    subView.center = loadingView.center;
    subView.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:0.6];
    subView.layer.masksToBounds = YES;
    subView.layer.cornerRadius = 5;
    subView.layer.borderColor = [UIColor colorWithRed:169/255.0 green:183/255.0 blue:209/255.0 alpha:1].CGColor;
    subView.layer.borderWidth = 1;
    [loadingView addSubview:subView];
    
    UILabel *loadingLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-40-120)/2, 20, 120, 120)];
    loadingLable.font = [UIFont systemFontOfSize:11];
    loadingLable.text = @"LOADING....";
    loadingLable.textAlignment = NSTextAlignmentCenter;
    loadingLable.textColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [subView addSubview:loadingLable];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-40-120)/2, 20, 120, 120)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.animationImages = @[[UIImage imageNamed:@"1_13.png"],[UIImage imageNamed:@"3_13.png"],[UIImage imageNamed:@"2_13.png"],[UIImage imageNamed:@"4_13.png"],[UIImage imageNamed:@"5_13.png"],[UIImage imageNamed:@"6_13.png"],[UIImage imageNamed:@"7_13.png"],[UIImage imageNamed:@"8_13.png"]];
    imageV.animationDuration = 3;
    imageV.animationRepeatCount = -1;
    [subView addSubview:imageV];
    [imageV startAnimating];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, kScreenWidth-80, 30)];
    lable.font = [UIFont systemFontOfSize:kOneFontSize];
    lable.text = @"正在加载中.......";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1];
    [subView addSubview:lable];
}

- (void)removeLoadingVIewInView:(UIView *)superV andTarget:(UIViewController *)target
{
    UIView *loadingV = [superV viewWithTag:112233];
    [loadingV removeFromSuperview];
}

- (void)addAlertViewWithMessage:(NSString *)message andTarget:(id)target
{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:target cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertV show];
}

@end
