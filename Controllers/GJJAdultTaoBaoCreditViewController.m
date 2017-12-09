//
//  GJJAdultTaoBaoCreditViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultTaoBaoCreditViewController.h"
#import "GJJBasicInfoModel.h"
#import "GJJTaoBaoModel.h"

typedef NS_ENUM(NSInteger, GJJAdultTaoBaoCreditRequest) {
    GJJAdultTaoBaoCreditRequestData,
    GJJAdultTaoBaoCreditRequestSubmit,
};

@interface GJJAdultTaoBaoCreditViewController ()
<MBProgressHUDDelegate>

@end

@implementation GJJAdultTaoBaoCreditViewController
{
    UITextField *_accountText;
    UITextField *_passwordText;
    
    GJJTaoBaoModel *_taoBaoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_model.authenStatus integerValue] != 0) {
        [self prepareDataWithCount:GJJAdultTaoBaoCreditRequestData];
    }else {
        [self setupView];
    }
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultTaoBaoCreditRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"10"};
    }else if (self.requestCount == GJJAdultTaoBaoCreditRequestSubmit) {
        self.cmd = GJJAuthenticationCustom;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"authenType":@"4",
                      @"accont":_accountText.text,
                      @"password":_passwordText.text};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultTaoBaoCreditRequestData) {
        _taoBaoModel = [GJJTaoBaoModel yy_modelWithDictionary:dict];
        [self setupView];
    }else if (self.requestCount == GJJAdultTaoBaoCreditRequestSubmit) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultTaoBaoCreditRequestData) {
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *placeholderColor = CCXColorWithHex(@"cacaca");
    
    UIView *accountView = [[UIView alloc]init];
    [self.view addSubview:accountView];
    accountView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    accountView.layer.cornerRadius = 5;
    accountView.layer.masksToBounds = YES;
    [accountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@22);
        make.left.equalTo(self.view.left).offset(@20);
        make.right.equalTo(self.view.right).offset(@-20);
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    CGFloat nameLabelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont systemFontOfSize:AdaptationWidth(14)] givenText:@"淘宝账号" givenHeight:20]);
    CGFloat IDNumberLabelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont systemFontOfSize:AdaptationWidth(14)] givenText:@"淘宝密码" givenHeight:20]);
    CGFloat maxLabelWidth = MAX(nameLabelWidth, IDNumberLabelWidth);
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [accountView addSubview:accountLabel];
    accountLabel.text = @"淘宝账号";
    accountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    accountLabel.textColor = CCXColorWithHex(@"888888");
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.left).offset(@10);
        make.centerY.equalTo(accountView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _accountText = [[UITextField alloc]init];
    [accountView addSubview:_accountText];
    if (_taoBaoModel) {
        _accountText.text = _taoBaoModel.tbzh;
    }
    _accountText.textColor = CCXColorWithHex(@"888888");
    _accountText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _accountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的淘宝账号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    [_accountText makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(self.view.left).offset(@20);
        make.right.equalTo(self.view.right).offset(@-20);
        make.height.equalTo(accountView.height);
    }];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    [passwordView addSubview:passwordLabel];
    passwordLabel.text = @"淘宝密码";
    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.left).offset(@10);
        make.centerY.equalTo(passwordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _passwordText = [[UITextField alloc]init];
    [passwordView addSubview:_passwordText];
    if (_taoBaoModel) {
        _passwordText.text = _taoBaoModel.tbmm;
    }
    _passwordText.textColor = CCXColorWithHex(@"888888");
    _passwordText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的淘宝密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    [_passwordText makeConstraints:^(MASConstraintMaker *make) {
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
    certificationButton.layer.masksToBounds = YES;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.bottom).offset(@50);
        make.left.equalTo(self.view.left).offset(@20);
        make.right.equalTo(self.view.right).offset(@-20);
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
}

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if (_accountText.text.length == 0) {
        [self setHudWithName:@"请输入您的淘宝账号" Time:1 andType:1];
        return;
    }
    
    if (_passwordText.text.length == 0) {
        [self setHudWithName:@"请输入您的淘宝密码" Time:1 andType:1];
        return;
    }
    [self prepareDataWithCount:GJJAdultTaoBaoCreditRequestSubmit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
