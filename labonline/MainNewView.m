//
//  MainNewView.m
//  labonline
//
//  Created by cocim01 on 15/4/3.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainNewView.h"

@implementation MainNewView
#define kImageButtonTag 112233


- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setImageDataArray:(NSArray *)imageDataArray
{
    _imageDataArray = imageDataArray;
    [self createImagesButton];
}

#pragma mark - 创建图片展示View
- (void)createImagesButton
{
    // 根据数据决定创建几个图片button
    NSInteger wid = self.frame.size.width;
    NSInteger hei = self.frame.size.height;
    NSInteger btnWidth = (wid-20)/5;
    NSInteger btnHeight = 60;
    for (int i = 0; i < _imageDataArray.count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kImageButtonTag + i;
        [btn setFrame:CGRectMake(10+i*btnWidth, hei-btnHeight-10, btnWidth, btnHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:[_imageDataArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

#pragma mark - 点击放大图片
- (void)btnClicked:(UIButton *)btn
{
    // 图片按钮点击事件
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:self afterDelay:NO];
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
