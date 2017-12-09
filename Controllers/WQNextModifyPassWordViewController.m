//
//  WQModifyPasswordViewController.m
//  RenrenCost
//
//  Created by peterwon on 16/8/31.
//  Copyright © 2016年 ChuanxiChen. All rights reserved.
//

#import "WQModifyPasswordViewController.h"
#import "WQLogViewController.h"
#import "WQRedrawTextfield.h"
#import "ZQGraphValidateCode.h"
#import "WQVerCodeImageView.h"
#import "WQNextModifyPassWordViewController.h"
#import "GJJCountDownButton.h"

typedef NS_ENUM(NSInteger,WQModifyPasswordRequest){
    WQModifyPwdGetValiCodeFromPhone,
    WQConformModifyPwdRequst,
    WQLogInRequest,
};

@interface WQNextModifyPassWordViewController ()<UITextFieldDelegate>

/**新密码*/
@property(nonatomic,strong)WQRedrawTextfield *modifiedPwdText;

/**验证码*/
@property(nonatomic,strong)WQRedrawTextfield *validateCodeText;
/**验证码按钮*/
@property(nonatomic,strong)UIButton *vericationRightBtn;


@end

@implementation WQNextModifyPassWordViewController{
    NSInteger    _timer;
    NSTimer      *_timerCode;
    NSTimer      *_timerClose;
    NSDictionary *_dict;
    NSString     *_transformPhoneStr;
    GJJCountDownButton *_getVerificationButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTextfield];
    [self createButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_needCountDown) {
        [self beginCountDown];
    }
}


/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    if (self.requestCount == WQModifyPwdGetValiCodeFromPhone) {
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone": _phontString,
                      @"userId":@"",
                      @"type":@"2"};
    }else if (self.requestCount == WQConformModifyPwdRequst){
        self.cmd = WQUpdatePassword;
        self.dict = @{@"phone": _phontString,
                      @"newPassword": [self md5:self.modifiedPwdText.text],
                      @"valiCode": _validateCodeText.text,
                      @"type": @"2"};
    }else if (self.requestCount == WQLogInRequest){
        self.cmd = WQLogin;
        self.dict = @{@"userCode":_phontString,
                      @"passWord":[self md5:self.modifiedPwdText.text]};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == WQModifyPwdGetValiCodeFromPhone) {
        _dict = dict;
        [self setHudWithName:@"验证码获取成功" Time:1 andType:0];
        [self beginCountDown];

    }else if (self.requestCount == WQConformModifyPwdRequst){
        [self.hud hideAnimated:NO];
        [self prepareDataWithCount:WQLogInRequest];
    }else if (self.requestCount == WQLogInRequest) {
        CCXUser *user = [[CCXUser alloc]initWithDictionary:@{
                                                             @"name":dict[@"userCode"],
                                                             @"passWord":_modifiedPwdText.text,                                                            @"phone":dict[@"phone"],
                                                             @"userId":[NSString stringWithFormat:@"%@", dict[@"userId"]],
                                                             @"customName":dict[@"customName"],
                                                             @"orgId":[NSString stringWithFormat:@"%@",dict[@"orgId"]],
                                                             @"token":dict[@"token"],
                                                             @"uuid":dict[@"uuid"]
                                                             }];
        [self saveSeccionWithUser:user];
        [self setHudWithName:@"密码修改成功" Time:0 andType:0];
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
}

//创建textfield tag：(获取验证码) 10  （手机验证码输入框）3 （密码输入框）1
-(void)createTextfield{
    UIView *modifiedView = [[UIView alloc]initWithFrame:CCXRectMake(0, 30, 750, 650)];
    [self.view addSubview:modifiedView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(40, 0, 400, 50)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:32*CCXSCREENSCALE];
    if (_phontString.length > 0 ) {
        //字符串截取
        NSString *string = [_phontString substringWithRange:NSMakeRange(3, 4)];
        //字符串的替换
        _transformPhoneStr = [_phontString stringByReplacingOccurrencesOfString:string withString:@"****"];
        label.text = [NSString stringWithFormat:@"验证码已发送至%@",_phontString];
        label.adjustsFontSizeToFitWidth = YES;
    }
    [modifiedView addSubview:label];
    

    _getVerificationButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    _getVerificationButton.frame = CCXRectMake(450, 0, 320, 50);
    [modifiedView addSubview:_getVerificationButton];
    _getVerificationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_getVerificationButton setTitle:@"未收到？" forState:UIControlStateNormal];
    [_getVerificationButton setTitleColor:[UIColor colorWithHexString:@"ff0000"] forState:UIControlStateNormal];
    _getVerificationButton.titleLabel.font = [UIFont systemFontOfSize:32*CCXSCREENSCALE];
//    getVerificationCodeButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
//    getVerificationCodeButton.layer.cornerRadius = AdaptationWidth(5);
//    getVerificationCodeButton.layer.masksToBounds = YES;
//    [getVerificationCodeButton sizeToFit];
    [_getVerificationButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];

    
    self.validateCodeText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 80, 670, 86)];
    self.validateCodeText.backgroundColor = CCXBackColor;
    self.validateCodeText.borderStyle = UITextBorderStyleRoundedRect;
    self.validateCodeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入手机验证码" attributes:@{}];
    self.validateCodeText.clearButtonMode = UITextFieldViewModeAlways;
    self.validateCodeText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    self.validateCodeText.tag = 3;
    self.validateCodeText.delegate = self;
    self.validateCodeText.keyboardType = UIKeyboardTypeNumberPad;
    self.validateCodeText.leftOffset = 10;
    self.validateCodeText.leftOffset = 10;
    
    //验证码左图片
    UIImageView *imageV1 =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    imageV1.frame = CCXRectMake(0, 0, 30, 40);
    self.validateCodeText.leftView = imageV1;
    self.validateCodeText.leftViewMode = UITextFieldViewModeAlways;
    
    self.modifiedPwdText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 180, 670, 86)];
    self.modifiedPwdText.backgroundColor = CCXBackColor;
    self.modifiedPwdText.borderStyle = UITextBorderStyleRoundedRect;
    self.modifiedPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码设置为8—20位字母和数字" attributes:@{}];
    self.modifiedPwdText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    self.modifiedPwdText.tag = 1;
//    self.modifiedPwdText.delegate = self;
    self.modifiedPwdText.secureTextEntry = YES;
    self.modifiedPwdText.leftOffset = 10;
    self.modifiedPwdText.rightOffset = 10;
    [self.modifiedPwdText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    //修改密码左图片
    UIImageView *imageV2 = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"password"]];
    imageV2.frame = CCXRectMake(0, 0, 30, 40);
    self.modifiedPwdText.leftView = imageV2;
    self.modifiedPwdText.leftViewMode = UITextFieldViewModeAlways;

    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CCXRectMake(0, 23, 120, 40);
    [secureButton setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"eye1"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    self.modifiedPwdText.rightView = secureButton;
    self.modifiedPwdText.rightViewMode = UITextFieldViewModeAlways;
    
    [modifiedView addSubview:_vericationRightBtn];
    [modifiedView addSubview:_modifiedPwdText];
    [modifiedView addSubview:_validateCodeText];
}

- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
}


/**
 *  密码切换显示
 */
- (void)securePasswordClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.modifiedPwdText.secureTextEntry = NO;
    }else{
        self.modifiedPwdText.secureTextEntry = YES;
    }
    NSString *text = self.modifiedPwdText.text;
    self.modifiedPwdText.text = @" ";
    self.modifiedPwdText.text = text;
}


/**
  （确认按钮）20
 */
-(void)createButton{
    UIButton *confirmModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmModifyButton.frame = CCXRectMake(40, 346, 670, 100);
    confirmModifyButton.layer.cornerRadius = 20*CCXSCREENSCALE;
    confirmModifyButton.clipsToBounds = YES;
    confirmModifyButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [confirmModifyButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [confirmModifyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    confirmModifyButton.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    confirmModifyButton.tag = 20;
    [confirmModifyButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmModifyButton];
}

/**
 *   注意事项:
 *  在XIB,SB,或者是在代码中创建Button的时候,Button的样式要设置成为 Custom 样式,否则在倒计时过程中 Button 的Tittle 会闪动.
 */



#pragma mark - NSTimer

- (void)beginCountDown
{
//    _timer = 60;
//    _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//    [_timerCode setFireDate:[NSDate date]];
//    [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
//    self.vericationRightBtn.userInteractionEnabled = NO;
//    _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
//    [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];
    _getVerificationButton.userInteractionEnabled = NO;
    
    [_getVerificationButton startCountDownWithSecond:60];
    
    [_getVerificationButton countDownChanging:^NSString *(GJJCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"(%@)", @(second)];
        return title;
    }];
    [_getVerificationButton countDownFinished:^NSString *(GJJCountDownButton *countDownButton, NSUInteger second) {
        _getVerificationButton.userInteractionEnabled = YES;
        return @"未收到？";
    }];

}

//倒计时
- (void)timerFired{
    [_vericationRightBtn setTitle:[NSString stringWithFormat:@"(%@s)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer{
    [_vericationRightBtn setTitle:@"未收到?" forState:UIControlStateNormal];
    _vericationRightBtn.userInteractionEnabled = YES;
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

-(void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 10) {//获取验证码
        [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
        
    }else if (btn.tag == 20){//确认修改
        if (_validateCodeText.text.length == 0) {
            [self setHudWithName:@"请输入验证码" Time:1 andType:3];
            return;
        }
                if (_modifiedPwdText.text.length<8) {
                    [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
                    return;
                }else{//RegEx:正则表达式
                    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    if (![pred evaluateWithObject:_modifiedPwdText.text]){
                        [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
                        return;
                    }
                }
                    [self prepareDataWithCount:WQConformModifyPwdRequst];
    }
}

#pragma mark -- textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        if (textField.tag == 1) {//密码
        if ((textField.text.length+string.length-range.length)>20) {
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return NO;
        }
    }
    return YES;
}

#pragma mark comstomized delegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.modifiedPwdText) {
        if (self.modifiedPwdText.text.length >= 20) {
            self.modifiedPwdText.text = [self.modifiedPwdText.text substringToIndex:20];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
