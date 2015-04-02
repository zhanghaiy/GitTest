//
//  PictureShowView.m
//  labonline
//
//  Created by cocim01 on 15/3/24.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "PictureShowView.h"
#import "DeviceManager.h"

@implementation PictureShowView
{
    NSInteger width;
    NSInteger height;
    NSInteger _currentPage;
    UIPageControl *_pageControl;
    UILabel *_titleLab;
    UIScrollView *_imageScroll;
    NSTimer *_mainTimer;
}
#define kPageControlWidth 80
#define ImageCounts 5
#define kImageViewTag 5555

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self makeUpContent];
    }
    return self;
}

- (void)setImageInfoArray:(NSArray *)imageInfoArray
{
    _imageInfoArray = imageInfoArray;
    [self createImageView];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}


- (void)timerMethod
{
    // 定时器
    if (_currentPage<_imageInfoArray.count-1)
    {
        _currentPage++;
    }
    else if ((_imageInfoArray.count-1)== _currentPage)
    {
        _currentPage = 0;
    }
    [self changePicture];
}

- (void)makeUpContent
{
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    _currentPage = 0;
    self.backgroundColor = [UIColor whiteColor];
    _imageScroll = [[UIScrollView alloc]initWithFrame:self.bounds];
    _imageScroll.contentSize = CGSizeMake(width*ImageCounts, 0);
    _imageScroll.pagingEnabled = YES;
    _imageScroll.delegate = self;
    _imageScroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:_imageScroll];
    
    
    UIView *downV = [[UIView alloc]initWithFrame:CGRectMake(0, height-30, width, 30)];
    downV.backgroundColor = [UIColor colorWithRed:169/255.0 green:168/255.0 blue:168/255.0 alpha:0.5];
    [self addSubview:downV];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(width-kPageControlWidth, 10, kPageControlWidth-10, 10)];
    _pageControl.numberOfPages = ImageCounts;
    _pageControl.currentPage = 0;
    [downV addSubview:_pageControl];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width-kPageControlWidth, 30)];
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = @"北大医院个性化服务医疗体系";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.numberOfLines = 0;
    [downV addSubview:_titleLab];
}

- (void)createImageView
{
    NSArray *colorArr = [self makeUpColorArray];
    for (int i = 0; i < colorArr.count; i ++)
    {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        imgV.layer.masksToBounds = YES;
        imgV.layer.cornerRadius = 5;
//        imgV.image = [UIImage imageNamed:@"pictureShow.png"];
        imgV.backgroundColor = [[self makeUpColorArray] objectAtIndex:i];
        imgV.tag = kImageViewTag+i;
        imgV.userInteractionEnabled = YES;
        [_imageScroll addSubview:imgV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageMethod:)];
        [imgV addGestureRecognizer:tap];
    }
}

#pragma mark - 点击图片进入详情
- (void)tapImageMethod:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击图片进入详情");
    _imageIndex = tap.view.tag=kImageViewTag;
    if ([self.target respondsToSelector:self.action])
    {
        [self.target performSelector:self.action withObject:self withObject:nil];
    }
}

- (NSArray *)makeUpColorArray
{
    UIColor *color = [UIColor colorWithRed:143/255.0 green:205/255.0 blue:201/255.0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:134/255.0 green:208/255.0 blue:249/255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:69/255.0 green:93/255.0 blue:135/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:143/255.0 green:205/255.0 blue:201/255.0 alpha:1];
     UIColor *color4 = [UIColor colorWithRed:134/255.0 green:208/255.0 blue:249/255.0 alpha:1];
    NSArray *colorArray = @[color,color1,color2,color3,color4];
    return colorArray;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentPage = scrollView.contentOffset.x/width;
    _pageControl.currentPage = _currentPage;
    _titleLab.text = [NSString stringWithFormat:@"杂志的标题%ld",_currentPage];
}

#pragma mark - 变换图片与标题
- (void)changePicture
{
    float y = _imageScroll.contentOffset.y;
    _imageScroll.contentOffset = CGPointMake(_currentPage*width, y);
    _pageControl.currentPage = _currentPage;
    _titleLab.text = [NSString stringWithFormat:@"杂志的标题%ld",_currentPage];
}


- (void)dealloc
{
    [_mainTimer invalidate];
    _mainTimer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
