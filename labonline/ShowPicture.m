//
//  ShowPicture.m
//  labonline
//
//  Created by cocim01 on 15/4/8.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ShowPicture.h"

#define kPageControlTag 222
#define kScrollViewTag 223
#define kImgViewTag 333

@implementation ShowPicture

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)index andImageDataArray:(NSArray *)array
{
    _imageDataArray = array;
    _selectedIndex = index;
    [self makeUpSubViews];
}

- (void)makeUpSubViews
{
    self.backgroundColor = [UIColor colorWithRed:18/255.0 green:28/255.0 blue:31/255.0 alpha:1];
    NSInteger wid = self.bounds.size.width;
    NSInteger height = self.bounds.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, wid, height)];
    scrollView.contentSize = CGSizeMake(wid*_imageDataArray.count, height);
    scrollView.tag = kScrollViewTag;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentOffset = CGPointMake(wid*_selectedIndex, 0);
    [self addSubview:scrollView];
    
    for (int i = 0; i < _imageDataArray.count; i ++)
    {
        UIImage *img = [UIImage imageNamed:[_imageDataArray objectAtIndex:i]];
        NSInteger imageWid = img.size.width;
        NSInteger imageHeight = img.size.height;
        if (imageWid>wid-20||imageHeight>(height-120))
        {
            float level = (float)imageWid/(float)imageHeight;
            imageWid = wid-20;
            imageHeight = imageWid/level;
        }
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(i*wid+(wid-imageWid)/2, (kScreenHeight-imageHeight)/2, imageWid, imageHeight)];
        imgV.image = img;
        [scrollView addSubview:imgV];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((wid-100)/2, height-50, 100, 10)];
    pageControl.tag = kPageControlTag;
    pageControl.numberOfPages = _imageDataArray.count;
    pageControl.currentPage = _selectedIndex;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self addSubview:pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgVMethod)];
    [self addGestureRecognizer:tap];
}

#pragma mark --tapMethod
- (void)tapImgVMethod
{
    [self removeFromSuperview];
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:nil afterDelay:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:kPageControlTag];
    pageControl.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
