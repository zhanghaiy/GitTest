//
//  MainCell.m
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell
#define kImageButtonTag 112233

- (void)awakeFromNib {
    // Initialization code
    UIColor *titleTextColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    UIColor *detailTextColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1];
    
    _timeLable.textColor = detailTextColor;
    _formLable.textColor = detailTextColor;
    _desLable.textColor = detailTextColor;
    _titleLable.textColor = titleTextColor;
    
    CGRect backRect = _backView.frame;
    backRect.origin.x = 10;
    backRect.origin.y = 20;
    backRect.size.width = kScreenWidth-20;
    _backView.frame = backRect;
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = 5;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    
    [self createImagesButton];
}

#pragma mark - 创建图片展示View
- (void)createImagesButton
{
    // 根据数据决定创建几个图片button
    NSArray *arr = @[@"12.jpg",@"pictureShow.png",@"文章缩略图.png",@"pictureShow.png",@"12.jpg"];
    // http://imgs.xiuna.com/xiezhen/2013-3-20/1/12.jpg
    for (int i = 0; i < arr.count; i ++)
    {
        NSInteger wid = self.backView.frame.size.width;
        NSInteger hei = self.backView.frame.size.height;
        NSInteger btnHeight = (wid-10)/5;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kImageButtonTag + i;
        [btn setFrame:CGRectMake(5+i*btnHeight, hei-btnHeight-5, btnHeight, btnHeight)];
        [btn setBackgroundImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:btn];
    }
}

#pragma mark - 点击放大图片
- (void)btnClicked:(UIButton *)btn
{
    // 图片按钮点击事件
    // 放大观看 ----未完成
    NSArray *arr = @[@"12.jpg",@"pictureShow.png",@"文章缩略图.png",@"pictureShow.png",@"12.jpg"];
    [self.delegate imageButtonClicked:btn withDataArray:arr];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toWanQi:(id)sender
{
    if ([self.delegate respondsToSelector:self.action])
    {
//        [self.delegate performSelector:self.action withObject:sender withObject:nil];
    }
}
@end
