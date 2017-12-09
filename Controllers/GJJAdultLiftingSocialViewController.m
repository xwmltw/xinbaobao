//
//  GJJAdultLiftingSocialViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultLiftingSocialViewController.h"
#import "GJJSocialModel.h"

typedef NS_ENUM(NSInteger, GJJAdultLiftingSocialRequest) {
    GJJAdultLiftingSocialRequestData,
    GJJAdultLiftingSocialRequestSubmit,
};

@interface GJJAdultLiftingSocialViewController ()

@end

@implementation GJJAdultLiftingSocialViewController
{
    UITextField *_phoneText;
    UITextField *_operatorsText;
    
    GJJSocialModel *_socialModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([_scheduleDict[@"sjStatus"] integerValue] != 0) {
        [self prepareDataWithCount:GJJAdultLiftingSocialRequestData];
    }else {
        [self setupView];
    }
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"QQ号", @"微信号"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
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
    phoneLabel.text = @"QQ号";
    phoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    phoneLabel.textColor = CCXColorWithHex(@"888888");
    [phoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(phoneView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _phoneText = [[UITextField alloc]init];
    [phoneView addSubview:_phoneText];
    if (_socialModel) {
        _phoneText.text = _socialModel.qqzh;
    }
    _phoneText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的QQ号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _phoneText.textColor = CCXColorWithHex(@"888888");
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
    passwordLabel.text = @"微信号";
    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(servicePasswordView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(servicePasswordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _operatorsText = [[UITextField alloc]init];
    [servicePasswordView addSubview:_operatorsText];
    if (_socialModel) {
        _operatorsText.text = _socialModel.wxzh;
    }
    _operatorsText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _operatorsText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的微信号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _operatorsText.textColor = CCXColorWithHex(@"888888");
    [_operatorsText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(servicePasswordView);
    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
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
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _operatorsText) {
        if (textField.text.length >= 6 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)certificationClick:(UIButton *)sender
{
    if (_phoneText.text.length == 0) {
        [self setHudWithName:@"请输入QQ号" Time:1 andType:1];
        return;
    }
    
    if (_operatorsText.text.length == 0) {
        [self setHudWithName:@"请输入微信号" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJAdultLiftingSocialRequestSubmit];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultLiftingSocialRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"8"};
    }else if (self.requestCount == GJJAdultLiftingSocialRequestSubmit) {
        self.cmd = GJJAuthenticationCustom;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"authenType":@"1",
                      @"accont":_phoneText.text,
                      @"password":_operatorsText.text};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultLiftingSocialRequestData) {
        _socialModel = [GJJSocialModel yy_modelWithDictionary:dict];
        [self setupView];
    }else if (self.requestCount == GJJAdultLiftingSocialRequestSubmit) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultLiftingSocialRequestData) {
        [self setupView];
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
