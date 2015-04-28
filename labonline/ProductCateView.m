//
//  ProductCateView.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ProductCateView.h"

@implementation ProductCateView

#define kProductCateLableTag 333
//(30*kScreenHeight/480)
#define kCategoryLableHeight 30

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCounts:(int)counts
{
    [self createCategoryLableWithCounts:counts];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithWhite:221/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    
    _topImgV.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    _topImgV.layer.masksToBounds = YES;
    _topImgV.layer.borderWidth = 1;
    _topImgV.layer.borderColor = [UIColor colorWithWhite:221/255.0 alpha:1].CGColor;
    
    _titleLab.textColor = [UIColor colorWithRed:217/255.0 green:0/255.0 blue:37/255.0 alpha:1];
}

- (void)createCategoryLableWithCounts:(NSInteger)count
{
    NSArray *array = @[@"仪器",@"试剂",@"耗材"];
    NSInteger index = 0;
    NSInteger lableWidth = (self.bounds.size.width-20)/3;
    NSInteger hang = count%3?count/3+1:count/3;
    for (int i = 0; i < hang; i ++)
    {
        for (int j = 0; j < 3; j ++)
        {
            if (index < count)
            {
                UILabel *cateLab = [[UILabel alloc]initWithFrame:CGRectMake(5+j*(lableWidth+5), 40+i*(kCategoryLableHeight+10), lableWidth, kCategoryLableHeight)];
                cateLab.text = [array objectAtIndex:j];
                cateLab.tag = kProductCateLableTag+index;
                cateLab.textAlignment = NSTextAlignmentCenter;
                cateLab.font = [UIFont systemFontOfSize:kTwoFontSize];
                cateLab.layer.masksToBounds = YES;
                cateLab.layer.cornerRadius = 3;
                cateLab.layer.borderWidth = 1;
                cateLab.layer.borderColor = [UIColor colorWithWhite:241/255.0 alpha:1].CGColor;
                cateLab.userInteractionEnabled = YES;
                cateLab.textColor = [UIColor colorWithWhite:86/255.0 alpha:1];
                [self addSubview:cateLab];
                
                UITapGestureRecognizer *tapCateLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCateLableMethod:)];
                [cateLab addGestureRecognizer:tapCateLab];
                
                index ++;
            }
        }
    }
}

- (void)tapCateLableMethod:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap%ld",tap.view.tag-kProductCateLableTag);
    if ([self.delegate respondsToSelector:self.action])
    {
        [_delegate performSelector:_action withObject:nil afterDelay:0.01];
    }
}

@end
