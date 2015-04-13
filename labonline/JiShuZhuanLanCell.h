//
//  JiShuZhuanLanCell.h
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiShuZhuanLanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
- (IBAction)moreButtonClicked:(id)sender;

@property (nonatomic,strong) NSDictionary *articleDict;
@property (nonatomic,assign) NSInteger currentArticalIndex;
@property (nonatomic,assign) NSInteger dataIndex;
@property (nonatomic) id target;
@property (nonatomic) SEL buttonClickSelector;
@property (nonatomic) SEL jszlViewClickedAction;

@end
