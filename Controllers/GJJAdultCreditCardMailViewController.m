//
//  GJJAdultCreditCardMailViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultCreditCardMailViewController.h"
#import "GJJBasicInfoModel.h"
#import "GJJAdultCreditMailModel.h"

typedef NS_ENUM(NSInteger, GJJAdultCreditCardMailRequest) {
    GJJAdultCreditCardMailRequestData,
    GJJAdultCreditCardMailRequestSubmit,
};

@interface GJJAdultCreditCardMailViewController ()
<MBProgressHUDDelegate>

@end

@implementation GJJAdultCreditCardMailViewController
{
    UITextField *_accountTextField;
    UITextField *_passwordTextField;
    GJJAdultCreditMailModel *_mailModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setModel:(GJJBasicInfoModel *)model
{
    _model = model;
    if ([_model.authenStatus isEqualToString:@"0"]) {
        [self setupView];
    }else {
        [self prepareDataWithCount:GJJAdultCreditCardMailRequestData];
    }
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultCreditCardMailRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"7"};
    }else if (self.requestCount == GJJAdultCreditCardMailRequestSubmit) {
        self.cmd = GJJAuthenticationCustom;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"authenType":@"5",
                      @"accont":_accountTextField.text,
                      @"password":_passwordTextField.text};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultCreditCardMailRequestData) {
        _mailModel = [GJJAdultCreditMailModel yy_modelWithDictionary:dict];
        [self setupView];
    }else if (self.requestCount == GJJAdultCreditCardMailRequestSubmit) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultCreditCardMailRequestData) {
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
    CGFloat maxLabelWidth = [self calculatorMaxWidthWithString:@[@"邮箱账号", @"登录密码"]];
    UIColor *placeholderColor = CCXColorWithHex(@"cacaca");
    
    UIView *accountView = [[UIView alloc]init];
    [self.view addSubview:accountView];
    accountView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    accountView.layer.cornerRadius = 5;
    accountView.layer.masksToBounds = YES;
    [accountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@22);
        make.left.equalTo(self.view.left).offset(@15);
        make.right.equalTo(self.view.right).offset(@-15);
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [accountView addSubview:accountLabel];
    accountLabel.text = @"邮箱账号";
    accountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    accountLabel.textColor = CCXColorWithHex(@"888888");
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.left).offset(@10);
        make.centerY.equalTo(accountView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _accountTextField = [[UITextField alloc]init];
    [accountView addSubview:_accountTextField];
    _accountTextField.textColor = CCXColorWithHex(@"888888");
    _accountTextField.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您信用卡绑定的邮箱账号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    if (_mailModel) {
        _accountTextField.text = _mailModel.xykyx;
    }
    _accountTextField.adjustsFontSizeToFitWidth = YES;
    _accountTextField.minimumFontSize = AdaptationWidth(12);
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.right).offset(@10);
        make.top.right.bottom.equalTo(accountView);
    }];
    
    UIView *passwordView = [[UIView alloc]init];
    [self.view addSubview:passwordView];
    passwordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    passwordView.layer.cornerRadius = 5;
    passwordView.layer.masksToBounds = YES;
    [passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.bottom).offset(@10);
        make.left.equalTo(self.view.left).offset(@15);
        make.right.equalTo(self.view.right).offset(@-15);
        make.height.equalTo(accountView.height);
    }];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    [passwordView addSubview:passwordLabel];
    passwordLabel.text = @"登录密码";
    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.left).offset(@10);
        make.centerY.equalTo(passwordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _passwordTextField = [[UITextField alloc]init];
    [passwordView addSubview:_passwordTextField];
    _passwordTextField.textColor = CCXColorWithHex(@"888888");
    _passwordTextField.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    if (_mailModel) {
        _passwordTextField.text = _mailModel.yxmm;
    }
    _passwordTextField.adjustsFontSizeToFitWidth = YES;
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.right).offset(@10);
        make.top.right.bottom.equalTo(passwordView);
    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.bottom).offset(@50);
        make.left.equalTo(self.view.left).offset(@15);
        make.right.equalTo(self.view.right).offset(@-15);
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
}

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if (_accountTextField.text.length == 0) {
        [self setHudWithName:@"请输入您信用卡绑定的邮箱账号" Time:1 andType:1];
        return;
    }
    
    if (_passwordTextField.text.length == 0) {
        [self setHudWithName:@"请输入您的邮箱密码" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJAdultCreditCardMailRequestSubmit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)calculatorMaxWidthWithString:(NSArray *)stringArray
{
    NSMutableArray *widthArray = [NSMutableArray array];
    for (NSString *str in stringArray) {
        CGFloat labelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont systemFontOfSize:AdaptationWidth(14)] givenText:str givenHeight:20]);
        [widthArray addObject:@(labelWidth)];
    }
    
    CGFloat maxLabelWidth = [[widthArray valueForKeyPath:@"@max.doubleValue"] doubleValue];
    return maxLabelWidth;
}

#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
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
