//
//  SettingCell.m
//  labonline
//
//  Created by cocim01 on 15/4/7.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    [self fillTheData];
}

- (void)setCellIndex:(NSInteger)cellIndex
{
    _cellIndex = cellIndex;
    if (_cellIndex < 2)
    {
        _onOrOffSwich.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        _onOrOffSwich.hidden = YES;
        if (_cellIndex >= 5)
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
}

- (void)fillTheData
{
    _subImageView.image = [UIImage imageNamed:[_dataDict objectForKey:@"ImageName"]];
    _textLable.text = [_dataDict objectForKey:@"TEXT"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onOrOffSwitchValueChanged:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    if (mySwitch.on)
    {
        // 开
    }
    else
    {
        // 关
    }
}

@end
