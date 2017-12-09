//
//  GJJSelfInfomationViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/8.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJSelfInfomationViewController.h"
#import "GJJChooseCityView.h"
#import "GJJCertIdSchoolModel.h"
#import "GJJSearchSchoolModel.h"
#import "GJJSearchSchoolViewController.h"
#import "GJJUserOperatorsCreditViewController.h"
#import "GJJSelfInfoModel.h"

typedef NS_ENUM(NSInteger, GJJSelfInfomationRequest){
    GJJSelfInfomationRequestData,
    GJJSelfInfomationRequestAuthentication,
};

@interface GJJSelfInfomationViewController ()
<GJJChooseCityViewDelegate>

@end

@implementation GJJSelfInfomationViewController
{
    GJJCertIdSchoolModel *_schoolModel;
    UILabel *_schoolNameLabel;
    UILabel *_choosePlaceLabel;
    UITextField *_bedroomAddressText;
    GJJChooseCityView *_chooseCityView;
    NSString *_province;
    NSString *_city;
    NSString *_town;
    UITextField *_accountTextField;
    UITextField *_passwordTextField;
    
    GJJSelfInfoModel *_selfInfoModel;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareDataWithCount:GJJSelfInfomationRequestData];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"学校名称", @"学校名称", @"寝室地址"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    
    UIView *nameView = [[UIView alloc]init];
    [self.view addSubview:nameView];
    nameView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    nameView.layer.cornerRadius = 5;
    nameView.layer.masksToBounds = YES;
    nameView.layer.borderWidth = 0.5;
    nameView.layer.borderColor = borderColor.CGColor;
    [nameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameView addSubview:nameLabel];
    nameLabel.text = @"学校名称";
    nameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    nameLabel.textColor = CCXColorWithHex(@"888888");
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(nameView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _schoolNameLabel = [[UILabel alloc]init];
    _schoolNameLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _schoolNameLabel.adjustsFontSizeToFitWidth = YES;
    [nameView addSubview:_schoolNameLabel];
    if (_selfInfoModel.schoolName.length != 0) {
        _schoolNameLabel.text = _selfInfoModel.schoolName;
        _schoolNameLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _schoolNameLabel.text = @"请输入您的学校名称";
        _schoolNameLabel.textColor = placeholderColor;
    }
    _schoolNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *searchSchoolTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToSearchSchoolController)];
    [_schoolNameLabel addGestureRecognizer:searchSchoolTap];
    [_schoolNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(nameView);
    }];
    
    UIView *placeView = [[UIView alloc]init];
    [self.view addSubview:placeView];
    placeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeView.layer.cornerRadius = 5;
    placeView.layer.masksToBounds = YES;
    [placeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(nameView.height);
    }];
    
    UILabel *placeLabel = [[UILabel alloc]init];
    [placeView addSubview:placeLabel];
    placeLabel.text = @"所在省市";
    placeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    placeLabel.textColor = CCXColorWithHex(@"888888");
    [placeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(placeView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _choosePlaceLabel = [[UILabel alloc]init];
    [placeView addSubview:_choosePlaceLabel];
    _choosePlaceLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _choosePlaceLabel.adjustsFontSizeToFitWidth = YES;
    if (_selfInfoModel.province.length != 0) {
        _choosePlaceLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _selfInfoModel.province, _selfInfoModel.city, _selfInfoModel.town];
        _choosePlaceLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _choosePlaceLabel.text = @"请选择学校所在省市区";
        _choosePlaceLabel.textColor = placeholderColor;
    }
    _choosePlaceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *choosePlaceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePlace)];
    [_choosePlaceLabel addGestureRecognizer:choosePlaceTap];
    [_choosePlaceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(placeView);
    }];
    
    UIView *dormitoryView = [[UIView alloc]init];
    [self.view addSubview:dormitoryView];
    dormitoryView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    dormitoryView.layer.cornerRadius = 5;
    dormitoryView.layer.masksToBounds = YES;
    [dormitoryView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(nameView.height);
    }];
    
    UILabel *dormitoryLabel = [[UILabel alloc]init];
    [dormitoryView addSubview:dormitoryLabel];
    dormitoryLabel.text = @"寝室地址";
    dormitoryLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    dormitoryLabel.textColor = CCXColorWithHex(@"888888");
    [dormitoryLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dormitoryView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(dormitoryView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _bedroomAddressText = [[UITextField alloc]init];
    [dormitoryView addSubview:_bedroomAddressText];
    if (_selfInfoModel.bedRoomAddress.length != 0) {
        _bedroomAddressText.text = _selfInfoModel.bedRoomAddress;
    }
    _bedroomAddressText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _bedroomAddressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的寝室地址" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _bedroomAddressText.textColor = CCXColorWithHex(@"888888");
    [_bedroomAddressText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dormitoryLabel.right).offset(@10);
        make.top.right.bottom.equalTo(dormitoryView);
    }];
    
    CGFloat maxXXWLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"学信网账号", @"学信网密码"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    
    UIView *accountView = [[UIView alloc]init];
    [self.view addSubview:accountView];
    accountView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    accountView.layer.cornerRadius = 5;
    accountView.layer.masksToBounds = YES;
    accountView.layer.borderWidth = 0.5;
    accountView.layer.borderColor = borderColor.CGColor;
    [accountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dormitoryView.bottom).offset(@(AdaptationHeight(20)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(nameView);
    }];

    UILabel *accountLabel = [[UILabel alloc]init];
    [accountView addSubview:accountLabel];
    accountLabel.text = @"学信网账号";
    accountLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    accountLabel.textColor = CCXColorWithHex(@"888888");
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(accountView.centerY);
        make.width.equalTo(maxXXWLabelWidth);
    }];
    
    UIImageView *questionMarkImageView = [[UIImageView alloc]init];
    [accountView addSubview:questionMarkImageView];
    questionMarkImageView.userInteractionEnabled = YES;
    questionMarkImageView.image = [UIImage imageNamed:@"学生信息问号"];
    UITapGestureRecognizer *questionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQuestionMark)];
    [questionMarkImageView addGestureRecognizer:questionTap];
    [questionMarkImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(accountView);
        make.right.equalTo(accountView).offset(@(AdaptationWidth(-10)));
        make.size.equalTo(CGSizeMake(AdaptationWidth(16), AdaptationWidth(16)));
    }];
    
    _accountTextField = [[UITextField alloc]init];
    [accountView addSubview:_accountTextField];
    if (_selfInfoModel.xjzh.length != 0) {
        _accountTextField.text = _selfInfoModel.xjzh;
    }
    _accountTextField.textColor = CCXColorWithHex(@"888888");
    _accountTextField.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的学信网账号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(accountView);
        make.right.equalTo(questionMarkImageView.left).offset(@(AdaptationWidth(-10)));
    }];

    UIView *passwordView = [[UIView alloc]init];
    [self.view addSubview:passwordView];
    passwordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    passwordView.layer.cornerRadius = 5;
    passwordView.layer.masksToBounds = YES;
    passwordView.layer.borderWidth = 0.5;
    passwordView.layer.borderColor = borderColor.CGColor;
    [passwordView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.bottom).offset(@(AdaptationHeight(20)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(nameView);
    }];

    UILabel *passwordLabel = [[UILabel alloc]init];
    [passwordView addSubview:passwordLabel];
    passwordLabel.text = @"学信网密码";
    passwordLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    passwordLabel.textColor = CCXColorWithHex(@"888888");
    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(passwordView.centerY);
        make.width.equalTo(maxXXWLabelWidth);
    }];
    
    _passwordTextField = [[UITextField alloc]init];
    [passwordView addSubview:_passwordTextField];
    if (_selfInfoModel.xjmm.length != 0) {
        _passwordTextField.text = _selfInfoModel.xjmm;
    }
    _passwordTextField.textColor = CCXColorWithHex(@"888888");
    _passwordTextField.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的学信网密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordLabel.right).offset(@(AdaptationWidth(10)));
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
        make.top.equalTo(passwordView.bottom).offset(@(AdaptationHeight(50)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
    
//    if (_schedule != 8) {
//        _scheduleProgressView = [[UIProgressView alloc]init];
//        [self.view addSubview:_scheduleProgressView];
//        _scheduleProgressView.progressImage = [GJJAppUtils imageWithColor:[UIColor colorWithHexString:GJJMainColorString] cornerRadius:AdaptationHeight(5)];
//        _scheduleProgressView.trackTintColor = [UIColor colorWithHexString:@"999897"];
//        [_scheduleProgressView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.equalTo(10);
//        }];
//        
//        _scheduleProgressLabel = [[UILabel alloc]init];
//        [self.view addSubview:_scheduleProgressLabel];
//        _scheduleProgressLabel.textColor = [UIColor colorWithHexString:@"414044"];
//        _scheduleProgressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//        _scheduleProgressLabel.textAlignment = NSTextAlignmentCenter;
//        [_scheduleProgressLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.height.equalTo(@(AdaptationHeight(20)));
//            make.bottom.equalTo(_scheduleProgressView.top).offset(@(-6));
//        }];
//        
//        _scheduleProgressView.progress = 0.75;
//        _scheduleProgressLabel.text = @"75%";
//    }
}

#pragma mark - UITapGestureRecognizer
- (void)pushToSearchSchoolController
{
    GJJSearchSchoolViewController *controller = [[GJJSearchSchoolViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.title = @"搜索学校";
    [self.navigationController pushViewController:controller animated:YES];
    controller.returnTextBlock = ^(GJJSearchSchoolModel *schoolModel){
        _schoolNameLabel.text = schoolModel.schoolName;
        _schoolNameLabel.textColor = CCXColorWithHex(@"888888");
    };
}

- (void)choosePlace
{
    _chooseCityView = [[GJJChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseCityView.delegate = self;
    [_chooseCityView showView];
}

- (void)tapQuestionMark
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"学信网账号是什么？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开学信网" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //打开学信网
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://my.chsi.com.cn/archive/index.jsp"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - GJJChooseCityViewDelegate
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(GJJChooseCityView *)chooseView
{
    _province = province;
    _city = city;
    _town = town;
    
    _choosePlaceLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _province, _city, _town];
    _choosePlaceLabel.textColor = CCXColorWithHex(@"888888");
}

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if ([_schoolNameLabel.text isEqualToString:@"请输入您的学校名称"]) {
        [self setHudWithName:@"请输入您的学校名称" Time:1 andType:1];
        return;
    }
    
    if ([_choosePlaceLabel.text isEqualToString:@"请选择学校所在省市区"]) {
        [self setHudWithName:@"请选择学校所在省市区" Time:1 andType:1];
        return;
    }
    
    if (_bedroomAddressText.text.length == 0) {
        [self setHudWithName:@"请输入您的寝室地址" Time:1 andType:1];
        return;
    }
    
    if (_accountTextField.text.length == 0) {
        [self setHudWithName:@"请输入您的学信网账号" Time:1 andType:1];
        return;
    }
    
    if (_passwordTextField.text.length == 0) {
        [self setHudWithName:@"请输入您的学信网密码" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJSelfInfomationRequestAuthentication];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJSelfInfomationRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"1"};
    }else if (self.requestCount == GJJSelfInfomationRequestAuthentication) {
        self.cmd = GJJAuthenticationSchool;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"schoolName":_schoolNameLabel.text,
                      @"province":_province,
                      @"city":_city,
                      @"town":_town,
                      @"bedRoomAddress":_bedroomAddressText.text,
                      @"xxwzh":_accountTextField.text,
                      @"xxwmm":_passwordTextField.text
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJSelfInfomationRequestData) {
        _selfInfoModel = [GJJSelfInfoModel yy_modelWithDictionary:dict];
        _province = _selfInfoModel.province;
        _city = _selfInfoModel.city;
        _town = _selfInfoModel.town;
        [self setupView];
    }else if (self.requestCount == GJJSelfInfomationRequestAuthentication) {
        if (_schedule == 8) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            GJJUserOperatorsCreditViewController *controller = [[GJJUserOperatorsCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"运营商认证";
            controller.popViewController = self.popViewController;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJSelfInfomationRequestData) {
        [self setupView];
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
