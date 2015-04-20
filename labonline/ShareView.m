//
//  ShareView.m
//  labonline
//
//  Created by cocim01 on 15/4/9.
//  Copyright (c) 2015年 科希盟. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView{

    TencentOAuth *tencentAuth;
}

- (void)awakeFromNib
{
    [WXApi registerApp:@"wxe0742138717ee3fe"];
    tencentAuth = [[TencentOAuth alloc] initWithAppId:@"1104472845" andDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked:)];
    [self addGestureRecognizer:tap];
}

- (void)tapClicked:(id) sender
{
    [self removeFromSuperview];
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:sender afterDelay:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)QQButtonClicked:(id)sender
{
    // QQ
    NSString *url = _shareUrl;
    //分享图预览图URL地址
    NSString *previewImageUrl = @"wangqi.png";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title: _shareTitle
                                description:@"description"
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self tapClicked:sender];
}

- (IBAction)QzoneButtonClicked:(id)sender
{
    // Qzone 空间
    NSString *url = _shareUrl;
    //分享图预览图URL地址
    NSString *previewImageUrl = @"wangqi.png";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:url]
                                title: _shareTitle
                                description:@"description"
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //    将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    //    [self.tencentAuth logout:self];登出
    [self tapClicked:sender];
}

- (IBAction)WeChatButtonClicked:(id)sender
{
    // 微信
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _shareTitle;
    message.description = @"bbbbbbbb";
    [message setThumbImage:[UIImage imageNamed:@"wangqi.png"]];

    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _shareUrl;

    message.mediaObject = ext;

    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    [self tapClicked:sender];
}
- (IBAction)momentsButtonClicked:(id)sender
{
    // 朋友圈
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _shareTitle;
    message.description = @"bbbbbbbb";
    [message setThumbImage:[UIImage imageNamed:@"wangqi.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _shareUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    [self tapClicked:sender];
}

- (IBAction)EMailButtonClicked:(id)sender
{
    // 邮箱
    
    [self tapClicked:sender];
}

- (IBAction)SinaWebButtonClicked:(id)sender
{
    // 新浪微博
    [self tapClicked:sender];
}

#pragma mark 微信所用
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark 微信所用
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}


-(void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
