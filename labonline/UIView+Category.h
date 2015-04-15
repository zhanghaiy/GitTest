//
//  UIView+Category.h
//  labonline
//
//  Created by cocim01 on 15/4/14.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)

+ (UIView *)createLoadingView;

+ (void)addLoadingViewInView:(UIView *)superView;
+ (void)removeLoadingVIewInView:(UIView *)superV;

@end
