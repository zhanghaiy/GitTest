//
//  HeaderFile.h
//  labonline
//
//  Created by cocim01 on 15/3/25.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#ifndef labonline_HeaderFile_h
#define labonline_HeaderFile_h

#import "DeviceManager.h"
#import "NavigationButton.h"

#define kScreenWidth  [DeviceManager currentScreenWidth]
#define kScreenHeight  [DeviceManager currentScreenHeight]

typedef enum
{
    MainPage = 0,
    JiShuZhuanLan,
    WangQi,
    PersonCenter,
    SettingCenter,
    LogIn,
    Register
}ResourceType;

// 我的收藏接口 参数 userid
#define kMyCollectionUrlString @"http://192.168.0.153:8181/labonline/hyController/queryWdscList.do"
#define kUserId @"529EEF8D5991473488DB877F100B2A01"
#define kJSZLUrlString @"http://192.168.0.153:8181/labonline/indexController/queryJszlList.do"

// 主页接口 无参数
#define kMainUrlString @"http://192.168.0.153:8181/labonline/indexController/queryList.do"

#define kOneFontSize 13
#define kTwoFontSize 12
#define kThreeFontSize 11
#define kFourFontSize 10

#endif
