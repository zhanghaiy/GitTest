//
//  ShareView.m
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];
}

- (void)tapClicked
{
    [self removeFromSuperview];
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:nil afterDelay:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
