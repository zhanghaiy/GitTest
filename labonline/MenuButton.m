//
//  MenuButton.m
//  TestMenu_04_27
//
//  Created by cocim01 on 15/4/27.
//  Copyright (c) 2015年 keximeng. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

- (void)drawRect:(CGRect)rect
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:228/255.0 green:129/255.0 blue:138/255.0 alpha:1].CGColor;
    self.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor colorWithRed:217/255.0 green:0 blue:36/255.0 alpha:1] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
