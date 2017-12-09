//
//  GJJIdentityVerifyViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/6.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJIdentityVerifyViewController.h"
#import "GJJCertIdModel.h"
#import "GJJZMCreditModel.h"
#import "ZMCreditSDK.framework/Headers/ALCreditService.h"
#import "GJJUserBindBankCardViewController.h"
#import "GJJIDCardScanSuccessView.h"
#import "GJJScanIDCardFrontSuccessViewController.h"
#import "GJJScanIDCardBackSuccessViewController.h"


typedef NS_ENUM(NSUInteger, GJJIdentityVerifyRequest) {
    GJJIdentityVerifyRequestGetID,
    GJJIdentityVerifyRequestIDCardFrontImage,
    GJJIdentityVerifyRequestIDCardBackImage,
    GJJIdentityVerifyRequestHuoTi,
    GJJIdentityVerifyRequestZM,
    GJJIdentityVerifyRequestZMBack,
};

@interface GJJIdentityVerifyViewController ()
<GJJIDCardScanSuccessViewDelegate>
//GJJScanIDCardFrontSuccessViewControllerDelegate,
//GJJScanIDCardBackSuccessViewControllerDelegate>

@end

@implementation GJJIdentityVerifyViewController
{
    //扫描身份证的页面截图
    UIView *_getScreenView;
    
    UIView *_IDCardFrontView;
    UIView *_IDCardReverseView;
    UIImageView *_IDCardFrontImageView;
    UIImageView *_IDCardReverseImageView;
    
    GJJIDCardScanSuccessView *_frontSuccessView;
    GJJIDCardScanSuccessView *_backSuccessView;
    TCARD_TYPE _IDCardType;
    BOOL _isFront;
    
//    GJJScanIDCardFrontSuccessViewController *_frontSuccessController;
//    GJJScanIDCardBackSuccessViewController *_backSuccessController;
//    BOOL _isNeedShowFrontSuccessController;
//    BOOL _isNeedShowBackSuccessController;
    
    UIImage *_IDCardFrontImage;
    UIImage *_IDCardBackImage;
    NSDictionary *_frontDict;
    NSDictionary *_backDict;
    
//    OliveappDetectedFrame *_oliveappDetectedFrame;
    
    UIButton *_verifyButton;
    
    GJJCertIdModel *_certIdModel;
    GJJZMCreditModel *_zmCreditModel;
    NSDictionary *_zmDict;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CCXColorWithHex(@"e6e6e6");
    [self setupData];
    [self setupView];
}

- (void)setupData
{

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setRequestIDCardFrontImageString:(NSString *)requestIDCardFrontImageString
{
    _requestIDCardFrontImageString = requestIDCardFrontImageString;
}

- (void)setRequestIDCardBackImageString:(NSString *)requestIDCardBackImageString
{
    _requestIDCardBackImageString = requestIDCardBackImageString;
}

- (void)setSchedule:(NSUInteger)schedule
{
    _schedule = schedule;
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _IDCardFrontView = [[UIView alloc]init];
    [self.view addSubview:_IDCardFrontView];
    _IDCardFrontView.backgroundColor = [UIColor whiteColor];
    _IDCardFrontView.layer.cornerRadius = AdaptationWidth(10);
    _IDCardFrontView.layer.masksToBounds = YES;
    if (_schedule < 3) {
        UITapGestureRecognizer *frontTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanFrontIDCard)];
        [_IDCardFrontView addGestureRecognizer:frontTap];
    }
    [_IDCardFrontView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(@(AdaptationWidth(25)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-25)));
        make.height.equalTo(self.view).multipliedBy(0.3);
    }];
    
    _IDCardFrontImageView = [[UIImageView alloc]init];
    [_IDCardFrontView addSubview:_IDCardFrontImageView];
    if (_requestIDCardFrontImageString) {
        [_IDCardFrontImageView setImageWithURL:[NSURL URLWithString:_requestIDCardFrontImageString] placeholderImage:[UIImage imageNamed:@"身份证加载图"]];
    }else {
        _IDCardFrontImageView.image = [UIImage imageNamed:@"身份认证身份证正面"];
    }
    [_IDCardFrontImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_IDCardFrontView).insets(UIEdgeInsetsMake(AdaptationHeight(15), AdaptationWidth(25), AdaptationHeight(15), AdaptationWidth(25)));
    }];
    
    _IDCardReverseView = [[UIView alloc]init];
    [self.view addSubview:_IDCardReverseView];
    _IDCardReverseView.backgroundColor = [UIColor whiteColor];
    _IDCardReverseView.layer.cornerRadius = AdaptationWidth(10);
    _IDCardReverseView.layer.masksToBounds = YES;
    if (_schedule < 3) {
        UITapGestureRecognizer *reverseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanReverseIDCard)];
        [_IDCardReverseView addGestureRecognizer:reverseTap];
    }
    [_IDCardReverseView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IDCardFrontView.bottom).offset(@(AdaptationWidth(25)));
        make.left.equalTo(_IDCardFrontView);
        make.right.equalTo(_IDCardFrontView);
        make.height.equalTo(_IDCardFrontView);
    }];
    
    _IDCardReverseImageView = [[UIImageView alloc]init];
    [_IDCardReverseView addSubview:_IDCardReverseImageView];
    if (_requestIDCardBackImageString) {
        [_IDCardReverseImageView setImageWithURL:[NSURL URLWithString:_requestIDCardBackImageString] placeholderImage:[UIImage imageNamed:@"身份证加载图"]];
    }else {
        _IDCardReverseImageView.image = [UIImage imageNamed:@"身份认证身份证反面"];
    }
    [_IDCardReverseImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_IDCardReverseView).insets(UIEdgeInsetsMake(AdaptationHeight(15), AdaptationWidth(25), AdaptationHeight(15), AdaptationWidth(25)));
    }];
    
    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_verifyButton];
    _verifyButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _verifyButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [_verifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    if (_schedule < 3) {
        [_verifyButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_verifyButton addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_schedule < 2) {
            [_verifyButton setTitle:@"核对身份信息" forState:UIControlStateNormal];
            [_verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _verifyButton.userInteractionEnabled = NO;
            _verifyButton.backgroundColor = CCXColorWithHex(@"cccccc");
        }
    }else if (_schedule == 3) {
        [_verifyButton setTitle:@"芝麻信用认证" forState:UIControlStateNormal];
        [_verifyButton addTarget:self action:@selector(zmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    _verifyButton.layer.cornerRadius = AdaptationWidth(3);
    _verifyButton.layer.masksToBounds = YES;
    [_verifyButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_IDCardReverseView.bottom).offset(@(AdaptationWidth(35)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(16)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-16)));
        make.height.equalTo(@(AdaptationWidth(50)));
    }];
    
//    if (_schedule != 8) {
//        _scheduleProgressView = [[UIProgressView alloc]init];
//        [self.view addSubview:_scheduleProgressView];
//        _scheduleProgressView.progressImage = [GJJAppUtils imageWithColor:[UIColor colorWithHexString:GJJMainColorString] cornerRadius:AdaptationHeight(5)];
//        _scheduleProgressView.trackTintColor = [UIColor colorWithHexString:@"999897"];
//        [_scheduleProgressView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.equalTo(10);
//        }];
//        
//        _scheduleProgressLabel = [[UILabel alloc]init];
//        [self.view addSubview:_scheduleProgressLabel];
//        _scheduleProgressLabel.textColor = [UIColor colorWithHexString:@"414044"];
//        _scheduleProgressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//        _scheduleProgressLabel.textAlignment = NSTextAlignmentCenter;
//        [_scheduleProgressLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.height.equalTo(@(AdaptationHeight(20)));
//            make.bottom.equalTo(_scheduleProgressView.top).offset(@(-6));
//        }];
//        
//        if (_schedule == 0) {
//            _scheduleProgressView.progress = 0.0;
//            _scheduleProgressLabel.text = @"0%";
//        }else if (_schedule == 1) {
//            _scheduleProgressView.progress = 0.125;
//            _scheduleProgressLabel.text = @"12.5%";
//        }else if (_schedule == 2) {
//            _scheduleProgressView.progress = 0.25;
//            _scheduleProgressLabel.text = @"25%";
//        }else if (_schedule == 3) {
//            _scheduleProgressView.progress = 0.375;
//            _scheduleProgressLabel.text = @"37.5%";
//        }
//    }
}

#pragma mark - UITapGestureRecognizer

- (void)scanFrontIDCard
{
    //扫描身份证正面
    _isFront = 1;
    [self startIDCardOCR];
}

- (void)scanReverseIDCard
{
    _isFront = 0;
    if (!_IDCardFrontImage && !_requestIDCardFrontImageString) {
        [self setHudWithName:@"请扫描身份证正面" Time:1 andType:1];
        return;
    }
    //扫描身份证反面
    [self startIDCardBackOCR];
}

#pragma mark - 身份证扫描
/**
 身份证全图
 @param iCardType 20:反面 17：正面
 @param cardImage 图片
 */
-(void)sendTakeImage:(TCARD_TYPE)iCardType image:(UIImage *)cardImage
{
    _IDCardType = iCardType;
    if (iCardType == 17 && _isFront == 0) {
        [self setHudWithName:@"请扫描身份证反面" Time:1 andType:1];
        return;
    }
    if (iCardType == 20 && _isFront == 1) {
        [self setHudWithName:@"请扫描身份证正面" Time:1 andType:1];
        return;
    }
    if (iCardType == 17) {
        
        _IDCardFrontImage = cardImage;

        _frontSuccessView = [[GJJIDCardScanSuccessView alloc]initWithType:iCardType image:cardImage];
        [self.view addSubview:_frontSuccessView];
        _frontSuccessView.delegate = self;
        [_frontSuccessView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }else if (iCardType == 20) {
        
        _IDCardBackImage = cardImage;
        
        _backSuccessView = [[GJJIDCardScanSuccessView alloc]initWithType:iCardType image:cardImage];
        [self.view addSubview:_backSuccessView];
        _backSuccessView.delegate = self;
        [_backSuccessView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period
{
    if (_isFront) {
        [self setHudWithName:@"请扫描身份证正面" Time:1 andType:1];
        return;
    }else {
        _backDict = @{@"issue":issue,
                      @"period":period};
        _backSuccessView.infoDict = _backDict;
        

    }
}

// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *)address NUM:(NSString *)num
{
    if (!_isFront) {
        [self setHudWithName:@"请扫描身份证反面" Time:1 andType:1];
        return;
    }else {
        _frontDict = @{@"name":name,
                       @"sex":sex,
                       @"num":num};
        _frontSuccessView.infoDict = _frontDict;
        

    }
}

//获取身份证人脸照片
-(void)sendCardFaceImage:(UIImage *)image
{
    NSLog(@"%s", __func__);
}

#pragma mark - 活体识别 and OCR
//-(void)livenessDetectionSuccess:(OliveappDetectedFrame*)detectedFrame
//{
//    NSLog(@"%@", detectedFrame);
////    _oliveappDetectedFrame = detectedFrame;
//    [self prepareDataWithCount:GJJIdentityVerifyRequestHuoTi];
//}
//
//- (void)livenessDetectionFail: (int)sessionState withDetectedFrame: (OliveappDetectedFrame*)detectedFrame
//{
//    [super livenessDetectionFail:sessionState withDetectedFrame:detectedFrame];
//}

-(void)livenessDetectionCancel
{
    [self setHudWithName:@"用户取消检测" Time:1 andType:2];
}

#pragma mark - button click
- (void)verifyClick:(UIButton *)sender
{
//    [self startLivenessDetection];
}

- (void)zmClick
{
    [self verifyZM];
}

- (void)alertToVerifyZM
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测成功" message:@"客官简直帅呆了呢" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"下一步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self verifyZM];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)verifyZM
{
    [self prepareDataWithCount:GJJIdentityVerifyRequestGetID];
}

-(void)setRequestParams
{
    if (self.requestCount == GJJIdentityVerifyRequestGetID) {
        //芝麻信用认证
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"0"};
    }else if (self.requestCount == GJJIdentityVerifyRequestIDCardFrontImage) {
        self.cmd = WQUpLoadPicture;
        NSData *imageData = UIImageJPEGRepresentation(_IDCardFrontImage, 1);
        NSString *imgIoString = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"picType":@"0",
                      @"userName":_frontDict[@"name"],
                      @"certId":_frontDict[@"num"],
                      @"imgIo":imgIoString
                      };
        
    }else if (self.requestCount == GJJIdentityVerifyRequestIDCardBackImage) {
        self.cmd = WQUpLoadPicture;
        NSData *imageData = UIImageJPEGRepresentation(_IDCardBackImage, 1);
        NSString *imgIoString = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"picType":@"1",
                      @"imgIo":imgIoString
                      };
    }else if (self.requestCount == GJJIdentityVerifyRequestHuoTi) {
        self.cmd = GJJYituHuoti;
//        NSString *imgbagString = [[_oliveappDetectedFrame.verificationDataFullWithFanpai base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
        
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"imgbag":@""};
    }else if (self.requestCount == GJJIdentityVerifyRequestZM) {
        self.cmd = GJJAuthorizeQry;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"name":_certIdModel.userName,
                      @"certNo":_certIdModel.identityCard};
    }else if (self.requestCount == GJJIdentityVerifyRequestZMBack) {
        self.cmd = GJJZhimaCallBack;
        NSString *paramsStr = _zmDict[@"params"];
        NSString *sign = _zmDict[@"sign"];
        sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"params":[paramsStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]],
                      @"sign":[sign stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]]};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJIdentityVerifyRequestGetID) {
        _certIdModel = [GJJCertIdModel yy_modelWithDictionary:dict];
        [self prepareDataWithCount:GJJIdentityVerifyRequestZM];
    }else if (self.requestCount == GJJIdentityVerifyRequestIDCardFrontImage) {
        _IDCardFrontImageView.image = _IDCardFrontImage;
        if (!(_scheduleProgressView.progress > 0.125)) {
            _scheduleProgressView.progress = 0.125;
            _scheduleProgressLabel.text = @"12.5%";
        }
        CCXUser *user = [self getSeccsion];
        user.identityCard = _frontDict[@"num"];
        user.customName = _frontDict[@"name"];
        [self saveSeccionWithUser:user];
        [self startIDCardBackOCR];
    }else if (self.requestCount == GJJIdentityVerifyRequestIDCardBackImage) {
        _IDCardReverseImageView.image = _IDCardBackImage;
        if (!(_scheduleProgressView.progress > 0.25)) {
            _scheduleProgressView.progress = 0.25;
            _scheduleProgressLabel.text = @"25%";
        }
        if ((_IDCardFrontImage && _IDCardBackImage) || (_requestIDCardFrontImageString && _IDCardBackImage)) {
            _verifyButton.userInteractionEnabled = YES;
            _verifyButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
            [_verifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
            [_verifyButton setTitle:@"下一步" forState:UIControlStateNormal];
        }
//        [self startLivenessDetection];
    }else if (self.requestCount == GJJIdentityVerifyRequestHuoTi) {
        if ([dict[@"isSuccess"] integerValue] == 0) {
            _scheduleProgressView.progress = 0.375;
            _scheduleProgressLabel.text = @"37.5%";
            [self alertToVerifyZM];
            [_verifyButton setTitle:@"芝麻信用认证" forState:UIControlStateNormal];
            [_verifyButton removeTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];
            [_verifyButton addTarget:self action:@selector(verifyZM) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [self setHudWithName:@"活体检测提交失败" Time:1 andType:1];
        }
    }else if (self.requestCount == GJJIdentityVerifyRequestZM) {
        _zmCreditModel = [GJJZMCreditModel yy_modelWithDictionary:dict];
        [self launchSDK];
    }else if (self.requestCount == GJJIdentityVerifyRequestZMBack) {
        GJJUserBindBankCardViewController *controller = [[GJJUserBindBankCardViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"银行卡认证";
        controller.popViewController = self.popViewController;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJIdentityVerifyRequestZM) {
        if ([dict[@"resultNote"] isEqualToString:@"芝麻信用已经认证"]) {
            [self setHudWithName:@"芝麻信用已经认证" Time:1 andType:0];
            GJJUserBindBankCardViewController *controller = [[GJJUserBindBankCardViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"银行卡认证";
            controller.popViewController = self.popViewController;
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [self setHudWithName:dict[@"resultNote"] Time:1 andType:0];
            return;
        }
    }else {
        [super requestFaildWithDictionary:dict];
        if (self.requestCount == GJJIdentityVerifyRequestIDCardFrontImage) {
            _IDCardFrontImage = nil;
        }else if (self.requestCount == GJJIdentityVerifyRequestIDCardBackImage) {
            _IDCardBackImage = nil;
        }
    }
}

- (void)launchSDK {
    // 商户需要从服务端获取
    NSString* appId = ALZMAPPID;
    [[ALCreditService sharedService] queryUserAuthReq:appId sign:_zmCreditModel.sign params:_zmCreditModel.params extParams:nil selector:@selector(result:) target:self];
}

- (void)result:(NSMutableDictionary *)dict
{
    MyLog(@"dict：%@", dict);
    if ([dict[@"authResult"] isEqualToString:@""]) {
        return;
    }
    
    _zmDict = dict;
    [self prepareDataWithCount:GJJIdentityVerifyRequestZMBack];
}

- (void)popToCenterController
{
    [self.navigationController popToViewController:self.popViewController animated:YES];
}

#pragma mark - GJJIDCardScanSuccessViewDelegate
- (void)sureAgainInfo:(NSDictionary *)infoDict infoView:(GJJIDCardScanSuccessView *)infoView
{
    _frontDict = infoDict;
    [infoView removeFromSuperview];
    [self prepareDataWithCount:GJJIdentityVerifyRequestIDCardFrontImage];

//    NSString *infoString = [[NSString alloc]initWithFormat:@"姓名：%@ \n性别：%@ \n身份证号：%@", infoDict[@"name"], infoDict[@"sex"], infoDict[@"num"]];
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认信息" message:infoString preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
//        
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//        _frontDict = infoDict;
//        [infoView removeFromSuperview];
//        [self prepareDataWithCount:GJJIdentityVerifyRequestIDCardFrontImage];
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)IDCardScanSureInfoWithInfo:(NSDictionary *)infoDict
{
    if (_IDCardType == 17) {
        _frontDict = infoDict;
        [self prepareDataWithCount:GJJIdentityVerifyRequestIDCardFrontImage];
        
    }else if (_IDCardType == 20) {
        _backDict = infoDict;
        [self prepareDataWithCount:GJJIdentityVerifyRequestIDCardBackImage];
    }
}

- (void)IDCardRescan
{
    if (_IDCardType == 17) {
        [self startIDCardOCR];
    }else if (_IDCardType == 20) {
        [self startIDCardBackOCR];
    }
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
