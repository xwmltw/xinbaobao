//
//  WQInteractionDetailViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2017/1/12.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "WQRollingPictureViewController.h"
#import "WQLogViewController.h"
#import <UShareUI/UShareUI.h>
#import "WQPicAnnounce.h"
#import "GJJShareModel.h"

typedef NS_ENUM(NSInteger, WQRollingPictureRequest) {
    WQRollingPictureRequestShare,
};


@interface WQRollingPictureViewController ()

@end

@implementation WQRollingPictureViewController
{
    GJJShareModel *_getSahreModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = @"";
    if ([[self getSeccsion].userId integerValue] == -100) {
        urlString = self.url;
    }else {
        urlString = [NSString stringWithFormat:@"%@?%@", self.url, [self getSeccsion].userId];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    if (self.requestCount == WQRollingPictureRequestShare) {
        self.cmd = GJJQueryShareContent;
        self.dict = @{@"messageId":_model.messageId};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    MyLog(@"+++++++++++++++++%@",dict);
    if (self.requestCount == WQRollingPictureRequestShare) {
        NSLog(@"%@", dict);
        _getSahreModel = [GJJShareModel yy_modelWithDictionary:dict];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            [self shareTextToPlatformType:platformType];
        }];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
}

- (void)setupView
{
    if ([_model.shareStatus isEqualToString:@"1"]) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(0, 0, 40, 25);
        [shareButton setImage:[UIImage imageNamed:@"shareImage"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    }
}

- (void)shareClick
{
    if ([[self getSeccsion].userId intValue] == -100) {
        [self pushToLoin];
        return;
    }
    [self prepareDataWithCount:WQRollingPictureRequestShare];
}

- (void)pushToLoin
{
    WQLogViewController *loginVC = [WQLogViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.title = @"登录";
    loginVC.popViewController = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString *HDString = @"HD_";
    NSString *phoneString = [self getSeccsion].phone;
    NSString *messageId = [NSString stringWithFormat:@"$%@", _model.messageId];
    NSString *iOSPlatform = @"+0";
    NSString *paltType = @"";
    if (platformType == UMSocialPlatformType_Sina) {
        paltType = @"*WB";
    }else if (platformType == UMSocialPlatformType_WechatSession) {
        paltType = @"*WX";
    }else if (platformType == UMSocialPlatformType_WechatTimeLine) {
        paltType = @"*PYQ";
    }else if (platformType == UMSocialPlatformType_QQ) {
        paltType = @"*QQ";
    }else if (platformType == UMSocialPlatformType_Qzone) {
        paltType = @"*KJ";
    }
    
    NSString* shareURL = [NSString stringWithFormat:@"%@?%@%@%@%@%@", _getSahreModel.shareUrl, HDString, phoneString, messageId, iOSPlatform, paltType];
    NSLog(@"%@", shareURL);
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_getSahreModel.title descr:_getSahreModel.content thumImage:_getSahreModel.littlePicUrl];
    //设置网页地址
    shareObject.webpageUrl = shareURL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            switch (error.code) {
                case 2000:
                    [self setHudWithName:@"未知错误" Time:1 andType:1];
                    break;
                case 2001:
                    [self setHudWithName:@"不支持" Time:1 andType:1];
                    break;
                case 2002:
                    [self setHudWithName:@"授权失败" Time:1 andType:1];
                    break;
                case 2003:
                    [self setHudWithName:@"分享失败" Time:1 andType:1];
                    break;
                case 2004:
                    [self setHudWithName:@"请求用户信息失败" Time:1 andType:1];
                    break;
                case 2005:
                    [self setHudWithName:@"分享内容为空" Time:1 andType:1];
                    break;
                case 2006:
                    [self setHudWithName:@"分享内容不支持" Time:1 andType:1];
                    break;
                case 2007:
                    [self setHudWithName:@"schemaurl fail" Time:1 andType:1];
                    break;
                case 2008:
                    [self setHudWithName:@"应用未安装" Time:1 andType:1];
                    break;
                case 2009:
                    [self setHudWithName:@"取消分享" Time:1 andType:1];
                    break;
                case 2010:
                    [self setHudWithName:@"网络异常" Time:1 andType:1];
                    break;
                case 2011:
                    [self setHudWithName:@"第三方错误" Time:1 andType:1];
                    break;
                default:
                    break;
            }
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                [self setHudWithName:@"分享成功" Time:1 andType:0];
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
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
