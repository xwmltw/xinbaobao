//
//  GJJAPPMacro.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/10/31.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#ifndef GJJAPPMacro_h
#define GJJAPPMacro_h

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//是否为iOS11系统
#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] == 11.0)

#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >=  9.0)

//屏幕宽度
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//屏幕高度
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//系统
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


//是否是6P/7P
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

// 根据屏幕宽度适配宽度,参数a是在iphone 6(即375宽度)情况下的宽
#define AdaptationWidth(a) ceilf(a * (ScreenWidth/375))
// 根据屏幕宽度适配高度,参数a是在iphone 6(即667高度)情况下的高
#define AdaptationHeight(a) ceilf(a * (ScreenHeight/667))

#endif /* GJJAPPMacro_h */

//-------------------DEBUG模式下输出-------------------------
#ifdef DEBUG
//#define MyLog(...)  NSLog(__VA_ARGS__)
#define MyLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define MyLog(...)
#endif
//-------------------DEBUG模式下输出-------------------------

//友盟推送
#define UMENGAppKey @"583bd3128f4a9d6d8c00088e"
#define UMENGAppMasterSecret @"obqbnkwsryihqg5t9muntkoq9ih3iwx6"
//极光推送
#define JPAppKey @"982b47452fe6ce1a7e660670"
/** TalkingData */
#ifdef DEBUG
static NSString *const TalkingData_AppID =   @"";
static NSString *const TD_AdTrackingID =     @"";
#else
static NSString *const TalkingData_AppID =   @"F369AB043BF24C09B1B1D422BC6B35AD";
static NSString *const TD_AdTrackingID =     @"";
#endif
#pragma mark - 宏定义区

/**
 *  尺寸设置宏定义区
 */
#define CCXSCREENSCALE CCXSIZE.width/750.0f //获取当前屏幕尺寸与苹果6S宽度比

#define CCXSIZE [UIScreen mainScreen].bounds.size//获取屏幕SIZE
#define CCXSIZE_W CCXSIZE.width//获取屏幕宽度375
#define CCXSIZE_H CCXSIZE.height//获取屏幕高度667
#define CCXRectMake(x,y,w,h) CGRectMake((x)*CCXSCREENSCALE, (y)*CCXSCREENSCALE, (w)*CCXSCREENSCALE, (h)*CCXSCREENSCALE)
#define XWMSCREENSCALE CCXSIZE.width/375.0f
#define XWMRectMake(x,y,w,h) CGRectMake((x)*XWMSCREENSCALE, (y)*XWMSCREENSCALE, (w)*XWMSCREENSCALE, (h)*XWMSCREENSCALE)
#define CCXSizeMake(w,h) CGSizeMake((w)*CCXSCREENSCALE, (h)*CCXSCREENSCALE)


/**
 *  颜色设置宏定义区
 */
#define CCXCGColorWithHexAndAlpha(hex,alpha) [[UIColor colorWithHexString:hex alpha:alpha] CGcolor];
#define CCXColorWithHexAndAlpha(hex,alpha) [UIColor colorWithHexString:hex alpha:alpha]; //通过16进制和透明度设置颜色
#define CCXCGColorWithHex(hex) [[UIColor colorWithHexString:hex] CGColor];
#define CCXColorWithHex(hex) [UIColor colorWithHexString:hex];//通过16进制设置颜色

#define CCXBackColor CCXColorWithHex(@"#f0eff5")//背景色
#define CCXMainColor CCXColorWithHex(STMainColorString)//主色调
#define GJJNavigationColor CCXColorWithHex(STNaviBarColor)//导航栏

#define GJJMainColorString @"178F95"
#define GJJBlackTextColorString @"3b3a3e"
#define GJJOrangeTextColorString @"feb531"


#define STMainColorString @"178F95"
#define STBGColorString @""
#define STSecondColorString @"FF618E"
#define STFirstWaveColorString @"2887A6"
#define STSecondWaveColorString @"37A3C3"
#define STNaviBarColor @"178F95"
#define STBtnBgColor @"FF618E"
#define STBtnTextColor @"FFFFFF"
#define STGrayTextColorString @"666666"
#define STRedTextColorString @"f90808"
#define STBillStatusColorStringFirst @"#875FA8"
#define STBillStatusColorStringSecond @"#77CB38"
#define STBillStatusColorStringThird @"#18C2F1"
#define STBillStatusColorStringFourth @"#00B9BB"
#define STBillStatusColorStringFifth @"#4C5697"




#define CCXColorWithRBBA(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a)]//通过R,G,B,A设置颜色
#define CCXColorWithRGB(r,g,b)  [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]//通过R,G,B设置颜色

#define CCXSECCSION @"user"//用户信息缓存键名
#define CCXVersion @"0" //通道标识 0:iOS 1:安卓 2:微信 3:PC
#define CCXBannerTimer 2 //banner滚动时间间隔
#define CCXBillType @"billType"//账单类型
#define CCXRecordAudioFile  @"myRecord.wav"
#define CCXSendAudioFile    @"myRecord"
#define CCXUserId @"userId"
#define CCXPhone  @"phoneNum"
#define CCXPassword @"password"

//-------------------DEBUG模式下URL-------------------------
#ifdef DEBUG
#define CCXService @"http://192.168.5.155:8084/rrhcore/queryServiceUrl"//测试环境
#define CCXABOUT @"http://192.168.5.155:8088/xiaoyuedai/about2.html"//关于
#define CCXQUESTION @"http://192.168.5.155:8088/xiaoyuedai/question.html"// 常见问题
#define CCXContract @"http://192.168.5.155:8088/xiaoyuedai/zcxy.html"//注册协议
#else
#define CCXService @"http://app.usdai.com/queryServiceUrl"//正式环境
#define CCXABOUT @"http://zfb.usdai.com/about5.html"//关于
#define CCXQUESTION @"http://zfb.usdai.com/question.html"// 常见问题
#define CCXContract @"http://zfb.usdai.com/zcxy2.html?company=1"//注册协议
#endif


//#define CCXContract @"http://www.yuecaijf.com/zcxy.html"

#define GJJIsNotFirst @"isNotFirst" //是否是第一次打开
#define GJJReadGuide @"readGuide" //是否阅读过引导页
#define GJJIsWorker @"isWorker" //是否是上班族
#define GJJNeedShowGuide @"needShowGuide" //是否需要显示首页蒙版


/** 通知 */
#define WDNotificationCenter [NSNotificationCenter defaultCenter]
#define WDUserDefaults       [NSUserDefaults standardUserDefaults]
/** 单例*/
//#define XSharedInstance(type) + (instancetype)sharedInstance {\
//static type *sharedInstance = nil;\
//static dispatch_once_t once;\
//dispatch_once(&once, ^{\
//sharedInstance = [[self alloc] init];\
//});\
//return sharedInstance;\
//}

#define XSharedInstance(name)\
static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)sharedInstance\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}



/** block self*/

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define XBlockExec(block, ...) if (block) { block(__VA_ARGS__); };
typedef void (^XBlock)(id result);
typedef void (^XIntegerBlock)(NSInteger result);
typedef void (^XBoolBlock)(BOOL bRet);
typedef void (^XDoubleBlock)(id result1, id result2);

/** nib*/
#define nib(a) [UINib nibWithNibName:a bundle:nil]




