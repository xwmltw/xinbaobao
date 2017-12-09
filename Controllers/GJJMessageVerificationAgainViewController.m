//
//  GJJMessageVerificationAgainViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/4/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJMessageVerificationAgainViewController.h"
#import "GJJOperatorsModel.h"
#import "GJJOperatorsVerifyModel.h"
#import "GJJInfoSuccessHintViewController.h"
#import "GJJCountDownButton.h"
typedef NS_ENUM(NSInteger, GJJMessageVerificationAgainRequest) {
    GJJMessageVerificationAgainRequestMessageCode,
};

typedef NS_ENUM(NSInteger, GJJMessageVerificationAgainSubmitOrResend) {
    GJJMessageVerificationAgainSubmitPassword,
    GJJMessageVerificationAgainResendPassword,
};

@interface GJJMessageVerificationAgainViewController ()

@end

@implementation GJJMessageVerificationAgainViewController
{
    GJJMessageVerificationAgainSubmitOrResend _submitOrResend;
    UITextField *_messageText;
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
    _submitOrResend = GJJMessageVerificationAgainResendPassword;
    _messageCodeCount = 0;
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
    
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"短信密码"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    
    UILabel *sendPhoneLabel = [[UILabel alloc]init];
    [self.view addSubview:sendPhoneLabel];
    NSString *phone = [_phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    sendPhoneLabel.text = [NSString stringWithFormat:@"发送短信至%@", phone];
    sendPhoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    sendPhoneLabel.textColor = textColor;
    [sendPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@(AdaptationHeight(35)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(20)));
        make.height.equalTo(@(AdaptationHeight(20)));
    }];
    
//    _getMessageCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:_getMessageCodeButton];
//    _getMessageCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//    _getMessageCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_getMessageCodeButton addTarget:self action:@selector(getMessageCode:) forControlEvents:UIControlEventTouchUpInside];
//    [self setupTimerAndButtonTitle];
    _getVerificationButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_getVerificationButton];
    [_getVerificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
    _getVerificationButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    _getVerificationButton.backgroundColor = [UIColor clearColor];
    _getVerificationButton.layer.cornerRadius = AdaptationWidth(5);
    _getVerificationButton.layer.masksToBounds = YES;
    //    [getVerificationCodeButton sizeToFit];
    _getVerificationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_getVerificationButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
        make.right.equalTo(_getVerificationButton.left).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    [_getVerificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(messagePasswordView);
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-30)));
        make.width.equalTo(self.view).multipliedBy(0.2);
    }];
    
    
    UILabel *messagePasswordLabel = [[UILabel alloc]init];
    [messagePasswordView addSubview:messagePasswordLabel];
    messagePasswordLabel.text = @"短信密码";
    messagePasswordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    messagePasswordLabel.textColor = CCXColorWithHex(@"888888");
    [messagePasswordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messagePasswordView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(messagePasswordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _messageText = [[UITextField alloc]init];
    [messagePasswordView addSubview:_messageText];
    _messageText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _messageText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _messageText.textColor = CCXColorWithHex(@"888888");
    _messageText.adjustsFontSizeToFitWidth = YES;
    _messageText.keyboardType = UIKeyboardTypeNumberPad;
    [_messageText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messagePasswordLabel.right).offset(@(AdaptationWidth(10)));
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
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(messagePasswordView.bottom).offset(@(AdaptationHeight(50)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
}

- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    _submitOrResend = GJJMessageVerificationAgainResendPassword;
    [self prepareDataWithCount:GJJMessageVerificationAgainRequestMessageCode];
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
- (void)certificationClick:(UIButton *)sender
{
    if (_messageText.text.length == 0) {
        [self setHudWithName:@"请输入短信验证码" Time:1 andType:1];
        return;
    }
    _submitOrResend = GJJMessageVerificationAgainSubmitPassword;
    [self prepareDataWithCount:GJJMessageVerificationAgainRequestMessageCode];
}

- (void)getMessageCode:(UIButton *)sender
{
    _submitOrResend = GJJMessageVerificationAgainResendPassword;
    [self prepareDataWithCount:GJJMessageVerificationAgainRequestMessageCode];
}

#pragma mark - request
- (void)setRequestParams
{
    if (self.requestCount == GJJMessageVerificationAgainRequestMessageCode) {
        self.cmd = GJJOperator;
        if (_submitOrResend == GJJMessageVerificationAgainResendPassword) {
            if (_messageCodeCount == 0) {
                self.dict = @{
                              @"phone":_phone,
                              @"token":_operatorsModel.token,
                              @"password":_password,
                              @"website":_operatorsModel.website,
                              @"captcha":@"",
                              @"type":@""
                              };
            }else {
                self.dict = @{
                              @"phone":_phone,
                              @"token":_operatorsModel.token,
                              @"password":_password,
                              @"website":_operatorsModel.website,
                              @"captcha":@"",
                              @"type":@"RESEND_CAPTCHA"
                              };
            }
            _messageCodeCount++;
        }else if (_submitOrResend == GJJMessageVerificationAgainSubmitPassword) {
            self.dict = @{
                          @"phone":_phone,
                          @"token":_operatorsModel.token,
                          @"password":_password,
                          @"website":_operatorsModel.website,
                          @"captcha":_messageText.text,
                          @"type":@"SUBMIT_CAPTCHA"
                          };
            
        }
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJMessageVerificationAgainRequestMessageCode) {
        if (_submitOrResend == GJJMessageVerificationAgainResendPassword) {
//            [self setupTimerAndButtonTitle];
            [self beginCountDown];
        }else if (_submitOrResend == GJJMessageVerificationAgainSubmitPassword) {
            GJJOperatorsVerifyModel *model = [GJJOperatorsVerifyModel yy_modelWithDictionary:dict];
            if ([model.process_code integerValue] == 10008) {
                
                if (_schedule == 8) {
                    [self.navigationController popToViewController:self.popViewController animated:YES];
                }else {
                    GJJInfoSuccessHintViewController *controller = [[GJJInfoSuccessHintViewController alloc]init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.popViewController = self.popViewController;
                    controller.title = @"提示";
                    [self.navigationController pushViewController:controller animated:YES];
                }
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
            [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - NSTimer
- (void)setupTimerAndButtonTitle
{
    _timer = 60;
    _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [_timerCode setFireDate:[NSDate date]];
    [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
    _getMessageCodeButton.userInteractionEnabled = NO;
    [_getMessageCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];
    
}

- (void)timerFired
{
    [_getMessageCodeButton setTitle:[NSString stringWithFormat:@"(%@)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer
{
    _getMessageCodeButton.userInteractionEnabled = YES;
    [_getMessageCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getMessageCodeButton setTitleColor:[UIColor colorWithHexString:GJJMainColorString] forState:UIControlStateNormal];
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
