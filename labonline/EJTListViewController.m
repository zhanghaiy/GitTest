//
//  EJTListViewController.m
//  labonline
//
//  Created by cocim01 on 15/4/28.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "EJTListViewController.h"
#import "MenuButton.h"


@interface EJTListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_firstMenuArray;
    NSMutableArray *_subArray;
    NSMutableArray *_subSubArray;
    
    NSArray *_mainArray;
    NSArray *_pXrray;
    
    NSInteger _currentType;
    
    UITableView *_smallTabV;
    UITableView *_leftTabV;
    UITableView *_rightTabV;
    UITableView *_mainTabV;
    
    BOOL _paiXu;
}
@end

@implementation EJTListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _titleString;
    self.view.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1];
    
    _currentType = _type;
    _paiXu = NO;
    
    MenuButton *leftBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 100;
    [leftBtn setFrame:CGRectMake(0, 64, kScreenWidth/3, 30)];
    [leftBtn setTitle:_titleString forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    MenuButton *middleBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    middleBtn.tag = 100+1;
    [middleBtn setFrame:CGRectMake(kScreenWidth/3, 64, kScreenWidth/3, 30)];
    [middleBtn setTitle:@"产品分类" forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:middleBtn];
    
    MenuButton *rigBtn = [MenuButton buttonWithType:UIButtonTypeCustom];
    rigBtn.tag = 100+2;
    [rigBtn setFrame:CGRectMake(kScreenWidth*2/3, 64, kScreenWidth/3, 30)];
    [rigBtn setTitle:@"排序" forState:UIControlStateNormal];
    [rigBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rigBtn];
    
    _mainArray = @[@"12.jpg",@"33.png",@"12.jpg",@"33.png"];
    
    
    _leftTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth/2, kScreenHeight-94) style:UITableViewStylePlain];
    _leftTabV.delegate = self;
    _leftTabV.dataSource = self;
    _leftTabV.tag = 11;
    [self.view addSubview:_leftTabV];
    
    _rightTabV = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 94, kScreenWidth/2, kScreenHeight-94) style:UITableViewStylePlain];
    _rightTabV.delegate = self;
    _rightTabV.dataSource = self;
    _rightTabV.tag = 12;
    [self.view addSubview:_rightTabV];
    
    _smallTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth/3, kScreenHeight-94) style:UITableViewStylePlain];
    _smallTabV.delegate = self;
    _smallTabV.dataSource = self;
    _smallTabV.tag = 13;
    [self.view addSubview:_smallTabV];
    
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    _smallTabV.hidden = YES;
    _leftTabV.backgroundColor = [UIColor clearColor];
    _rightTabV.backgroundColor = [UIColor clearColor];
    _smallTabV.backgroundColor = [UIColor clearColor];
    
    _mainTabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth, kScreenHeight-94) style:UITableViewStylePlain];
    _mainTabV.delegate = self;
    _mainTabV.dataSource = self;
    _mainTabV.tag = 14;
    [self.view addSubview:_mainTabV];
    
    [self localJson];
    _pXrray = @[@"时间",@"其他"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 11)
    {
        // left
        return _subArray.count;
    }
    else if (tableView.tag == 12)
    {
        return _subSubArray.count;
    }
    else if (tableView.tag == 13)
    {
        if (_paiXu)
        {
            return _pXrray.count;
        }
        else
        {
            return _firstMenuArray.count;
        }
    }
    else if (tableView.tag == 14)
    {
        return _mainArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 14)
    {
        return 100;
    }
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    switch (tableView.tag)
    {
        case 11:
        {
            cell.textLabel.text = [[_subArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
            break;
        case 12:
        {
            NSLog(@"%@",[_subSubArray objectAtIndex:0]);
            cell.textLabel.text = [_subSubArray objectAtIndex:indexPath.row];
        }
            break;
        case 13:
        {
            if (_paiXu)
            {
                cell.textLabel.text = [_pXrray objectAtIndex:indexPath.row];
            }
            else
            {
                cell.textLabel.text = [[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            }
        }
            break;
        case 14:
        {
            cell.imageView.image = [UIImage imageNamed:@"12.jpg"];
        }
            break;
        default:
            break;
    }
    
    // 选中后背景色
    if (tableView.tag != 14)
    {
        cell.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:148/255.0 green:191/255.0 blue:196/255.0 alpha:0.7];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag)
    {
        case 11:
        {
            _subSubArray = [[_subArray objectAtIndex:indexPath.row] objectForKey:@"subsubMenus"];
            NSLog(@"%@",_subArray);
            NSLog(@"%@",_subSubArray);
            [self.view bringSubviewToFront:_rightTabV];
            _rightTabV.hidden = NO;
            [_rightTabV reloadData];
        }
            break;
        case 12:
        {
            // 网络请求
            _leftTabV.hidden = YES;
            _rightTabV.hidden = YES;
            
        }
            break;
        case 13:
        {
            if (_paiXu)
            {
                NSString *titl = [_pXrray objectAtIndex:indexPath.row];
                UIButton *btn = (UIButton *)[self.view viewWithTag:102];
                [btn setTitle:titl forState:UIControlStateNormal];
                _smallTabV.hidden = YES;
            }
            else
            {
                NSString *titl = [[_firstMenuArray objectAtIndex:indexPath.row] objectForKey:@"title"];
                UIButton *btn = (UIButton *)[self.view viewWithTag:100];
                [btn setTitle:titl forState:UIControlStateNormal];
                self.title = titl;
                _currentType = indexPath.row;
                _smallTabV.hidden = YES;
                
            }
        }
            break;
        case 14:
        {
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (void)localJson
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eJianTong" ofType:@"json"]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _firstMenuArray = [dict objectForKey:@"Test"];
    _subArray = [[_firstMenuArray objectAtIndex:0] objectForKey:@"subMenus"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    _smallTabV.hidden = YES;
    _leftTabV.hidden = YES;
    _rightTabV.hidden = YES;
    
}


- (void)buttonClicked:(MenuButton *)btn
{
    switch (btn.tag-100)
    {
        case 0:
        {
            NSLog(@"一级分类");
            [self reloadSmallTableViewWithPaiXu:NO];
            [self makeTableViewAlone:NO];
        }
            break;
        case 1:
        {
            NSLog(@"产品分类");
            [self makeTableViewAlone:YES];
            
            _subArray = [[_firstMenuArray objectAtIndex:_currentType] objectForKey:@"subMenus"];
            _leftTabV.hidden = NO;
            [self.view bringSubviewToFront:_leftTabV];
            [_leftTabV reloadData];
            
        }
            break;
        case 2:
        {
            NSLog(@"排序");
            [self makeTableViewAlone:NO];
            [self reloadSmallTableViewWithPaiXu:YES];
        }
            break;
        default:
            break;
    }
}

- (void)makeTableViewAlone:(BOOL)product
{
    if (product)
    {
        _smallTabV.hidden = YES;
    }
    else
    {
        _leftTabV.hidden = YES;
        _rightTabV.hidden = YES;
    }
}

#pragma mark - 刷新一级分类 或者 排序 列表
- (void)reloadSmallTableViewWithPaiXu:(BOOL)isPx
{
    _paiXu = isPx;
    [self.view bringSubviewToFront:_smallTabV];
    
    CGRect rect = _smallTabV.frame;
    if (isPx)
    {
        rect.origin.x = kScreenWidth*2/3;
    }
    else
    {
        rect.origin.x = 0;
    }
    _smallTabV.frame = rect;
    _smallTabV.hidden = NO;
    [_smallTabV reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
