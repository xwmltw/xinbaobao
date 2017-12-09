//
//  XWMRegisterViewController.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "XWMRegisterViewController.h"
#import "GJJCountDownButton.h"
#import "WQLogViewController.h"
#import "CCXBlockWebViewController.h"
#import "XWMCodeImageView.h"
#import "GJJQueryServiceUrlModel.h"

typedef NS_ENUM(NSInteger,WQModifyPasswordRequest){
    WQRegisterGetValiCodeFromPhone,
    WQRegisterRequest,
    WQLogInRequest,
};
@interface XWMRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UIView *loginView;
@property (nonatomic ,strong) UIImageView *loginImage;
@property (nonatomic ,strong) UIButton *btnBack;
@end

@implementation XWMRegisterViewController
{
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_verificationText;
    GJJCountDownButton *_getVerificationCodeButton;
    NSDictionary *_dicc;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackNavigationBarItem];
     [TalkingData trackEvent:@"注册界面"];
    self.view.backgroundColor =  CCXBackColor;
    [self setUI];
}
- (void)setUI{
    
    //v1.2
    self.btnBack = [[UIButton alloc]init];
    [self.btnBack addTarget:self action:@selector(onBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
    [self.view addSubview:self.btnBack];
    
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"注册"];
//    [self.lblLogin setFont:[UIFont systemFontOfSize: AdaptationWidth(36)]];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [self.lblLogin setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    
    self.loginView  = [[UIView alloc]init];
    self.loginView.backgroundColor = CCXColorWithRGB(255, 226, 134);
    
    self.loginImage  = [[UIImageView alloc]init];
    self.loginImage.image = [UIImage imageNamed:@"Login_tatoo"];
    
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.lblLogin];
    [self.view addSubview:self.loginImage];
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(28);
        make.left.mas_equalTo(self.view).offset(16);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(104);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(50);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.lblLogin);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(23);
    }];
    [self.loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(self.lblLogin);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50);
    }];
    
    
    [self creatTextField];
}
- (void)creatTextField{
    _phoneTextAccount = [[UITextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = CCXBackColor;
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{}];
    if (![[self getSeccsion].phone isEqualToString:@"请登录"]) {
        _phoneTextAccount.text = [self getSeccsion].phone;
        self.phontString = [self getSeccsion].phone;
    }
    _phoneTextAccount.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    _phoneTextAccount.tag = 1;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
   
    [self.view addSubview:_phoneTextAccount];
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
    [lalPhone setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:XWMSCREENSCALE*14]];
    [self.view addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView3];
    
    UILabel *lalVerification = [[UILabel alloc]init];
    [lalVerification setText:@"验证码"];
    [lalVerification setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalVerification setFont:[UIFont systemFontOfSize:XWMSCREENSCALE*14]];
    [self.view addSubview:lalVerification];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"密码"];
    [lalPwd setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:XWMSCREENSCALE*14]];
    [self.view addSubview:lalPwd];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = CCXBackColor;
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{}];
    _verificationText.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.tag = 4;
    [self.view addSubview:_verificationText];
    
    _getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    _getVerificationCodeButton.frame = CCXRectMake(0, 0, 188, 86);
//    [_orangeView addSubview:getVerificationCodeButton];
    [_getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationCodeButton setTitleColor:CCXColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    _getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _verificationText.rightView = _getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [_getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = CCXBackColor;
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{}];
    if ([self getSeccsion].password.length != 0) {
        _pwdTextAccount.text = [self getSeccsion].password;
    }
    _pwdTextAccount.font = [UIFont systemFontOfSize:18*XWMSCREENSCALE];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
    
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_pwdTextAccount];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 10*XWMSCREENSCALE;
    registerButton.clipsToBounds = YES;
    registerButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    registerButton.tag = 300;
    [registerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UILabel *labLoginSure = [[UILabel alloc]init];
    [labLoginSure setText:@"注册即代表您已同意"];
    [labLoginSure setFont:[UIFont systemFontOfSize:AdaptationWidth(13)]];
    [labLoginSure setTextColor:CCXColorWithRBBA(34, 58, 80, 0.32)];
    [self.view addSubview:labLoginSure];
    
    UIButton *btnAgree = [[UIButton alloc]init];
    [btnAgree setTitle:@"「用户协议」" forState:UIControlStateNormal];
    [btnAgree setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
    [btnAgree.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(13)]];
    btnAgree.tag = 7;
    [btnAgree addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAgree];
    
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (OnOff) {
        labLoginSure.hidden = NO;
        btnAgree.hidden = NO;
    }else{
        labLoginSure.hidden = YES;
        btnAgree.hidden = YES;
    }
    
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(AdaptationWidth(32));
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(4);
        make.left.mas_equalTo(lalPhone);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_phoneTextAccount);
        make.height.mas_equalTo(1);
    }];
    [lalVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView);
    }];
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalVerification.mas_bottom).offset(4);
        make.left.mas_equalTo(lalVerification);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_verificationText.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_verificationText);
        make.height.mas_equalTo(1);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView2);
    }];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(4);
        make.left.mas_equalTo(lalPwd);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(43);
    }];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_pwdTextAccount);
        make.height.mas_equalTo(1);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom).offset(AdaptationWidth(24));
        make.left.right.mas_equalTo(lineView3);
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    [btnAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerButton.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(registerButton);
    }];
    [labLoginSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnAgree);
        make.right.mas_equalTo(btnAgree.mas_left).offset(1);
    }];
    
    
}
#pragma mark -btn
- (void)onBtnclick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 10) {//获取验证码
        
        
       
    }else if (btn.tag == 300){//立即注册
        [self.view endEditing:YES];
        if (_verificationText.text.length == 0) {
            [self setHudWithName:@"请输入手机验证码" Time:1 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length == 0){
            [self setHudWithName:@"请输入密码" Time:1 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length<8) {
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return;
        }
        
        NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:_pwdTextAccount.text]){
            [self prepareDataWithCount:WQRegisterRequest];
        }else{
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return;
        }
    }else if (btn.tag == 7){
        CCXBlockWebViewController *controller = [[CCXBlockWebViewController alloc]init];
        controller.url = CCXContract;
        controller.title = [NSString stringWithFormat:@"%@注册协议",APPDEFAULTNAME];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (btn.tag == 100 && !btn.selected){
        UIButton *button = [self.view viewWithTag:200];
        button.selected = !button.selected;
        btn.selected = !btn.selected;
    }else if (btn.tag == 200 && !btn.selected){
        UIButton *button = [self.view viewWithTag:100];
        button.selected = !button.selected;
        btn.selected = !btn.selected;
    }
    
}
- (void)getVerificationCodeClick:(GJJCountDownButton *)sender{
    
    _getVerificationCodeButton = sender;
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = CCXColorWithRBBA(0, 0, 0, 0.5);
    [self.view addSubview:view];
    XWMCodeImageView *codeView = [[XWMCodeImageView alloc]initWithFrame:CGRectZero];
    
    [view addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(272);
        make.height.mas_equalTo(175);
        make.center.mas_equalTo(view);
    }];
    
    WEAKSELF
    codeView.block = ^(UIButton * result) {
        switch (result.tag) {
            case 100:
                
                [weakSelf prepareDataWithCount:WQRegisterGetValiCodeFromPhone];
                view.hidden = YES;
                break;
            case 101:
                view.hidden = YES;
                break;
                
            default:
                break;
        }
    };
    
}
#pragma mark -textField
- (void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
            _phontString = _phoneTextAccount.text;
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
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
#pragma mark -网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    if (self.requestCount == WQRegisterRequest) {
        self.cmd = WQRegister;
        NSString *orgId = @"1";
        //        UIButton *button = (UIButton *)[self.view viewWithTag:100];
        //        if (button.isSelected) {
        //            orgId = @"0";
        //        }else{
        //            orgId = @"1";
        //        }
        self.dict = @{@"orgId": orgId,
                      @"phone": _phontString,
                      @"valiCode":_verificationText.text,
                      //                      @"regCode": _invitationText.text,
                      //                      @"isAgreeContent": @"0",
                      @"password":[self md5:_pwdTextAccount.text],
                      @"type":@"0"};
    }else if (self.requestCount == WQRegisterGetValiCodeFromPhone){
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone" :_phontString,
                      @"userId":@"",
                      @"type"  :@"0"};
    }else if (self.requestCount == WQLogInRequest){
        self.cmd = WQLogin;
        self.dict = @{@"userCode":_phontString,
                      @"passWord":[self md5:_pwdTextAccount.text]};
    }
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    
    
    
    if (self.requestCount == WQRegisterGetValiCodeFromPhone) {
        _dicc = dict;
        [self setHudWithName:@"验证码获取成功" Time:1 andType:0];
        [self beginCountDown];
        
        
    }else if (self.requestCount == WQRegisterRequest){
        
        //talkingdata
        [TalkingData onRegister:dict[@"phone"] type:TDAccountTypeRegistered name:@""];
        
        [self prepareDataWithCount:WQLogInRequest];
    }else if (self.requestCount == WQLogInRequest) {
        NSLog(@"%@", self.popViewController);
        CCXUser *user = [[CCXUser alloc]initWithDictionary:@{
                                                             @"name":dict[@"userCode"],
                                                             @"passWord":_pwdTextAccount.text,
                                                             @"phone":dict[@"phone"],
                                                             @"userId":@"1",
                                                             @"customName":dict[@"customName"],
                                                             @"orgId":[NSString stringWithFormat:@"%@",dict[@"orgId"]],
                                                             @"token":[NSString stringWithFormat:@"%@",dict[@"token"]],
                                                             @"uuid":[NSString stringWithFormat:@"%@",dict[@"uuid"]]
                                                             
                                                             }];
        [self saveSeccionWithUser:user];
        [self.navigationController popToViewController:self.popViewController animated:YES];
    }
}

/**
 网络操作失败
 @param dict 失败之后的数据
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
}

#pragma mark NSTimer
- (void)beginCountDown
{
   
    _getVerificationCodeButton.userInteractionEnabled = NO;
    
    [_getVerificationCodeButton startCountDownWithSecond:60];
    
    [_getVerificationCodeButton countDownChanging:^NSString *(GJJCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
        return title;
    }];
    [_getVerificationCodeButton countDownFinished:^NSString *(GJJCountDownButton *countDownButton, NSUInteger second) {
        _getVerificationCodeButton.userInteractionEnabled = YES;
        return @"未收到？";
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
