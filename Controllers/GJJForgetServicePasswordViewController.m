//
//  GJJForgetServicePasswordViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/4/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJForgetServicePasswordViewController.h"
#import "GJJOperatorsModel.h"
#import "GJJOperatorsVerifyModel.h"
#import "GJJCountDownButton.h"

typedef NS_ENUM(NSInteger, GJJForgetServicePasswordRequest) {
    GJJForgetServicePasswordRequestMessageCode,
};

typedef  NS_ENUM(NSInteger, GJJForgetServicePasswordSubmitOrResend) {
    GJJForgetServicePasswordSubmitPassword,
    GJJForgetServicePasswordResendCode,
};

@interface GJJForgetServicePasswordViewController ()
<UITextFieldDelegate>

@end

@implementation GJJForgetServicePasswordViewController
{
    GJJForgetServicePasswordSubmitOrResend _submitOrResend;
    UITextField *_messageText;
    UITextField *_passwordText;
    UIButton *_getMessageCodeButton;
    
    NSTimer *_timerCode;
    NSTimer *_timerClose;
    NSInteger _timer;
    
    NSInteger _messageCodeCount;
    GJJCountDownButton *_getVerificationButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    [self setupView];
}

- (void)setupData
{
    _submitOrResend = GJJForgetServicePasswordResendCode;
    _messageCodeCount = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    UIColor *textColor = CCXColorWithHex(@"888888");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *sendPhoneLabel = [[UILabel alloc]init];
    [self.view addSubview:sendPhoneLabel];
    NSString *phone = [_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    sendPhoneLabel.text = [NSString stringWithFormat:@"短信发送至%@", phone];
    sendPhoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    sendPhoneLabel.textColor = textColor;
    [sendPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@(AdaptationHeight(35)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(20)));
        make.height.equalTo(@(AdaptationHeight(20)));
    }];
    
    
    GJJCountDownButton *getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    getVerificationCodeButton.backgroundColor = [UIColor clearColor];
    getVerificationCodeButton.layer.cornerRadius = AdaptationWidth(5);
    getVerificationCodeButton.layer.masksToBounds = YES;
    //    [getVerificationCodeButton sizeToFit];
    getVerificationCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
//    [getVerificationCodeButton makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(codeView.right).offset(@(AdaptationWidth(-10)));
//        make.centerY.equalTo(codeView.centerY);
//        make.height.equalTo(codeView.height).multipliedBy(6.0/9);
//        make.width.equalTo(_getCodeButton.height).multipliedBy(2.8);
//    }];

//    _getMessageCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_getMessageCodeButton];
//    [_getMessageCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_getMessageCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
//    _getMessageCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//    _getMessageCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_getMessageCodeButton addTarget:self action:@selector(getMessageCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *messagePasswordView = [[UIView alloc]init];
    [self.view addSubview:messagePasswordView];
    messagePasswordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    messagePasswordView.layer.cornerRadius = 5;
    messagePasswordView.layer.masksToBounds = YES;
    messagePasswordView.layer.borderWidth = 0.5;
    messagePasswordView.layer.borderColor = borderColor.CGColor;
    [messagePasswordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendPhoneLabel.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(sendPhoneLabel.left);
        make.right.equalTo(getVerificationCodeButton.left).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    [getVerificationCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(messagePasswordView);
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-30)));
        make.width.equalTo(self.view).multipliedBy(0.2);
    }];
    
    UIImageView *keyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"code"]];
    [messagePasswordView addSubview:keyImageView];
    [keyImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messagePasswordView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(messagePasswordView.centerY);
        make.size.equalTo(CGSizeMake(AdaptationWidth(12), AdaptationHeight(14)));
    }];
    
    _messageText = [[UITextField alloc]init];
    [messagePasswordView addSubview:_messageText];
    _messageText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _messageText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _messageText.textColor = textColor;
    _messageText.adjustsFontSizeToFitWidth = YES;
    _messageText.keyboardType = UIKeyboardTypeNumberPad;
    [_messageText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keyImageView.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(messagePasswordView);
    }];

    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [certificationButton setTitle:@"确认" forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    certificationButton.layer.masksToBounds = YES;

    //reset_pwd_method == 1时需要短信验证码即可重置密码
    if ([_operatorsModel.reset_pwd_method integerValue] == 1) {
        [certificationButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(messagePasswordView.bottom).offset(@(AdaptationHeight(25)));
            make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
            make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
            make.height.equalTo(self.view.height).multipliedBy(1.0/13);
        }];

    }else {
        UIView *servicePasswordView = [[UIView alloc]init];
        [self.view addSubview:servicePasswordView];
        servicePasswordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
        servicePasswordView.layer.cornerRadius = 5;
        servicePasswordView.layer.masksToBounds = YES;
        servicePasswordView.layer.borderWidth = 0.5;
        servicePasswordView.layer.borderColor = borderColor.CGColor;
        [servicePasswordView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(messagePasswordView.bottom).offset(@(AdaptationHeight(10)));
            make.left.equalTo(sendPhoneLabel.left);
            make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
            make.height.equalTo(self.view.height).multipliedBy(1.0/14);
        }];
        
        UIImageView *lockImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
        [servicePasswordView addSubview:lockImageView];
        [lockImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(servicePasswordView.left).offset(@(AdaptationWidth(10)));
            make.centerY.equalTo(servicePasswordView.centerY);
            make.size.equalTo(CGSizeMake(AdaptationWidth(12), AdaptationHeight(14)));
        }];
        
        UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [servicePasswordView addSubview:eyeButton];
        [eyeButton setImage:[UIImage imageNamed:@"eye2"] forState:UIControlStateNormal];
        [eyeButton setImage:[UIImage imageNamed:@"eye1"] forState:UIControlStateSelected];
        eyeButton.selected = NO;
        [eyeButton addTarget:self action:@selector(showSecurityClick:) forControlEvents:UIControlEventTouchUpInside];
        [eyeButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(servicePasswordView.right).offset(@(AdaptationWidth(-13)));
            make.centerY.equalTo(servicePasswordView.centerY);
            make.width.equalTo(@(AdaptationWidth(45)));
            make.height.equalTo(servicePasswordView);
        }];
        
        _passwordText = [[UITextField alloc]init];
        [servicePasswordView addSubview:_passwordText];
        _passwordText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        _passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设置服务密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
        _passwordText.textColor = textColor;
        _passwordText.adjustsFontSizeToFitWidth = YES;
        _passwordText.secureTextEntry = YES;
        _passwordText.keyboardType = UIKeyboardTypeNumberPad;
        _passwordText.delegate = self;
        [_passwordText makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lockImageView.right).offset(@(AdaptationWidth(10)));
            make.top.bottom.equalTo(servicePasswordView);
            make.right.equalTo(eyeButton.left);
        }];
        
        [certificationButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(servicePasswordView.bottom).offset(@(AdaptationHeight(25)));
            make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
            make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
            make.height.equalTo(self.view.height).multipliedBy(1.0/13);
        }];

    }
}


- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    _submitOrResend = GJJForgetServicePasswordResendCode;
    [self prepareDataWithCount:GJJForgetServicePasswordRequestMessageCode];
    
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



#pragma mark - button click

- (void)showSecurityClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _passwordText.secureTextEntry = NO;
    }else {
        _passwordText.secureTextEntry = YES;
    }
    
    ///这么做避免因为明暗文转换时文字后面多出一块空
    NSString *text = _passwordText.text;
    _passwordText.text = @" ";
    _passwordText.text = text;
}

- (void)getMessageCode
{
    _submitOrResend = GJJForgetServicePasswordResendCode;
    [self prepareDataWithCount:GJJForgetServicePasswordRequestMessageCode];
}

- (void)certificationClick:(UIButton *)sender
{
    _submitOrResend = GJJForgetServicePasswordSubmitPassword;
    if (_messageText.text.length == 0) {
        [self setHudWithName:@"请填写短信验证码" Time:1 andType:1];
        return;
    }
    if ([_operatorsModel.reset_pwd_method integerValue] == 2) {
        if (_passwordText.text.length == 0) {
            [self setHudWithName:@"请填写新的服务密码" Time:1 andType:1];
            return;
        }else if (_passwordText.text.length != 6 && _passwordText.text.length != 8) {
                [self setHudWithName:@"服务密码为6位或8位" Time:1 andType:1];
                return;
        }
    }
    
    [self prepareDataWithCount:GJJForgetServicePasswordRequestMessageCode];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _passwordText) {
        if (textField.text.length >= 8 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        if ([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
        {
            return NO;
        }
        
    }
    return YES;
}

#pragma mark - request

- (void)setRequestParams
{
    if (self.requestCount == GJJForgetServicePasswordRequestMessageCode) {
        self.cmd = GJJOperatorResetServiceNumber;
        if (_submitOrResend == GJJForgetServicePasswordResendCode) {
            if (_messageCodeCount == 0) {
                self.dict = @{
                              @"phone":_phone,
                              @"token":_operatorsModel.token?_operatorsModel.token:@"",
                              @"password":@"",
                              @"website":_operatorsModel.website?_operatorsModel.website:@"",
                              @"captcha":@"",
                              @"reset_pwd_method":_operatorsModel.reset_pwd_method?_operatorsModel.reset_pwd_method:@"",
                              @"type":@""
                              };
            }else {
                self.dict = @{
                              @"phone":_phone,
                              @"token":_operatorsModel.token?_operatorsModel.token:@"",
                              @"password":@"",
                              @"website":_operatorsModel.website?_operatorsModel.website:@"",
                              @"captcha":@"",
                              @"reset_pwd_method":_operatorsModel.reset_pwd_method?_operatorsModel.reset_pwd_method:@"",
                              @"type":@"RESEND_RESET_PWD_CAPTCHA"
                              };
            }
            _messageCodeCount++;
        }else if (_submitOrResend == GJJForgetServicePasswordSubmitPassword) {
            self.dict = @{
                          @"phone":_phone,
                          @"token":_operatorsModel.token,
                          @"password":_passwordText.text,
                          @"website":_operatorsModel.website,
                          @"captcha":_messageText.text,
                          @"reset_pwd_method":_operatorsModel.reset_pwd_method,
                          @"type":@"SUBMIT_RESET_PWD"
                          };
        }
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJForgetServicePasswordRequestMessageCode) {
        if (_submitOrResend == GJJForgetServicePasswordResendCode) {
            [self beginCountDown];
//            _timer = 60;
//            _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//            [_timerCode setFireDate:[NSDate date]];
//            [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
//            _getMessageCodeButton.userInteractionEnabled = NO;
//            _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
//            [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];

        }else if (_submitOrResend == GJJForgetServicePasswordSubmitPassword) {
            GJJOperatorsVerifyModel *model = [GJJOperatorsVerifyModel yy_modelWithDictionary:dict];
            [self setHudWithName:model.content Time:1 andType:0];
            if ([model.process_code integerValue] == 11000) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                return;
            }
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    
    NSDictionary *detail = dict[@"detail"];
    if ([detail[@"isToken"] isEqualToString:@"1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:dict[@"resultNote"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - NSTimer
- (void)timerFired
{
    [_getMessageCodeButton setTitle:[NSString stringWithFormat:@"(%@)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer
{
    _getMessageCodeButton.userInteractionEnabled = YES;
    [_getMessageCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
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
