//
//  MenuViewController.m
//  labonline
//
//  Created by luojg on 15/3/25.
//  Copyright (c) 2015年 引领科技. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_topNaviV;
    UIScrollView *_scrollV;
    UIScrollView *_navScrollV;
    float _startPointX;
}

@end

@implementation MenuViewController
#define WidthOfScreen [UIScreen mainScreen].bounds.size.width
#define HeightOfScreen [UIScreen mainScreen].bounds.size.height
#define MENU_HEIGHT 36
#define MENU_BUTTON_WIDTH  60
#define MIN_MENU_FONT  13.f
#define MAX_MENU_FONT  18.f
#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

- (void)viewDidLoad {
    [super viewDidLoad];
    //界面调整
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _topNaviV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthOfScreen, MENU_HEIGHT)];
    _topNaviV.backgroundColor=RGBA(236.f, 236.f, 236.f, 1);
    [self.view addSubview:_topNaviV];
   
    _navScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MENU_HEIGHT)];
    [_navScrollV setShowsHorizontalScrollIndicator:NO];

    
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topNaviV.frame.origin.y + _topNaviV.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topNaviV.frame.origin.y - _topNaviV.frame.size.height)];
    [_scrollV setPagingEnabled:YES];
    [_scrollV setShowsHorizontalScrollIndicator:NO];
    _scrollV.delegate = self;
    [self.view addSubview:_scrollV];
    
    [self createMenu];
    
}
-(void)createMenu{
     NSArray *arT = @[@"2015", @"2014", @"2013", @"2012", @"2011", @"2010", @"2009", @"2008", @"2007", @"2006"];
    for (int i = 0; i < [arT count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT)];
        [btn setTitle:[arT objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 1;
        if(i==0)
        {
            [self changeColorForButton:btn red:1];
            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
        }else
        {
            btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
            [self changeColorForButton:btn red:0];
        }
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_navScrollV addSubview:btn];
    }
    [_navScrollV setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * [arT count], MENU_HEIGHT)];
    [_topNaviV addSubview:_navScrollV];
    
    //窗口划动与菜单关联起来
    [self addView2Page:_scrollV count:[arT count] frame:CGRectZero];

}
- (void)addView2Page:(UIScrollView *)scrollV count:(NSUInteger)pageCount frame:(CGRect)frame
{
    for (int i = 0; i < pageCount; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollV.frame.size.width * i, 0, scrollV.frame.size.width, scrollV.frame.size.height)];
        view.tag = i + 1;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
        singleTapRecognizer.numberOfTapsRequired = 1;
        [singleTapRecognizer addTarget:self action:@selector(pust2View:)];
        [view addGestureRecognizer:singleTapRecognizer];
        
        [self initPageView:view];
        
        [scrollV addSubview:view];
    }
    [scrollV setContentSize:CGSizeMake(scrollV.frame.size.width * pageCount, scrollV.frame.size.height)];
}

//下面窗口点击事件
- (void)pust2View:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_scrollV];
    int t = point.x/_scrollV.frame.size.width + 1;
    NSLog(@"click %d",t);
}
//初始主界面
- (void)initPageView:(UIView *)view
{
    UITableView *wangQiTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, WidthOfScreen, HeightOfScreen-MENU_HEIGHT)];
    wangQiTable.delegate=self;
    wangQiTable.dataSource=self;
    [view addSubview:wangQiTable];
}
- (void)changeColorForButton:(UIButton *)btn red:(float)nRedPercent
{
    [btn setTitleColor:RGBA(0 + nRedPercent * (212 - 0),25 ,38 ,1) forState:UIControlStateNormal];
}
- (void)actionbtn:(UIButton *)btn
{
    [_scrollV scrollRectToVisible:CGRectMake(_scrollV.frame.size.width * (btn.tag - 1), _scrollV.frame.origin.y, _scrollV.frame.size.width, _scrollV.frame.size.height) animated:YES];
    float xx = _scrollV.frame.size.width * (btn.tag - 1) * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;

    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x=scrollView.contentOffset.x;
    float xx = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    
    float startX = xx;
    //    float endX = xx + MENU_BUTTON_WIDTH;
    int sT = (x)/_scrollV.frame.size.width + 1;
    
    if (sT <= 0)
    {
        return;
    }
    UIButton *btn = (UIButton *)[_navScrollV viewWithTag:sT];
    float percent = (startX - MENU_BUTTON_WIDTH * (sT - 1))/MENU_BUTTON_WIDTH;
    float value = MIN_MENU_FONT + (1-percent) * (MAX_MENU_FONT - MIN_MENU_FONT);
    btn.titleLabel.font = [UIFont systemFontOfSize:value];
    [self changeColorForButton:btn red:(1 - percent)];
    
    if((int)xx%MENU_BUTTON_WIDTH == 0)
        return;
    UIButton *btn2 = (UIButton *)[_navScrollV viewWithTag:sT + 1];
    float value2 = MIN_MENU_FONT + percent * (MAX_MENU_FONT - MIN_MENU_FONT);
    btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
    [self changeColorForButton:btn2 red:percent];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startPointX = scrollView.contentOffset.x;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xx = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [_navScrollV scrollRectToVisible:CGRectMake(xx, 0, _navScrollV.frame.size.width, _navScrollV.frame.size.height) animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"newsCell";
    WangQiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WangQiCell" owner:self options:0] lastObject];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
