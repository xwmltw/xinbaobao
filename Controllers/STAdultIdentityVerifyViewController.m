//
//  STAdultIdentityVerifyViewController.m
//  RenRenhua2.0
//
//  Created by 孙涛 on 2017/8/8.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STAdultIdentityVerifyViewController.h"
#import "UDIDSafeAuthEngine.h"
#import "UDIDSafeDataDefine.h"
#import "SDAutoLayout.h"

#import "GJJCertIdModel.h"
#import "GJJZMCreditModel.h"
#import "ZMCreditSDK.framework/Headers/ALCreditService.h"
#import "GJJAdultUserBindBankCardViewController.h"


typedef NS_ENUM(NSUInteger, GJJAdultIdentityVerifyRequest) {
    STAdultIdentityVerifySubmitInfo,//提交姓名与身份证号
    STAdultIdentityVerifyRequestNotificationInfo,//请求订单号和回调地址
    STAdultIdentityVerifyRequestGetID,
    STAdultIdentityVerifyRequestZM,
    STAdultIdentityVerifyRequestZMBack,
};

@interface STAdultIdentityVerifyViewController ()<UDIDSafeAuthDelegate>
@property (nonatomic,strong)UIButton *verifyButton;
@property (nonatomic,strong)UIImageView *frontImageV;
@property (nonatomic,strong)UIImageView *backImageV;
@property (nonatomic,strong)UILabel *frontLabel;
@property (nonatomic,strong)UILabel *backLabel;
@end

@implementation STAdultIdentityVerifyViewController{
   
    UITextView *_textView;
    GJJCertIdModel *_certIdModel;
    GJJZMCreditModel *_zmCreditModel;
    NSDictionary *_zmDict;
    
    NSString *_infoString;
    
    NSString *_userName;
    NSString *_identityCardNum;
    NSString *_gender;//性别
    float _standardPoint;//标准分，用于比较相似度，合格后才上传姓名与身份证号给后台，开始芝麻信用认证，否则提示认证失败

}


#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor yellowColor];
    if (_schedule == 3) {
        [self verifyZM];
        return;
    }
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)setupView{
    // Do any additional setup after loading the view.
    [self.view addSubview:self.frontImageV];
    [self.view addSubview:self.frontLabel];
    [self.view addSubview:self.backImageV];
    [self.view addSubview:self.backLabel];
    [self.view addSubview:self.verifyButton];
    
    _frontImageV.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view,AdaptationHeight(32))
//    .leftSpaceToView(self.view, AdaptationWidth(107))
//    .rightSpaceToView(self.view, AdaptationWidth(108));
    .widthIs(AdaptationWidth(160))
    .heightIs(AdaptationHeight(125));
    
//    _frontLabel.sd_layout
//    .centerXEqualToView(self.view)
//    .topSpaceToView(_frontImageV,AdaptationHeight(5))
//    .widthIs(AdaptationWidth(69))
//    .heightIs(AdaptationHeight(20));
    
    _backImageV.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_frontImageV,AdaptationHeight(30))
//    .leftSpaceToView(self.view, AdaptationWidth(107))
//    .rightSpaceToView(self.view, AdaptationWidth(108));
    .widthIs(AdaptationWidth(160))
    .heightIs(AdaptationHeight(125));
    
//    _backLabel.sd_layout
//    .centerXEqualToView(self.view)
//    .topSpaceToView(_backImageV,AdaptationHeight(5))
//    .widthIs(AdaptationWidth(69))
//    .heightIs(AdaptationHeight(20));
    
//    _textView = [UITextView new];
//    _textView.editable = NO;
//    [self.view addSubview:_textView];
    
    _verifyButton.sd_layout
    .leftSpaceToView(self.view,AdaptationWidth(20))
    .topSpaceToView(_backImageV,AdaptationHeight(40))
    .rightSpaceToView(self.view, AdaptationWidth(20))
    .heightIs(AdaptationHeight(50));

//    _textView.sd_layout
//    .leftSpaceToView(self.view,AdaptationWidth(20))
//    .topSpaceToView(_verifyButton,AdaptationHeight(20))
//    .rightSpaceToView(self.view, AdaptationWidth(20))
//    .bottomSpaceToView(self.view, AdaptationHeight(20));

}



-(void)start{
    
    //talkingdata
    [TalkingData trackEvent:@"进行身份认证按钮"];

    [self prepareDataWithCount:STAdultIdentityVerifyRequestNotificationInfo];
    
}

-(void)launchUDSDKWithDictionary:(NSDictionary *)dict{
    
    UDIDSafeAuthEngine * engine = [[UDIDSafeAuthEngine alloc]init];
    engine.delegate = self;
    //秘钥
    engine.authKey = [dict objectForKey:@"authKey"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"authKey"]] : @"";;
    // 订单号
    engine.outOrderId = [dict objectForKey:@"partner_order_id"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"partner_order_id"]] : @"";
    //回调地址
    engine.notificationUrl =[dict objectForKey:@"notificationUrl"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"notificationUrl"]] : @"";
    engine.showInfo = YES;
    //需要传入当前的 UIViewController
    [engine startIdSafeWithUserName:@"" IdentityNumber:@"" InViewController:self];
 

}


//4. 回调方法:
- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo{
    NSLog(@"Finish");
    NSLog(@"result-->%lu",(unsigned long)result);
    NSLog(@"userinfo-->%@",userInfo);

    
    if (result == UDIDSafeAuthResult_Done) {
        
        if ([[userInfo objectForKey:@"be_idcard"] floatValue] >= _standardPoint) {
            //保存用户的最新信息
                CCXUser *user = [self getSeccsion];
                user.identityCard = userInfo[@"id_no"];
                user.customName = userInfo[@"id_name"];
                [self saveSeccionWithUser:user];

            _userName = [userInfo objectForKey:@"id_name"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id_name"]] : @"";
            _identityCardNum = [userInfo objectForKey:@"id_no"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id_no"]] : @"";
            _gender =  [userInfo objectForKey:@"flag_sex"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"flag_sex"]] : @"";
            [self prepareDataWithCount:STAdultIdentityVerifySubmitInfo];
        }else{
            [self setHudWithName:@"身份认证失败，请重新认证！" Time:2.0 andType:0];
        }
        

    }else{
         [self setHudWithName:@"身份认证失败，请重新认证！" Time:2.0 andType:0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self prepareDataWithCount:STAdultIdentityVerifyRequestGetID];
}

-(void)setRequestParams
{
    if (self.requestCount == STAdultIdentityVerifyRequestNotificationInfo) {
        self.cmd = STNotificationUrl;
        self.dict = @{@"userId":[self getSeccsion].uuid};

    }else if (self.requestCount == STAdultIdentityVerifySubmitInfo) {
        self.cmd = STSubmitInfo;
        self.dict = @{@"userId":[self getSeccsion].uuid,@"identityCard":_identityCardNum,@"name":_userName,@"gender":_gender};
        
    }else if (self.requestCount == STAdultIdentityVerifyRequestGetID) {
        //芝麻信用认证
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"0"};
    }else if  (self.requestCount == STAdultIdentityVerifyRequestZM) {
        self.cmd = GJJAuthorizeQry;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"name":_certIdModel.userName,
                      @"certNo":_certIdModel.identityCard};
    }else if (self.requestCount == STAdultIdentityVerifyRequestZMBack) {
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
    if (self.requestCount == STAdultIdentityVerifyRequestNotificationInfo) {
//        MyLog(@"infoDict-->%@",dict);
        _standardPoint = [dict objectForKey:@"score"] ? [[dict objectForKey:@"score"] floatValue] : 0.00;
        [self launchUDSDKWithDictionary:dict];
    }else if (self.requestCount == STAdultIdentityVerifySubmitInfo) {
        [self verifyZM];
        
    }else if (self.requestCount == STAdultIdentityVerifyRequestGetID) {
        //1.先授权，得到后台给的sign和params参数然
        _certIdModel = [GJJCertIdModel yy_modelWithDictionary:dict];
        [self prepareDataWithCount:STAdultIdentityVerifyRequestZM];
    }else if (self.requestCount == STAdultIdentityVerifyRequestZM) {
        //2.后去调用芝麻信用的SDK

        _zmCreditModel = [GJJZMCreditModel yy_modelWithDictionary:dict];
        [self launchSDK];
    }else if (self.requestCount == STAdultIdentityVerifyRequestZMBack) {
        //3.在芝麻信用的SDK回调里面去调用后台的芝麻信用回调接口，把芝麻信用SDK里面得到的sign和params传给后台
        GJJAdultUserBindBankCardViewController *controller = [[GJJAdultUserBindBankCardViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"银行卡认证";
        controller.popViewController = self.popViewController;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == STAdultIdentityVerifyRequestZM) {
        if ([dict[@"resultNote"] isEqualToString:@"芝麻信用已经认证"]) {
            [self setHudWithName:@"芝麻信用已经认证" Time:1 andType:0];
            GJJAdultUserBindBankCardViewController *controller = [[GJJAdultUserBindBankCardViewController alloc]init];
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
//        [self.navigationController popViewControllerAnimated:YES];
        [self popToCenterController];
        return;
    }
    
    _zmDict = dict;
    [self prepareDataWithCount:STAdultIdentityVerifyRequestZMBack];
}

- (void)popToCenterController
{
    [self.navigationController popToViewController:self.popViewController animated:YES];
}


//getter方法
-(UIImageView *)frontImageV{
    if (!_frontImageV) {
        _frontImageV = [UIImageView new];
        _frontImageV.contentMode = UIViewContentModeScaleAspectFit;
        _frontImageV.image = [UIImage imageNamed:@"zheng"];
    }
    return _frontImageV;
}

-(UIImageView *)backImageV{
    if (!_backImageV) {
        _backImageV = [UIImageView new];
        _backImageV.contentMode = UIViewContentModeScaleAspectFit;
        _backImageV.image = [UIImage imageNamed:@"fan"];
    }
    return _backImageV;
}

-(UILabel *)frontLabel{
    if (!_frontLabel) {
        _frontLabel = [UILabel new];
        _frontLabel.text = @"身份证正面面";
//        _frontLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _frontLabel.textColor = [UIColor lightGrayColor];
        _frontLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _frontLabel;
}


-(UILabel *)backLabel{
    if (!_backLabel) {
        _backLabel = [UILabel new];
        _backLabel.text = @"身份证反面";
//        _backLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _backLabel.textColor = [UIColor lightGrayColor];
        _backLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _backLabel;
}

-(UIButton *)verifyButton{
    if (!_verifyButton) {
        _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
        _verifyButton.layer.cornerRadius = AdaptationWidth(5);
        _verifyButton.clipsToBounds = YES;
        [_verifyButton setTitle:@"进行认证" forState:UIControlStateNormal];
        [_verifyButton setTitle:@"进行认证" forState:UIControlStateHighlighted];
        [_verifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
        [_verifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateHighlighted];
        [_verifyButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyButton;
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
