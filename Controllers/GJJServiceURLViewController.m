//
//  GJJServiceURLViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/10.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJServiceURLViewController.h"
#import "GJJQueryServiceUrlModel.h"
#import "GJJADImageViewController.h"
#import "SecurityUtil.h"
#import "CCXUser.h"
#import "GJJCountDownButton.h"
#import <AdSupport/AdSupport.h>

@interface GJJServiceURLViewController ()
<MBProgressHUDDelegate>

@end

@implementation GJJServiceURLViewController
{
    GJJQueryServiceUrlModel *_urlModel;
    UIImageView *_backgroundImageView;
    UIButton *_passButton;
    NSTimer *_timerCode;
    NSTimer *_timerClose;
    NSInteger _timer;
    GJJCountDownButton *_getVerificationButton;
    NSString *idfaStr;

}
static NSString* const XSJUserDefault_IDFA  = @"XSJUserDefault_IDFA";


- (void)reloadClick
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    [self.view addSubview:_backgroundImageView];
    [self getServiceURL];
}

- (void)isNeedUpdate
{
//    NSString *appStoreString = @"https://itunes.apple.com/us/app/ren-ren-hua-chao-guang-su-ban/id1160195724?l=zh&ls=1&mt=8";
    if ([_urlModel.updateStatus isEqualToString:@"0"]) {
        //没有更新
//        if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
//            [_delegate doNotForceUpdate];
//        }
        [self setCountdownImageView];
    }else if ([_urlModel.updateStatus isEqualToString:@"1"]) {
        //强制更新
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"有重大更新，请更新" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlModel.updateUrl]];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([_urlModel.updateStatus isEqualToString:@"2"]) {
        //不强制更新
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"出新版啦，是否更新？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
//            if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
//                [_delegate doNotForceUpdate];
//            }
            [self setCountdownImageView];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlModel.updateUrl]];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setCountdownImageView
{
    NSArray *dataList = _urlModel.dataList;
    NSDictionary *data = dataList[0];
    NSString *urlString = data[@"url"];
    if (urlString.length > 0) {

        
        _getVerificationButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
//        _getVerificationButton.frame = CCXRectMake(450, 30, 320, 50);
        [_backgroundImageView addSubview:_getVerificationButton];
//        [_getVerificationButton setTitle:@"5s" forState:UIControlStateNormal];
        _getVerificationButton.titleLabel.font = [UIFont systemFontOfSize:32*CCXSCREENSCALE];
        _getVerificationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_getVerificationButton setTitleColor:[UIColor colorWithHexString:STBtnBgColor] forState:UIControlStateNormal];
        _getVerificationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        _getVerificationButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
        //    getVerificationCodeButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
        _getVerificationButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _getVerificationButton.layer.borderWidth = 1;
        _getVerificationButton.layer.cornerRadius = AdaptationHeight(12.5);
        _getVerificationButton.layer.masksToBounds = YES;
    
        //    [getVerificationCodeButton sizeToFit];
        [_getVerificationButton addTarget:self action:@selector(getVerificationClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_getVerificationButton makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_backgroundImageView.top).offset(@30);
                        make.right.equalTo(_backgroundImageView.right).offset(@-20);
                        make.size.equalTo(CGSizeMake(AdaptationWidth(50), AdaptationHeight(25)));
                    }];

        

     
        [_getVerificationButton startCountDownWithSecond:5];
//
        [_getVerificationButton countDownChanging:^NSString *(GJJCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
            return title;
        }];
        [_getVerificationButton countDownFinished:^NSString *(GJJCountDownButton *countDownButton, NSUInteger second) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
                [_delegate doNotForceUpdate];
            }

            return nil;
        }];

        
        UITapGestureRecognizer *adImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapADImage:)];
        [_backgroundImageView addGestureRecognizer:adImageTap];
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
            [_delegate doNotForceUpdate];
        }
    }
}

#pragma  mark -网络请求
-(void)setRequestParams{
    self.cmd = XWMIdfa;
    idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    self.dict = @{@"system":[XDeviceHelper getSysVersionString],
                  @"uid":[self getUUID],
                  @"devName":[XDeviceHelper getPlatformString],
                  @"idfa":idfaStr};
    
    //    }
}
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    
    [WDUserDefaults setObject:idfaStr forKey:XSJUserDefault_IDFA];
    [WDUserDefaults synchronize];
    MyLog(@"======%@",dict);
}
/**
 网络操作失败
 @param dict 失败之后的数据
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    //    [super requestFaildWithDictionary:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_backgroundImageView];
    _backgroundImageView.backgroundColor = CCXColorWithRGB(78, 142 , 220);
    _backgroundImageView.userInteractionEnabled = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您手机系统版本过低，该应用只支持iOS8.0以上使用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }else {
        [self getServiceURL];
    }
    
}

- (void)getServiceURL{
   
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSString *version = [XDeviceHelper getAppBundleShortVersion];
    [params setObject:version forKey:@"version"];
    [params setObject:@"0" forKey:@"from"];
    [params setObject:@"1" forKey:@"isTest"];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@"queryServiceUrl" forKey:@"cmd"];
    [allParams setObject:CCXVersion forKey:@"version"];
    //    [allParams setObject:@"245Y7BSfDHIWEie34" forKey:@"token"];
    [allParams setObject:params forKey:@"params"];
    
    [allParams setObject:[self getSeccsion].token?[self getSeccsion].token:@"" forKey:@"token"];
    NSString *uuidString = [self getSeccsion].uuid?[self getSeccsion].uuid:@"";
    [allParams setObject:uuidString forKey:@"uuid"];
    
    
    
    
    NSString *changeString = [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:allParams]];

    NSDictionary *secretDict = @{@"key":changeString};
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //响应格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/javascript", @"text/html", nil];//接受类型
    [manager POST:CCXService parameters:secretDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64String = [SecurityUtil decryptAESData:responseObject[@"key"]];

        NSDictionary *keyDict = [SecurityUtil dictionaryWithJsonString:base64String];
  
        NSString *resultNote = keyDict[@"resultNote"];
        NSString *result = [NSString stringWithFormat:@"%@", keyDict[@"result"]];
        if (![result isEqualToString:@"0"]) {
            [self showHit:resultNote];
            return;
        }
 
        NSDictionary *detail = keyDict[@"detail"];
        _urlModel = [GJJQueryServiceUrlModel yy_modelWithDictionary:detail];
        _urlModel.switch_on_off_1 = @1;
        _urlModel.switch_on_off_2 = @1;
        
        //        MyLog(@"urlModel-->%@",_urlModel);
        NSArray *dataList = detail[@"dataList"];
//        if (dataList.count) {
//            NSDictionary *urlDict = dataList[0];
//            [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlDict[@"url"]] placeholderImage:[UIImage imageNamed:@"splashing"]];
//            //            MyLog(@"%@",urlDict[@"url"]);
//        }

        CCXSERVR = _urlModel.serviceUrl;
        
        
        NSString *oldIDFA = [WDUserDefaults objectForKey:XSJUserDefault_IDFA];
        //        if (oldIDFA && [oldIDFA isEqualToString:idfaStr]) {
        [self prepareDataWithCount:100];
        //        }
        
        [self isNeedUpdate];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败=====%@", error);
        
        [_backgroundImageView removeFromSuperview];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self reloadClick];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }];
}
-(void)getVerificationClick:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
        [_delegate doNotForceUpdate];
    }

}

#pragma mark - UITapGestureRecognizer
- (void)tapADImage:(UITapGestureRecognizer *)sender
{
    NSArray *dataList = _urlModel.dataList;
    if (dataList.count) {
        NSDictionary *urlDict = dataList[0];
        NSString *h5Url = urlDict[@"h5_url"];
        if (h5Url.length > 0) {
//            [self invalidateTimer];
            [_getVerificationButton stopCountDown];
            GJJADImageViewController *controller = [[GJJADImageViewController alloc]init];
            controller.url = urlDict[@"h5_url"];
            controller.title = urlDict[@"title"];
            controller.messageId = urlDict[@"messageId"];
            controller.shareStatus = urlDict[@"shareStatus"];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:navigationController animated:NO completion:^{
                [_backgroundImageView removeFromSuperview];
            }];
        }
    }
}

- (void)timerFired
{
    [_passButton setTitle:[NSString stringWithFormat:@"%@s",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)invalidateTimer
{
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

- (void)CloseTimer
{
    [self invalidateTimer];
    
    if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
        [_delegate doNotForceUpdate];
    }
}

- (void)passClick
{
    [self CloseTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}

- (void)showHit:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = string;
    hud.delegate = self;
    [hud hideAnimated:YES afterDelay:1];
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
