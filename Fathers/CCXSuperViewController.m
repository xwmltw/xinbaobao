//
//  CCXSuperViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXSuperViewController.h"
#import "CCXhomePageViewController.h"
#import "CCXLoanViewController.h"
#import "CCXLoanSupermarketViewController.h"
#import "CCXPartTimeJobViewController.h"
#import "WQLogViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import "WQToInteractionViewController.h"
#import "GJJContractWaitView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "SecurityUtil.h"
#import "STMessageCenterController.h"
#import "STLoanController.h"
#import "MyCenterViewController.h"
#import "CalculatorVC.h"
#import "FirstViewController.h"
#import "GJJQueryServiceUrlModel.h"

@interface CCXSuperViewController ()

@end

@implementation CCXSuperViewController

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.automaticallyAdjustsScrollViewInsets = NO;

    
    
    
    
    self.view.backgroundColor = CCXBackColor;
    [self setupControllerNavigation];
    // Do any additional setup after loading the view.
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupControllerNavigation
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:35*CCXSCREENSCALE], NSFontAttributeName, nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#ifdef DEBUG
    UIViewController *viewCtrl = [XControllerViewHelper getTopViewController];
    NSLog(@"栈顶控制器为%@\n当前显示控制器为%@", [viewCtrl class], [self class]);
#endif
    NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
    [TalkingData trackPageBegin:title];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
    [TalkingData trackPageEnd:title];
}
- (NSString *)getUUID {
    NSString *uuidStr = nil;
    NSString *returnStr = nil;
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    uuidStr = [NSString stringWithFormat:@"%@",uuid];
    NSRange endrange = [uuidStr rangeOfString:@">"];
    if (endrange.location != NSNotFound) {
        returnStr = [uuidStr substringWithRange:NSMakeRange(endrange.location+1, [uuidStr length]-endrange.location-1)];
        return returnStr;
    }
        return uuidStr;
}



/**
 *  点击屏幕空白区域，放弃桌面编辑状态
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法
/**
 *   使导航栏透明
 */
-(void)setClearNavigationBar{
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0.0f, 0.0f, CCXSIZE_W, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
//    // 导航栏背景透明度设置
//    UIView *barBackgroundView = [[self.navigationController.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
//    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
//    if (self.navigationController.navigationBar.isTranslucent) {
//        if (backgroundImageView != nil && backgroundImageView.image != nil) {
//            barBackgroundView.alpha = 0;
//        } else {
//            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
//            if (backgroundEffectView != nil) {
//                backgroundEffectView.alpha = 0;
//            }
//        }
//    } else {
//        barBackgroundView.alpha = 0;
//    }
}
/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头"]];
    imageV.frame = CGRectMake(10, 12, 12, 20);
    imageV.userInteractionEnabled = YES;
    [view addSubview:imageV];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 44);
    button.tag = 9999;
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
    UIView *ringhtV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:ringhtV];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button{}

/**创建带点击和标题的ImageView
 *name:表示图片名
 *frame:注意竖直长方形
 *tag:tag
 *title:标题
 */
-(UIView *)CCXTitleImageViewWithTitle:(NSString *)title frame:(CGRect)frame imageName:(NSString *)name url:(NSString *)url tag:(int)tag{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageV = [self CCXImageViewWithImageName:name url:url andFrame:CGRectMake(0, 0, frame.size.width, frame.size.width) tag:tag];
    [view addSubview:imageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height-frame.size.width)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:11];
    [view addSubview:label];
    return view;
}

/**创建带点击事件的imageVIew
 *name:表示图片名
 *frame:正方形
 *tag:tag
 */
-(UIImageView *)CCXImageViewWithImageName:(NSString *)name url:(NSString *)url andFrame:(CGRect)frame tag:(int)tag{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:frame];
    if (url) {
        [imageV setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:name]];
    }else{
        imageV.image = [UIImage imageNamed:name];
    }
    imageV.userInteractionEnabled = YES;
    imageV.clipsToBounds = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = imageV.bounds;
    [button addTarget:self action:@selector(CCXImageClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [imageV addSubview:button];
    return imageV;
}

/** 创建学生版TabBar的类方法创建学生版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setStudentTabBar{
    NSArray *arr = [self setTabBarWithDict:@{@"controller":
                                                 @[[STLoanController new],
                                                   [STMessageCenterController new],
                                                   [MyCenterViewController new]],
                                             @"title":@[@"首页",@"公告",@"我的"],
                                             @"imgName":@[@"tabBar01",@"tabBar03",@"tabBar02"]
                                             }];
    
    return arr;
}

/** 创建学生版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
+(NSArray *)setStudentTabBar{
    CCXSuperViewController *superVC = [CCXSuperViewController new];
    return [superVC setStudentTabBar];
}

/** 创建成人版TabBar的类方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setAdultTabBar{
    
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (OnOff) {
        NSArray *arr = [self setTabBarWithDict:@{@"controller":
                                                     @[[STLoanController new],
                                                       [STMessageCenterController new],
                                                       [MyCenterViewController new]],
                                                 @"title":@[@"借款",@"公告",@"我的"],
                                                 @"imgName":@[@"tab_loan",@"tab_message",@"tab_mines"]
                                                 }];
        return arr;
    }else {
        NSArray *arr = [self setTabBarWithDict:@{@"controller":
                                                     @[[FirstViewController new],
                                                       [CalculatorVC new],
                                                       [STMessageCenterController new],
                                                       [MyCenterViewController new]],
                                                 @"title":@[@"资讯",@"贷款计算器",@"公告",@"我的"],
                                                 @"imgName":@[@"tab_loan",@"tab_message",@"tab_message",@"tab_mines"]
                                                 }];
        return arr;
    }
    
    return nil;
}

/** 创建成人版TabBar的对象方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
+(NSArray *)setAdultTabBar{
    CCXSuperViewController *superVC = [CCXSuperViewController new];
    return [superVC setAdultTabBar];
}

/** 设置TabBar的item相关信息
 *  dict 是一个字典，包含 controller(控制器集合数组) title(item标题集合数组) imgName(item图标名集合数组)  3个对象
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setTabBarWithDict:(NSDictionary *)dict{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i=0; i<[dict[@"controller"] count]; i++) {
        [arr addObject:[[UINavigationController alloc]initWithRootViewController:dict[@"controller"][i]]];
    }
    for (int i=0; i<[dict[@"title"] count]; i++) {
        UIViewController *VC = dict[@"controller"][i];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:dict[@"title"][i] image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",dict[@"imgName"][i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",dict[@"imgName"][i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:CCXColorWithRBBA(34, 58, 80, 0.8)} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:CCXColorWithRGB(78, 142 , 220)} forState:UIControlStateSelected];
        VC.tabBarItem = item;
    }
    
    return arr;
}

/**
 网络请求数据的处理,供子类调用
 
 @param count 标示数据请求的
 */
-(void)prepareDataWithCount:(int)count{
    self.requestCount = count;
    [self setRequestParams];
    [self prepareDataGetUrlWithString:self.cmd andparmeter:self.dict];
}

/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams{}


/**  网络请求成功之后调用,子类重写
 *   object 是网络请求的结果
 */
-(void)getDataSourceWithObject:(id)object {
    NSString *result = [NSString stringWithFormat:@"%@",object[@"result"]];
    if (![result intValue]) {
        [self requestSuccessWithDictionary:object[@"detail"]];
    }else{
        [self requestFaildWithDictionary:object];
    }
}

/**
 网络操作成功
 
 @param dict 成功之后的数据
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{}

/**
 网络操作失败
 
 @param dict 失败之后的数据
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [self setHudWithName:dict[@"resultNote"] Time:1 andType:1];
}

#pragma mark -- 网络请求
/**  网络请求
 *   string:表示请求的cmd dict:表示请求的参数
 */
-(void)prepareDataGetUrlWithString:(NSString *)string andparmeter:(NSDictionary *)dict{
    MBProgressHUD *hud = nil;
    GJJContractWaitView *waitView = nil;
    if (self.requestCount != 100) {

        if ([string isEqualToString:GJJSignContacts]) {
            waitView = [[GJJContractWaitView alloc]initWithTitle:@"提示" waitImageNamed:@"contractWait" content:@"合同生成中，请稍等..."];
            [waitView showContractWaitView];
        } else  {
            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.detailsLabel.text = @"加载中...";
        }
    }
    CCXUser *user = [self getSeccsion];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.cmd forKey:@"cmd"];
    [params setObject:CCXVersion forKey:@"version"];
    
    if ([self.cmd isEqualToString:WQLogin] || [self.cmd isEqualToString:WQFastLogin] || [self.cmd isEqualToString:WQUpdatePassword]) {
        [params setObject:@"" forKey:@"token"];

        [params setObject:@"" forKey:@"uuid"];
    }else{
        [params setObject:user.token?user.token:@"" forKey:@"token"];
        NSString *uuidString = user.uuid?user.uuid:@"";
        [params setObject:uuidString forKey:@"uuid"];
    }
  
    
    //替换userId的值
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (dictionary[@"userId"] && ![dictionary[@"userId"] isEqualToString:@""] && ![dictionary[@"userId"] isEqualToString:@"-100"]) {
        [dictionary setObject:user.uuid forKey:@"userId"];
    }
    
    if ([dictionary[@"userId"] isEqualToString:@""]) {
        [dictionary setObject:@"-100" forKey:@"userId"];
    }
   
    [params setObject:dictionary forKey:@"params"];
//    MyLog(@"paras-->%@",params);
    
    //如果没有登录，则uuid为空
//    if ([user.userId isEqualToString:@"-100"]) {
//        [params setObject:@"" forKey:@"uuid"];
//    }else{
//        NSString *uuidString = [NSString stringWithFormat:@"%@%@",user.userId,user.phone];
//        MyLog(@"string-->%@",uuidString);
//        NSString *md5UuidString = [SecurityUtil MD5ForLower16Bate:uuidString];
//        MyLog(@"md5String-->%@",md5UuidString);
//        [params setObject:md5UuidString forKey:@"uuid"];
//        
//    }
    
    //位异或加密后string
    NSString *changeString = [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:params]];
    
//    NSString *changeString = [SecurityUtil encodeYiData:base64String];
    
    NSDictionary *secretDict = @{@"key":changeString};
//    NSDictionary *secretDict = @{@"key" : [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:params]]};
    
    [HYBNetworking postWithUrl:[NSString stringWithFormat:@"%@%@",CCXSERVR,string] refreshCache:YES params:secretDict success:^(id response) {
        if (hud) {
            [hud hideAnimated:YES];
        }else {
            [waitView closeContractWaitView];
        }
        [self.tableV.mj_footer endRefreshing];
        [self.tableV.mj_header endRefreshing];
        
        NSDictionary *keyDict = [SecurityUtil dictionaryWithJsonString:[SecurityUtil decryptAESData:response[@"key"]]];
        
//        NSDictionary *keyDict = [SecurityUtil dictionaryWithJsonString:[SecurityUtil decryptAESData:response[@"key"]]];
//        MyLog(@"keyDict-->%@", keyDict);
        NSString *resultString = [NSString stringWithFormat:@"%@", keyDict[@"result"]];
        if ([resultString isEqualToString:@"-1"]) {
//            [self clearSeccsion];//此时清空用户信息的话可能会有问题
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:keyDict[@"resultNote"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                WQLogViewController *loginVC = [WQLogViewController new];
                loginVC.hidesBottomBarWhenPushed = YES;
                loginVC.title = @"登录";
                loginVC.popViewController = self;
                [self.navigationController pushViewController:loginVC animated:YES];
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        [self getDataSourceWithObject:keyDict];
//        [self getDataSourceWithObject:response];
    } fail:^(NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }else {
            [waitView closeContractWaitView];
        }
        [self.tableV.mj_header endRefreshing];
        [self.tableV.mj_footer endRefreshing];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self prepareDataWithCount:self.requestCount];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type{
    //记录当前的self.navigationController.view，当回到主线程且页面消失，当前的self.navigationController.view可能会消失
    UIView *superView = self.navigationController.view;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.delegate = self;
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = name;
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [hud hideAnimated:YES afterDelay:time];
    });
}

#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}

/** MD5加密(16位大写)
 *  input:需要加密的字符串
 *  出  参:加密之后的字符串
 */
- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    return  output;
}

/**
 *  当某个对象不存在时,返回空值
 */
+(id)getValueWithkey:(id)key{
    if (key) {
        return key;
    }
    return nil;
}

/**
 *  返回数组的长度,数组不存在则返回0
 */
+(NSInteger )getNumerOfArray:(NSArray *)arr{
    if (arr) {
        return arr.count;
    }
    return 0;
}

/**计算未来某一时刻到当前时间的时间差
 *time:表示未来某一时刻
 *dateFormatter:时间格式(ag:yyyy-MM-dd hh:mm:ss.SS)
 */
+(NSString *)getRestTimeWithString:(NSString *)time dataFormat:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = dateFormatter;
    NSDate *date = [formatter dateFromString:time];
    NSDate *newDate = [NSDate date];
    int s = [date timeIntervalSinceDate:newDate];
    int h = s/3600;
    int m = s%3600/60;
    s = s%60;
    return  [NSString stringWithFormat:@"剩余:%.2d:%.2d:%.2d",h,m,s];
}

#pragma mark -- seccsion

/** 保存用户信息类方法
 *  user:用户对象
 */
-(void)saveSeccionWithUser:(CCXUser *)user{
    if ([NSKeyedArchiver archivedDataWithRootObject:user]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:CCXSECCSION];
        [userDefaults synchronize];
    }
}

/** 保存用户信息对象方法
 *  user:用户对象
 */
+(void)saveSeccionWithUser:(CCXUser *)user{
    [self saveSeccionWithUser:user];
}

/**
 *  获取用户信息类方法
 */
-(CCXUser *)getSeccsion{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CCXSECCSION];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    CCXUser *user = [[CCXUser alloc]initWithDictionary:@{@"name":APPDEFAULTNAME,@"phone":@"请登录",@"password":@"",@"userId":@"-100",@"customName":APPDEFAULTNAME,@"uuid":@"",@"token":@""}];
    return user;
}

/**
 清空seccsion
 */
-(void)clearSeccsion{
    CCXUser *user = [[CCXUser alloc]initWithDictionary:@{@"name":APPDEFAULTNAME,@"phone":@"请登录",@"customName":APPDEFAULTNAME,@"password":@"",@"userId":@"-100",@"uuid":@"",@"token":@""}];
    [self saveSeccionWithUser:user];
}

/**
 *  获取用户信息类方法
 */
+(CCXUser *)getSeccsion{
    return [self getSeccsion];
}

#pragma mark -- tableView

/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame{
    self.tableV = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableV.backgroundColor = CCXColorWithRGB(253, 253, 254);
    self.tableV.showsVerticalScrollIndicator = NO;
    self.tableV.showsHorizontalScrollIndicator = NO;
    /***
     在iOS11中如果不实现 -tableView: viewForHeaderInSection:和-tableView: viewForFooterInSection: ，则-tableView: heightForHeaderInSection:和- tableView: heightForFooterInSection:不会被调用，导致它们都变成了默认高度，这是因为tableView在iOS11默认使用Self-Sizing，tableView的estimatedRowHeight、estimatedSectionHeaderHeight、 estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension,就是实现对应方法或把这三个属性设为0。
     ***/
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedRowHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    _tableV.mj_header = header;
    
    _tableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _tableV.mj_footer.hidden = YES;
    [self.view addSubview:self.tableV];
}

/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh{
}

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh{
}

/**
 *  返回分区数目(默认为1)
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 *  返回每个分区的个数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 手势区

-(void)setTapGuestureWithView:(UIView *)view andTapNumber:(int)tapNumber{
    UITapGestureRecognizer *tapGue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuesture:)];
    tapGue.numberOfTapsRequired = tapNumber;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGue];
}

#pragma mark - 懒加载方法

/**
 初始化一个View
 
 @return tableView的头View
 */
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}

/**
 数据数组的全局变量
 
 @return 数据数组
 */
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
}

/**
 detail数据初始化
 
 @return detail字典对象
 */
-(NSDictionary *)detailDict{
    if (!_detailDict) {
        _detailDict = [NSDictionary new];
    }
    return _detailDict;
}

#pragma mark - UI事件方法

/** 点击手势的点击事件
 *  通过 guesture.view 获取点击手势添加的视图
 */
-(void)tapGuesture:(UITapGestureRecognizer *)guesture{}

/** 可点图片的点击事件
 *  入参是图片上可点的button
 */
-(void)CCXImageClick:(UIButton *)button{}


- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
}

- (void)showTabBar{
    if (self.tabBarController.tabBar.hidden == NO)return;
    self.tabBarController.tabBar.hidden = NO;
}

@end

#pragma mark -- 跳转页面时候的效果动画
@implementation UIView (CCXTransitionAnimation)

- (void)setTransitionAnimationType:(CCXTransitionAnimationType)transtionAnimationType toward:(CCXTransitionAnimationToward)transitionAnimationToward duration:(NSTimeInterval)duration{
    CATransition * transition = [CATransition animation];
    transition.duration = duration;
    NSArray * animations = @[@"cameraIris",
                             @"cube",
                             @"fade",
                             @"moveIn",
                             @"oglFilp",
                             @"pageCurl",
                             @"pageUnCurl",
                             @"push",
                             @"reveal",
                             @"rippleEffect",
                             @"suckEffect"];
    NSArray * subTypes = @[@"fromLeft",
                           @"fromRight",
                           @"fromTop",
                           @"fromBottom"];
    transition.type = animations[transtionAnimationType];
    transition.subtype = subTypes[transitionAnimationToward];
    [self.layer addAnimation:transition forKey:nil];
}

@end
