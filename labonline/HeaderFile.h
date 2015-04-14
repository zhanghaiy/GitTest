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


#define kUserId @"529EEF8D5991473488DB877F100B2A01"
// 技术专栏主页
#define kJSZLUrlString @"http://192.168.0.153:8181/labonline/indexController/queryJszlList.do"
// 技术专栏更多
#define kJSZLMoreUrlString @"http://192.168.0.153:8181/labonline/zzwzController/queryJszlwzList.do?type_id=%@"

// 主页接口 无参数
#define kMainUrlString @"http://192.168.0.153:8181/labonline/indexController/queryList.do"
// 主页杂志的阅读接口 左侧杂志接口
#define kMainListUrlString @"http://192.168.0.153:8181/labonline/zzwzController/queryList.do"
// 评论界面接口 9185
#define kEvalueationURLString @"http://192.168.0.153:8181/labonline/hyController/queryWzplList.do?articleid=%@"
// 提交评论接口 articleid userid text
#define kCommitEvaluationUrl @"http://192.168.0.153:8181/labonline/hyController/insertPl.do"
// 收藏接口 参数userid  articleid
#define kCollectionUrl @"http://192.168.0.153:8181/labonline/hyController/insertWdsc.do"
// 我的收藏接口 参数 userid
#define kMyCollectionUrlString @"http://192.168.0.153:8181/labonline/hyController/queryWdscList.do"

#define kOneFontSize 13
#define kTwoFontSize 12
#define kThreeFontSize 11
#define kFourFontSize 10

#endif
