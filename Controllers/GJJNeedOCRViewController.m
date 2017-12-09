//
//  GJJNeedOCRViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/3/9.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJNeedOCRViewController.h"


@interface GJJNeedOCRViewController ()

@end

@implementation GJJNeedOCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 活体识别
/**
 开始活体识别
 */
-(void)startLivenessDetection{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){//权限打开
//        UIStoryboard *board = [UIStoryboard storyboardWithName: @"LivenessDetection" bundle: nil];
//        OliveappLivenessDetectionViewController* livenessViewController =
//        (OliveappLivenessDetectionViewController*) [board instantiateViewControllerWithIdentifier: @"LivenessDetectionStoryboard"];
//        livenessViewController.navigationItem.title = @"身份认证";
//        __weak typeof(self) weakSelf = self;
//        NSError *error;
//        BOOL isSuccess;
//        isSuccess = [livenessViewController setConfigLivenessDetection:weakSelf
//                                                              withMode: 2
//                                                             withError: &error];
//        
//        UINavigationController *oliveappLivenessDetectionNavigation = [[UINavigationController alloc]initWithRootViewController:livenessViewController];
//        [oliveappLivenessDetectionNavigation.navigationBar setBackgroundImage:[GJJAppUtils createImageWithColor:[UIColor colorWithHexString:STBtnTextColor]] forBarMetrics:UIBarMetricsDefault];
//        [oliveappLivenessDetectionNavigation.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:35*CCXSCREENSCALE]}];
//        oliveappLivenessDetectionNavigation.navigationBar.translucent = NO;
//        [self presentViewController:oliveappLivenessDetectionNavigation animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){//权限未打开
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->相机%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){//第一次打开
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self startLivenessDetection];
            }
        }];
    }
}

/**
 * 2.活体检测成功时的回调 *
 * @param detectedFrame 返回检测到的图像 */
//- (void) onLivenessSuccess: (OliveappDetectedFrame*)detectedFrame {
//    [self livenessDetectionSuccess:detectedFrame];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

//-(void)livenessDetectionSuccess:(OliveappDetectedFrame *)detectedFrame{}
//-(void)livenessDetectionCancel{};
//-(void)livenessDetectionFail:(int)sessionState withDetectedFrame:(OliveappDetectedFrame *)detectedFrame{};

/**
 * 3.活体检测失败时的回调 *
 * @param sessionState 活体检测的返回状态
 * @param detectedFrame 返回检测到的图像 */
//- (void) onLivenessFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*)detectedFrame {
//    [self livenessDetectionFail:sessionState withDetectedFrame:detectedFrame];
//    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"活体检测失败\n请谨慎操作" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//            [self startLivenessDetection];
//        }];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }];
//}

/**
 * 4.活体检测取消时的回调
 */
//- (void) onLivenessCancel {
//    [self livenessDetectionCancel];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
#pragma mark - 身份证信息

/**
 身份证正面扫描
 */
-(void)startIDCardOCR{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){//权限打开
//        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
//        con.scNaigationDelegate = self;
//        con.iCardType = TIDCARD2;
//        con.isDisPlayTxt = YES;
//        con.ScanMode = TIDC_SCAN_MODE;
//        [self presentViewController:con animated:YES completion:NULL];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){//权限未打开
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->相机%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){//第一次打开
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self startIDCardOCR];
            }
        }];
    }
}

//全部正面信息
- (void)sendAllValue:(NSString *)text
{
    NSLog(@"all  = %@",text);
}

/**
 身份证全图
 
 @param iCardType 17:正面  20:表示反面
 @param cardImage 图片
 */
//-(void)sendTakeImage:(TCARD_TYPE)iCardType image:(UIImage *)cardImage{}
//
////获取身份证人脸照片
//-(void)sendCardFaceImage:(UIImage *)image{}

// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num{
    NSLog(@"idc  = %@\n%@\n%@\n%@\n%@\n%@\n",name,sex,folk,birthday,address,num);
}

/**
 身份证反面扫描
 */
-(void)startIDCardBackOCR{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){//权限打开
//        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
//        con.scNaigationDelegate = self;
//        con.iCardType = TIDCARD2;
//        con.isDisPlayTxt = YES;
//        con.ScanMode = TIDC_SCAN_MODE;
//        [self presentViewController:con animated:YES completion:NULL];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){//权限未打开
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->相机%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){//第一次打开
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self startIDCardBackOCR];
            }
        }];
    }
}

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period{
    NSLog(@"idcback  = %@\n%@\n",issue,period);
}

#pragma MARK - 银行卡信息
/**
 扫描银行卡
 */
-(void)startBankCardOCR{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized){//权限打开
        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
        con.scNaigationDelegate = self;
        con.iCardType = TIDBANK;
        con.isDisPlayTxt = YES;
        [self presentViewController:con animated:YES completion:NULL];
    }else if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted){//权限未打开
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->相机%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){//第一次打开
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self startBankCardOCR];
            }
        }];
    }
}
/**
 银行卡回调
 
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name{
    NSLog(@"%@\n%@\n%@\n%@\n%@",bank_num,bank_name,bank_orgcode,bank_class,bank_name);
}

/**
 @param BankCardImage 银行卡扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage{
    NSLog(@"%@",NSStringFromCGSize(BankCardImage.size));
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
