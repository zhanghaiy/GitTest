//
//  MainCell.h
//  labonline
//
//  Created by cocim01 on 15/3/26.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainCellDelegate <NSObject>

- (void)imageButtonClicked:(UIButton *)btn withDataArray:(NSArray *)array;

@end

@interface MainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *magazineImageButton;
@property (weak, nonatomic) IBOutlet UILabel *formLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UIButton *topNewButton;

@property (nonatomic,assign) id<MainCellDelegate> delegate;
@property (nonatomic,assign) SEL action;
- (IBAction)toWanQi:(id)sender;

@end
