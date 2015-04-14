//
//  UIView+Category.m
//  labonline
//
//  Created by cocim01 on 15/4/14.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

+ (UIView *)createLoadingView
{
    NSInteger width = kScreenWidth-20;
    NSInteger height = 180;
    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-width)/2, 0, width, height)];
    loadingView.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    loadingView.layer.masksToBounds = YES;
    loadingView.layer.cornerRadius = 5;
    loadingView.layer.borderColor = [UIColor colorWithRed:66/255.0 green:192/255.0 blue:156/255.0 alpha:1].CGColor;
    loadingView.layer.borderWidth = 1;
    
    UIActivityIndicatorView *activityV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((width-120)/2, 20, 120, 120)];
    activityV.backgroundColor = [UIColor clearColor];
    activityV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [loadingView addSubview:activityV];
    [activityV startAnimating];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, width, 30)];
    lable.text = @"正在加载......";
    lable.font= [UIFont systemFontOfSize:kOneFontSize];
    lable.numberOfLines = 0;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor purpleColor];
    [loadingView addSubview:lable];
    return loadingView;
}


@end
