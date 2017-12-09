//
//  WQModifyPasswordViewController.m
//  RenrenCost
//
//  Created by peterwon on 16/8/31.
//  Copyright © 2016年 ChuanxiChen. All rights reserved.
//

#import "WQResetViewController.h"
#import "WQLogViewController.h"
#import "WQRedrawTextfield.h"
#import "GJJCountDownButton.h"
typedef NS_ENUM(NSInteger,WQResetUpdateRequest){
    WQModifyPwdGetValiCodeFromPhone,
    WQConformModifyPwdRequst,
    WQUpdateRequest,
    WQLogInRequest,
};

@interface WQResetViewController ()<UITextFieldDelegate>

/**新密码*/
@property(nonatomic,strong)WQRedrawTextfield *modifiedPwdText;

/**验证码*/
@property(nonatomic,strong)WQRedrawTextfield *verificationText;
/**验证码按钮*/
@property(nonatomic,strong)UIButton *vericationRightBtn;


@end

@implementation WQResetViewController{
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
    self.navigationItem.title = @"修改密码";
    [self createTextfield];
    [self createButton];
}

/**
 创建textfield tag（新的密码输入框）100 （获取验证码）200
 */
-(void)createTextfield{
    UIView *modifiedView = [[UIView alloc]initWithFrame:CCXRectMake(0, 30, 750, 510)];
    [self.view addSubview:modifiedView];
    _modifiedPwdText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 0, 670, 86)];
    _modifiedPwdText.backgroundColor = CCXBackColor;
    _modifiedPwdText.borderStyle = UITextBorderStyleRoundedRect;
    _modifiedPwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的新密码" attributes:@{}];
    _modifiedPwdText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _modifiedPwdText.tag = 100;
//    _modifiedPwdText.delegate = self;
    _modifiedPwdText.secureTextEntry = YES;
    _modifiedPwdText.leftOffset = 10;
    _modifiedPwdText.rightOffset = 10;
    [_modifiedPwdText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CCXRectMake(0, 23, 120, 40);
    [secureButton setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"eye1"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _modifiedPwdText.rightView = secureButton;
    _modifiedPwdText.rightViewMode = UITextFieldViewModeAlways;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(40, 120, 400, 50)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:32*CCXSCREENSCALE];
    if (_phoneString.length > 0 ) {
        //字符串截取
        NSString *string = [_phoneString substringWithRange:NSMakeRange(3, 4)];
        //字符串的替换
        _transformPhoneStr = [_phoneString stringByReplacingOccurrencesOfString:string withString:@"****"];
        label.text = [NSString stringWithFormat:@"验证码已发送至%@",_transformPhoneStr];
        label.adjustsFontSizeToFitWidth = YES;
    }
    [modifiedView addSubview:label];

    
    _verificationText = [[WQRedrawTextfield alloc]initWithFrame:CCXRectMake(40, 180, 473, 86)];
    _verificationText.tag = 200;
    _verificationText.backgroundColor = CCXBackColor;
    _verificationText.borderStyle = UITextBorderStyleRoundedRect;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的验证码" attributes:@{}];
    _verificationText.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _verificationText.delegate = self;
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.leftOffset = 10;
    
    //获取验证码按钮
//    _vericationRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _vericationRightBtn.frame = CCXRectMake(522, 180, 188, 86);
//    [_vericationRightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _vericationRightBtn.titleLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
//    _vericationRightBtn.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
//    [_vericationRightBtn setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
//    _vericationRightBtn.layer.cornerRadius  = 5;
//    _vericationRightBtn.layer.masksToBounds = YES;
//    [_vericationRightBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _vericationRightBtn.tag = 10;
//    [modifiedView addSubview:_vericationRightBtn];
    GJJCountDownButton *getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CCXRectMake(522, 180, 188, 86);
    [modifiedView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    getVerificationCodeButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    getVerificationCodeButton.layer.cornerRadius = AdaptationWidth(5);
    getVerificationCodeButton.layer.masksToBounds = YES;
    //    [getVerificationCodeButton sizeToFit];
    getVerificationCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //修改密码左边图片
    UIImageView *imageV3 =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    imageV3.frame = CCXRectMake(0, 0, 30, 40);
    _modifiedPwdText.leftView = imageV3;
    _modifiedPwdText.leftViewMode = UITextFieldViewModeAlways;
    
    //验证码左图片
    UIImageView *imageV2 =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"code"]];
    imageV2.frame = CCXRectMake(0, 0, 30, 40);
    _verificationText.leftView = imageV2;
    _verificationText.leftViewMode = UITextFieldViewModeAlways;
    
    [modifiedView addSubview:_modifiedPwdText];
    [modifiedView addSubview:_verificationText];
}

- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
}


- (void)beginCountDown
{
    _getVerificationButton.userInteractionEnabled = NO;
    
    [_getVerificationButton startCountDownWithSecond:60];
    
    [_getVerificationButton countDownChanging:^NSString *(GJJCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"(%@)", @(second)];
        return title;
    }];
    [_getVerificationButton countDownFinished:^NSString *(GJJCountDownButton *countDownButton, NSUInteger second) {
        _getVerificationButton.userInteractionEnabled = YES;
        return @"获取验证码";
    }];
    
}


/**
 *  密码切换显示
 */
- (void)securePasswordClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _modifiedPwdText.secureTextEntry = NO;
    }else{
        _modifiedPwdText.secureTextEntry = YES;
    }
    NSString *text = _modifiedPwdText.text;
    _modifiedPwdText.text = @" ";
    _modifiedPwdText.text = text;
}


/**
 确认按钮   tag 20
 */
-(void)createButton{
    UIButton *confirmModifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmModifyButton.frame = CCXRectMake(40, 346, 670, 100);
    confirmModifyButton.layer.cornerRadius = 20*CCXSCREENSCALE;
    confirmModifyButton.clipsToBounds = YES;
    confirmModifyButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [confirmModifyButton setTitle:@"确认" forState:UIControlStateNormal];
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

//倒计时
- (void)timerFired{
    [_vericationRightBtn setTitle:[NSString stringWithFormat:@"(%@s)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer{
    [_vericationRightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vericationRightBtn.userInteractionEnabled = YES;
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    if (self.requestCount == WQUpdateRequest) {
        self.cmd = WQUpdatePassword;
        self.dict = @{ @"phone": _phoneString,
                       @"newPassword": [self md5:_modifiedPwdText.text],
                       @"valiCode": _verificationText.text,
                       @"type":@"2"};
    }else if (self.requestCount == WQModifyPwdGetValiCodeFromPhone){
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone":_phoneString,
                      @"userId":user.userId,
                      @"type":@"2"};
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
//        self.vericationRightBtn.userInteractionEnabled = NO;
//        _timer = 60;
//        _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//        [_timerCode setFireDate:[NSDate date]];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
//        _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];
    }else if (self.requestCount == WQUpdateRequest){
        [self setHudWithName:@"密码修改成功" Time:1 andType:0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
}

-(void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 10) {//获取验证码
            [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
        }else if (btn.tag == 20){//确认修改
            if (_modifiedPwdText.text.length == 0) {
                [self setHudWithName:@"请输入你的密码" Time:1 andType:3];
                return;
        }
            if (_verificationText.text.length == 0) {
                [self setHudWithName:@"请输入手机验证码" Time:1 andType:3];
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
                [self prepareDataWithCount:WQUpdateRequest];
    }
}

#pragma mark -- textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 100){//密码
        if ((textField.text.length+string.length-range.length)>20) {
            [self setHudWithName:@"密码是8-20位组成" Time:1 andType:3];
            return NO;
        }
    }
    return YES;
}

#pragma mark comstomized delegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == _modifiedPwdText) {
        if (_modifiedPwdText.text.length >= 20) {
            _modifiedPwdText.text = [_modifiedPwdText.text substringToIndex:20];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
