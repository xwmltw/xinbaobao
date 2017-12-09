//
//  AppDelegate.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "AppDelegate.h"
#import "CCXSuperViewController.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "GJJGuideViewController.h"
#import "GJJServiceURLViewController.h"
#import "CCXHelpViewController.h"
//#import "UMMobClick/MobClick.h"
#import "XControllerViewHelper.h"

////友盟推送
//#import "UMessage.h"
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
//#import <UserNotifications/UserNotifications.h>
//#endif
////友盟分享
//#import <UMSocialCore/UMSocialCore.h>

//极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()
<GJJGuideViewControllerDelegate,
GJJServiceURLViewControllerDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>


#define XJDAPP_PLATFORM @"AppStore"
@property(nonatomic,strong)UITabBarController *tabVC;//导航栏控制器

@end

@implementation AppDelegate

#pragma mark - 私有方法
/**
 *  懒加载UITabBarController
 */
-(UITabBarController *)tabVC{
    if (!_tabVC) {
        _tabVC = [[UITabBarController alloc]init];
        _tabVC.tabBar.barStyle = UIBarStyleBlack;//设置tabBar类型（也就是颜色 黑，白）
        _tabVC.tabBar.translucent = NO;//设置tabBar的半透明度
        _tabVC.tabBar.backgroundImage = [UIImage imageNamed:@"tabBar_back"];
    }
    return _tabVC;
}

#pragma mark - app周期函数方法

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

//    UMConfigInstance.appKey = @"599d17ef6e27a4370d00066c";
//    UMConfigInstance.channelId = @"App Store";
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPAppKey
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    GJJServiceURLViewController *controller = [[GJJServiceURLViewController alloc]init];
    controller.delegate = self;
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    [self addNotification];
    [self configIQKeyboard];
    [self configNetworking];
//    [self configUMengPushWithOptions:launchOptions];
//    [self configShare];
    [self addTalkingData];
    
    
    return YES;
}

#pragma mark - TalkingData
- (void)addTalkingData{
    
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:TalkingData_AppID withChannelId:XJDAPP_PLATFORM];
//    [TalkingDataAppCpa init:TD_AdTrackingID withChannelId:XJDAPP_PLATFORM];
    
    
}

#pragma mark - NSNotificationCenter
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeAdImageH5:) name:GJJCloseADImageH5 object:nil];
}

- (void)closeAdImageH5:(NSNotification *)sender
{
    [self doNotForceUpdate];
}

#pragma mark - GJJServiceURLViewController.h
- (void)doNotForceUpdate
{
    
    self.tabVC.viewControllers = [[CCXSuperViewController new] setAdultTabBar];
    [self changeWindowRootViewController:self.tabVC];

}

- (void)changeWindowRootViewController:(UIViewController *)controller
{
    // 渐隐动画
//    CATransition *animation = [CATransition animation];
//    [animation setDuration:1.0f];
//    [animation setType:kCATransitionFade];
//    [animation setFillMode:kCAFillModeForwards];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [self.window.layer addAnimation:animation forKey:@"window"];
    
    self.window.rootViewController = controller;
    
//    [self.window.layer removeAnimationForKey:@"window"];
}

#pragma mark - GuideViewControllerDelegate
-(void)guideDidFinished:(GJJGuideViewController *)guideView{
    if([[NSUserDefaults standardUserDefaults] boolForKey:GJJIsWorker]){
        self.tabVC.viewControllers = [[CCXSuperViewController new] setAdultTabBar];
        [self changeWindowRootViewController:self.tabVC];
    }else{
        self.tabVC.viewControllers = [[CCXSuperViewController new] setStudentTabBar];
        [self changeWindowRootViewController:self.tabVC];
    }
}

/**
 *  支付宝返回字段解析
 *
 *  @param AllString            字段
 *  @param FirstSeparateString  第一个分离字段的词
 *  @param SecondSeparateString 第二个分离字段的词
 *
 *  @return 返回字典
 */
-(NSMutableDictionary *)setComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        
    }
    
    return dic;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
////    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
//            if (orderState==9000) {
//                NSString *allString=resultDic[@"result"];
//                NSString * FirstSeparateString=@"\"&";
//                NSString *  SecondSeparateString=@"=\"";
//                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
//                NSLog(@"ali=%@",dic);
//                if ([dic[@"success"]isEqualToString:@"true"]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
//                }
//            }else{
//                NSString *returnStr;
//                switch (orderState) {
//                    case 8000:returnStr=@"订单正在处理中";break;
//                    case 4000:returnStr=@"订单支付失败";break;
//                    case 6001:returnStr=@"订单取消";break;
//                    case 6002:returnStr=@"网络连接出错";break;
//                    default:break;
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
//            }
//        }];
//        return YES;
//    }else {
//
//    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
//            if (orderState==9000) {
//                NSString *allString=resultDic[@"result"];
//                NSString * FirstSeparateString=@"\"&";
//                NSString *  SecondSeparateString=@"=\"";
//                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
//                NSLog(@"ali=%@",dic);
//                if ([dic[@"success"]isEqualToString:@"true"]) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
//                }
//            }else{
//                NSString *returnStr;
//                switch (orderState) {
//                    case 8000:returnStr=@"订单正在处理中";break;
//                    case 4000:returnStr=@"订单支付失败";break;
//                    case 6001:returnStr=@"订单取消";break;
//                    case 6002:returnStr=@"网络连接出错";break;
//                    default:break;
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
//            }
//        }];
//        return YES;
//    }
    return YES;
}

#pragma mark - 设置键盘
- (void)configIQKeyboard
{
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark - 设置网络请求
- (void)configNetworking
{
    //开启接口打印信息
    [HYBNetworking enableInterfaceDebug:YES];
    [HYBNetworking configRequestType:kHYBRequestTypeJSON
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
}

#pragma mark - 设置友盟推送
//- (void)configUMengPushWithOptions:(NSDictionary *)launchOptions
//{
//    //设置 AppKey 及 LaunchOptions
//    [UMessage startWithAppkey:UMENGAppKey launchOptions:launchOptions];
//    //注册通知
//    [UMessage registerForRemoteNotifications];
//    //iOS10必须加下面这段代码。
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate=self;
//    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//            //点击允许
//
//        } else {
//            //点击不允许
//
//        }
//    }];
//
//    [UMessage setLogEnabled:YES];
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
//1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    

    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
                                                            message:@"Test On ApplicationStateActive"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];

        [alertView show];

    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];

    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];

    }else{
        //应用处于后台时的本地推送接受
    }

}

#pragma mark - 分享
//- (void)configShare
//{
//    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
//    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
//    //设置友盟appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENGAppKey];
//
//    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:GJJUMengWXAPPID appSecret:GJJUMengWXAppSecret redirectURL:@"http://www.mochoupay.com"];
//
//    //设置分享到QQ互联的appKey和appSecret
//    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:GJJUMengTXAPPID  appSecret:nil redirectURL:@"http://www.mochoupay.com"];
//
//    //设置新浪的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:GJJUmengWBAPPKEY  appSecret:GJJUmengWBAppSecret redirectURL:@"http://www.mochoupay.com"];
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    BOOL result = [[JPUSHService defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
    return YES;
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
