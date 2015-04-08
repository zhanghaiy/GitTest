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
    SettingCenter
}ResourceType;

#define kOneFontSize 13
#define kTwoFontSize 12
#define kThreeFontSize 11
#define kFourFontSize 10

#endif
