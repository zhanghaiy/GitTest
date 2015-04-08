//
//  MainListCell.m
//  labonline
//
//  Created by cocim01 on 15/4/1.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "MainListCell.h"

@implementation MainListCell
#define kLabTag 123


- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"awakeFromNib");
    _baseBackView.layer.masksToBounds = YES;
    _baseBackView.layer.cornerRadius = 5;
    _baseBackView.layer.borderWidth = 1;
    _baseBackView.layer.borderColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1].CGColor;
    
    [_categoryTitleButton setBackgroundImage:[UIImage imageNamed:@"分类按钮back.png"] forState:UIControlStateNormal];
    [_categoryTitleButton setTitle:@"生物检验" forState:UIControlStateNormal];
    [_categoryTitleButton setTitleColor:[UIColor colorWithRed:216/255.0 green:56/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
    _categoryTitleButton.titleLabel.font = [UIFont systemFontOfSize:kOneFontSize];
    _categoryTitleButton.backgroundColor = [UIColor clearColor];
}


- (void)setListArray:(NSArray *)listArray
{
    _listArray = listArray;
    [self uiConfig];
}

- (void)uiConfig
{
    for (int i = 0; i < _listArray.count; i ++)
    {
        UILabel *lab  = [[UILabel alloc]initWithFrame:CGRectMake(10, 5+i*30, kScreenWidth-100, 25)];
        lab.tag = kLabTag + i;
        lab.text = [_listArray objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
        lab.font = [UIFont systemFontOfSize:kOneFontSize];
        lab.userInteractionEnabled = YES;
        [_baseBackView addSubview:lab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLableMethod)];
        [lab addGestureRecognizer:tap];
        
        UIImageView *youLanImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-90, 12+i*30,15, 12)];
        youLanImgV.image = [UIImage imageNamed:@"游览.png"];
        [_baseBackView addSubview:youLanImgV];
        // 游览数
        UILabel *youLanLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-70, 13+i*30,30, 12)];
        youLanLable.text = @"3215";
        youLanLable.textAlignment = NSTextAlignmentLeft;
        youLanLable.textColor = [UIColor colorWithRed:232/255.0 green:21/255.0 blue:37/255.0 alpha:1];
        youLanLable.font = [UIFont systemFontOfSize:kThreeFontSize];
        [_baseBackView addSubview:youLanLable];
        
        if (i<_listArray.count-1)
        {
            UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30+i*30, kScreenWidth-50, 1)];
            lineLab.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
            [_baseBackView addSubview:lineLab];
        }
    }
}

- (void)tapLableMethod
{
    NSLog(@"~~~~~tap~~~~~~~");
    if ([self.target respondsToSelector:self.action])
    {
        [self.target performSelector:self.action withObject:self afterDelay:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
