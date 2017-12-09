//
//  GJJAdultAccumulationViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultAccumulationViewController.h"
#import "GJJAccumulationModel.h"

typedef NS_ENUM(NSInteger, GJJAdultAccumulationRequest) {
    GJJAdultAccumulationRequestData,
    GJJAdultAccumulationRequestSubmit,
};

@interface GJJAdultAccumulationViewController ()
<MBProgressHUDDelegate,
UITextFieldDelegate>

@end

@implementation GJJAdultAccumulationViewController
{
    UITextField *_accountText;
    UITextField *_passwordText;
    UITextField *_placeText;
    __block NSString *_province;
    __block NSString *_city;
    __block NSString *_town;
    
    GJJAccumulationModel *_accumulationModel;
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultAccumulationRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"11"};
    }else if (self.requestCount == GJJAdultAccumulationRequestSubmit) {
        self.cmd = GJJSaveXykAndGjj;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"accont":_accountText.text,
                      @"authenType":@"7",
                      @"password":_passwordText.text,
                      @"cityOrbank":_placeText.text};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultAccumulationRequestData) {
        _accumulationModel = [GJJAccumulationModel yy_modelWithDictionary:dict];
        [self setupView];
    }else if (self.requestCount == GJJAdultAccumulationRequestSubmit) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultAccumulationRequestData) {
        [self setupView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_scheduleDict[@"gjjStatus"] integerValue] != 0) {
        [self prepareDataWithCount:GJJAdultAccumulationRequestData];
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
    CGFloat maxLabelWidth = [self calculatorMaxWidthWithString:@[@"账号", @"密码", @"所在省市"]];
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
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [accountView addSubview:accountLabel];
    accountLabel.text = @"账号";
    accountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    accountLabel.textColor = CCXColorWithHex(@"888888");
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.left).offset(@10);
        make.centerY.equalTo(accountView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _accountText = [[UITextField alloc]init];
    [accountView addSubview:_accountText];
    if (_accumulationModel) {
        _accountText.text = _accumulationModel.gjjzh;
    }
    _accountText.textColor = CCXColorWithHex(@"888888");
    _accountText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _accountText.delegate = self;
    _accountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的公积金账号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _accountText.adjustsFontSizeToFitWidth = YES;
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
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.left).offset(@10);
        make.centerY.equalTo(passwordView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _passwordText = [[UITextField alloc]init];
    [passwordView addSubview:_passwordText];
    if (_accumulationModel) {
        _passwordText.text = _accumulationModel.gjjmm;
    }
    _passwordText.textColor = CCXColorWithHex(@"888888");
    _passwordText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _passwordText.delegate = self;
    _passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的公积金密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _accountText.adjustsFontSizeToFitWidth = YES;
    [_passwordText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.right).offset(@10);
        make.top.right.bottom.equalTo(passwordView);
    }];
    
    
    UIView *placeView = [[UIView alloc]init];
    [self.view addSubview:placeView];
    placeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeView.layer.cornerRadius = 5;
    placeView.layer.masksToBounds = YES;
    [placeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.bottom).offset(@10);
        make.left.equalTo(self.view.left).offset(@20);
        make.right.equalTo(self.view.right).offset(@-20);
        make.height.equalTo(accountView.height);
    }];
    
    UILabel *placeLabel = [[UILabel alloc]init];
    [placeView addSubview:placeLabel];
    placeLabel.text = @"所在省市";
    placeLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    placeLabel.textColor = CCXColorWithHex(@"888888");
    [placeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeView.left).offset(@10);
        make.centerY.equalTo(placeView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _placeText = [[UITextField alloc]init];
    [placeView addSubview:_placeText];
    if (_accumulationModel) {
        _placeText.text = _accumulationModel.city;
    }
    _placeText.textColor = CCXColorWithHex(@"888888");
    _placeText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _placeText.delegate = self;
    _placeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入公积金所在的省或市" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _placeText.adjustsFontSizeToFitWidth = YES;
    [_placeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeLabel.right).offset(@10);
        make.top.right.bottom.equalTo(placeView);
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
        make.top.equalTo(placeView.bottom).offset(@50);
        make.left.equalTo(self.view.left).offset(@20);
        make.right.equalTo(self.view.right).offset(@-20);
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
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

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if (_accountText.text.length == 0) {
        [self setHudWithName:@"请输入您的公积金账号" Time:1 andType:1];
        return;
    }
    
    if (_passwordText.text.length == 0) {
        [self setHudWithName:@"请输入您的公积金密码" Time:1 andType:1];
        return;
    }
    
    if (_placeText.text.length == 0) {
        [self setHudWithName:@"请输入公积金所在的省或市" Time:1 andType:1];
        return;
    }
    [self prepareDataWithCount:GJJAdultAccumulationRequestSubmit];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
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
