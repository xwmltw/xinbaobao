//
//  GJJAdultUserOperatorsCreditViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/9.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultUserOperatorsCreditViewController.h"
#import "GJJOperatorsModel.h"
#import "GJJAdultUserInfomationViewController.h"
#import "GJJInfoSuccessHintViewController.h"
#import "GJJMessageVerificationViewController.h"
#import "GJJForgetServicePasswordViewController.h"
#import "GJJOperatorsVerifyModel.h"

typedef NS_ENUM(NSInteger, GJJAdultUserOperatorsCreditRequest) {
    GJJAdultUserOperatorsCreditRequestData,
    GJJAdultUserOperatorsCreditRequestSubmit,
    GJJAdultUserOperatorsCreditRequestMessageCode,
};

@interface GJJAdultUserOperatorsCreditViewController ()
<UITextFieldDelegate>

@end

@implementation GJJAdultUserOperatorsCreditViewController
{
    UITextField *_phoneText;
    UITextField *_operatorsText;
    NSString *_resultNote;
    
    GJJOperatorsModel *_operatorsModel;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resultNote = @"";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prepareDataWithCount:GJJAdultUserOperatorsCreditRequestData];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"手机号", @"服务密码"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    
    UIView *phoneView = [[UIView alloc]init];
    [self.view addSubview:phoneView];
    phoneView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    phoneView.layer.cornerRadius = 5;
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.borderWidth = 0.5;
    phoneView.layer.borderColor = borderColor.CGColor;
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    [phoneView addSubview:phoneLabel];
    phoneLabel.text = @"手机号";
    phoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    phoneLabel.textColor = CCXColorWithHex(@"888888");
    [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(phoneView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _phoneText = [[UITextField alloc]init];
    [phoneView addSubview:_phoneText];
    _phoneText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _phoneText.textColor = CCXColorWithHex(@"888888");
    _phoneText.userInteractionEnabled = NO;
    _phoneText.text = [self getSeccsion].phone;
    [_phoneText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(phoneView);
    }];
    
    UIView *servicePasswordView = [[UIView alloc]init];
    [self.view addSubview:servicePasswordView];
    servicePasswordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    servicePasswordView.layer.cornerRadius = 5;
    servicePasswordView.layer.masksToBounds = YES;
    [servicePasswordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(phoneView.height);
    }];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    [servicePasswordView addSubview:passwordLabel];
    passwordLabel.text = @"服务密码";
    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(servicePasswordView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(servicePasswordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _operatorsText = [[UITextField alloc]init];
    [servicePasswordView addSubview:_operatorsText];
    _operatorsText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _operatorsText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的服务密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _operatorsText.keyboardType = UIKeyboardTypeNumberPad;
    _operatorsText.textColor = CCXColorWithHex(@"888888");
    _operatorsText.delegate = self;
    [_operatorsText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(servicePasswordView);
    }];
    
    [self refreshView];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    certificationButton.layer.masksToBounds = YES;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicePasswordView.bottom).offset(@(AdaptationHeight(50)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
    
    if (!([_operatorsModel.reset_pwd_method integerValue] == 0)) {
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:forgetButton];
        [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetButton setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        [forgetButton addTarget:self action:@selector(forgetPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
        forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(certificationButton.bottom).offset(@(AdaptationHeight(10)));
            make.right.equalTo(certificationButton.right);
            make.width.equalTo(@(AdaptationWidth(120)));
            make.height.equalTo(@(AdaptationHeight(35)));
        }];

    }
    

}

- (void)refreshView
{
    if (_operatorsModel.yyzh.length != 0) {
        _phoneText.text = _operatorsModel.yyzh;
    }else {
        _phoneText.text = [self getSeccsion].phone;
    }
    
    if (_operatorsModel.yymm.length != 0) {
        _operatorsText.text = _operatorsModel.yymm;
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _operatorsText) {
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

#pragma mark - button click

- (void)certificationClick:(UIButton *)sender
{
    if (_resultNote.length > 0) {
        [self setHudWithName:_resultNote Time:1 andType:1];
        return;
    }
    
    if (_operatorsText.text.length == 0) {
        [self setHudWithName:@"请输入服务密码" Time:1 andType:1];
        return;
    }
    
    if (_operatorsText.text.length != 6 && _operatorsText.text.length != 8) {
        [self setHudWithName:@"服务密码为6位或8位" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJAdultUserOperatorsCreditRequestMessageCode];
    
}

- (void)forgetPasswordClick:(UIButton *)sender
{
    GJJForgetServicePasswordViewController *controller = [[GJJForgetServicePasswordViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.title = @"忘记密码";
    controller.operatorsModel = _operatorsModel;
    controller.phone = _phoneText.text;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - request

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultUserOperatorsCreditRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"3"};
    }else if (self.requestCount == GJJAdultUserOperatorsCreditRequestSubmit) {
        self.cmd = GJJAuthenticationCustom;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"authenType":@"2",
                      @"accont":_phoneText.text,
                      @"password":_operatorsText.text};
    }else if (self.requestCount == GJJAdultUserOperatorsCreditRequestMessageCode) {
        self.cmd = GJJOperator;
        self.dict = @{
                      @"phone":_phoneText.text,
                      @"token":_operatorsModel.token?_operatorsModel.token:@"",
                      @"password":_operatorsText.text,
                      @"website":_operatorsModel.website?_operatorsModel.website:@"",
                      @"captcha":@"",
                      @"type":@""
                      };
    
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultUserOperatorsCreditRequestData) {
        _operatorsModel = [GJJOperatorsModel yy_modelWithDictionary:dict];
        while (self.view.subviews.count) {
            [self.view.subviews.lastObject removeFromSuperview];
        }
        [self setupView];
    }else if (self.requestCount == GJJAdultUserOperatorsCreditRequestSubmit) {
        if (_schedule == 8) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            GJJInfoSuccessHintViewController *controller = [[GJJInfoSuccessHintViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.popViewController = self.popViewController;
            controller.title = @"提示";
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (self.requestCount == GJJAdultUserOperatorsCreditRequestMessageCode) {
        GJJOperatorsVerifyModel *model = [GJJOperatorsVerifyModel yy_modelWithDictionary:dict];
        if ([model.process_code integerValue] == 10003) {///服务密码错误
            [self setHudWithName:model.content Time:1 andType:1];
            return;
        }else if ([model.process_code integerValue] == 10008) {///信息正确，开始采集数据
            if (_schedule == 8) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                GJJInfoSuccessHintViewController *controller = [[GJJInfoSuccessHintViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.popViewController = self.popViewController;
                controller.title = @"提示";
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else {
            GJJMessageVerificationViewController *controller = [[GJJMessageVerificationViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"短信验证";
            controller.schedule = _schedule;
            controller.operatorsModel = _operatorsModel;
            controller.phone = _phoneText.text;
            controller.password = _operatorsText.text;
            controller.popViewController = self.popViewController;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultUserOperatorsCreditRequestData) {
        _resultNote = dict[@"resultNote"];
        while (self.view.subviews.count) {
            [self.view.subviews.lastObject removeFromSuperview];
        }
        [self setupView];
    }
    
    NSDictionary *detail = dict[@"detail"];
    if ([detail[@"isToken"] isEqualToString:@"1"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:dict[@"resultNote"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self prepareDataWithCount:GJJAdultUserOperatorsCreditRequestData];
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)BarbuttonClick:(UIButton *)button
{
    [self popToCenterController];
}

- (void)popToCenterController
{
    [self.navigationController popToViewController:self.popViewController animated:YES];
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
