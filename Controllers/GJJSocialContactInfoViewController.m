//
//  GJJSocialContactInfoViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/1/10.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJSocialContactInfoViewController.h"
#import "WQRedrawTextfield.h"
#import "GJJSocialModel.h"
#import "IQKeyboardManager.h"

typedef NS_ENUM(NSInteger, GJJSocialContactInfoRequest) {
    GJJSocialContactInfoRequestData,
    GJJSocialContactInfoRequestSubmit,
};

@interface GJJSocialContactInfoViewController ()<UITextFieldDelegate>

@end

@implementation GJJSocialContactInfoViewController
{
    UILabel *_txAccountLabel;
    UILabel *_wxAccountLabel;
    
    UIView *_inputView;
    WQRedrawTextfield *_accountText;
    BOOL _isTXAccount;
    
    GJJSocialModel *_socialModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
//    if ([_scheduleDict[@"sjStatus"] integerValue] != 0) {
        [self prepareDataWithCount:GJJSocialContactInfoRequestData];
//    }else {
//        [self setupView];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification center
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    
    if (_isTXAccount) {
        if (_socialModel.qqzh.length > 0) {
            _accountText.text = _socialModel.qqzh;
        }
    }else {
        if (_socialModel.wxzh.length > 0) {
            _accountText.text = _socialModel.wxzh;
        }
    }
    
    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    //获取键盘的高度
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //判断视图是否被键盘遮挡住了
    if (height>0) {
        // 修改边距约束
        [_inputView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-height);
        }];
        
        // 更新约束
        [UIView animateWithDuration:keyboardDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改为以前的约束（距下边距0）
    [_inputView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self endInput];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}



- (void)setupData
{
    _isTXAccount = YES;
}

- (void)setRequestParams
{
    if (self.requestCount == GJJSocialContactInfoRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"8"};
    }else if (self.requestCount == GJJSocialContactInfoRequestSubmit) {
        [_accountText resignFirstResponder];
        if (_isTXAccount) {
            self.cmd = GJJAuthenticationCustom;
            self.dict = @{@"userId":[self getSeccsion].userId,
                          @"authenType":@"1",
                          @"accont":_accountText.text,
                          @"password":@""};
        }else {
            self.cmd = GJJAuthenticationCustom;
            self.dict = @{@"userId":[self getSeccsion].userId,
                          @"authenType":@"1",
                          @"accont":@"",
                          @"password":_accountText.text};
        }
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJSocialContactInfoRequestData) {
        _socialModel = [GJJSocialModel yy_modelWithDictionary:dict];
        [self setupView];
    }else if (self.requestCount == GJJSocialContactInfoRequestSubmit) {
        if (_isTXAccount) {
            _txAccountLabel.text = _accountText.text;
            _txAccountLabel.textColor = CCXColorWithHex(@"666666");
            _socialModel.qqzh = _txAccountLabel.text;
        }else {
            _wxAccountLabel.text = _accountText.text;
            _wxAccountLabel.textColor = CCXColorWithHex(@"666666");
            _socialModel.wxzh = _wxAccountLabel.text;
        }
        [self endInput];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJSocialContactInfoRequestData) {
        [self setupView];
    }else {
        [self endInput];
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
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [self.view addSubview:hintLabel];
    hintLabel.text = @"注：点击昵称可更换已绑定社交账号";
    hintLabel.textColor = CCXColorWithHex(@"999999");
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(12)];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(25)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-25)));
    }];
    
    UIImageView *txImageView = [[UIImageView alloc]init];
    [self.view addSubview:txImageView];
    txImageView.image = [UIImage imageNamed:@"QQImage"];
    txImageView.layer.cornerRadius = AdaptationWidth(45) / 2.0;
    txImageView.layer.masksToBounds = YES;
    [txImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel).offset(@(AdaptationHeight(50)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(50)));
        make.size.equalTo(CGSizeMake(AdaptationWidth(45), AdaptationWidth(45)));
    }];
    
    UIView *txInfoView = [[UIView alloc]init];
    [self.view addSubview:txInfoView];
    txInfoView.backgroundColor = [UIColor clearColor];
    [txInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(txImageView);
        make.left.equalTo(txImageView.right).offset(@(AdaptationWidth(30)));
        make.right.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *txTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputTXAccount)];
    [txInfoView addGestureRecognizer:txTap];
    
    UILabel *txLabel = [[UILabel alloc]init];
    [txInfoView addSubview:txLabel];
    txLabel.text = @"腾讯";
    txLabel.textColor = CCXColorWithHex(@"666666");
    txLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [txLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txInfoView.top).offset(@(AdaptationHeight(2)));
        make.left.right.equalTo(txInfoView);
        make.height.equalTo(@(AdaptationHeight(20)));
    }];
    
    _txAccountLabel = [[UILabel alloc]init];
    [txInfoView addSubview:_txAccountLabel];
    if (_socialModel.qqzh.length > 0) {
        _txAccountLabel.text = _socialModel.qqzh;
        _txAccountLabel.textColor = CCXColorWithHex(@"666666");
    }else {
        _txAccountLabel.text = @"[绑定账号]";
        _txAccountLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
    }
    _txAccountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [_txAccountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txLabel.bottom).offset(@(AdaptationHeight(2)));
        make.left.right.height.equalTo(txLabel);
    }];
    
    UIImageView *wxImageView = [[UIImageView alloc]init];
    [self.view addSubview:wxImageView];
    wxImageView.image = [UIImage imageNamed:@"wenxinImage"];
    wxImageView.layer.cornerRadius = AdaptationWidth(45) / 2.0;
    wxImageView.layer.masksToBounds = YES;
    [wxImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txImageView.bottom).offset(@(AdaptationHeight(35)));
        make.left.equalTo(txImageView);
        make.size.equalTo(txImageView);
    }];
    
    UIView *wxInfoView = [[UIView alloc]init];
    [self.view addSubview:wxInfoView];
    wxInfoView.backgroundColor = [UIColor clearColor];
    [wxInfoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(txInfoView.bottom).offset(@(AdaptationHeight(35)));
        make.left.right.height.equalTo(txInfoView);
    }];
    
    UITapGestureRecognizer *wxTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inputWXAccount)];
    [wxInfoView addGestureRecognizer:wxTap];
    
    UILabel *wxLabel = [[UILabel alloc]init];
    [wxInfoView addSubview:wxLabel];
    wxLabel.text = @"微信";
    wxLabel.textColor = CCXColorWithHex(@"666666");
    wxLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [wxLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxInfoView.top).offset(@(AdaptationHeight(2)));
        make.left.right.equalTo(wxInfoView);
        make.height.equalTo(@(AdaptationHeight(20)));
    }];
    
    _wxAccountLabel = [[UILabel alloc]init];
    [wxInfoView addSubview:_wxAccountLabel];
    if (_socialModel.wxzh.length > 0) {
        _wxAccountLabel.text = _socialModel.wxzh;
        _wxAccountLabel.textColor = CCXColorWithHex(@"666666");
    }else {
        _wxAccountLabel.text = @"[绑定账号]";
        _wxAccountLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
    }
    _wxAccountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [_wxAccountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxLabel.bottom).offset(@(AdaptationHeight(2)));
        make.left.right.height.equalTo(wxLabel);
    }];
    
    _inputView = [[UIView alloc]init];
    [self.view addSubview:_inputView];
    _inputView.backgroundColor = CCXColorWithHex(@"e5e5e5");
    _inputView.hidden = YES;
    [_inputView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(AdaptationHeight(45)));
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [_inputView addSubview:accountLabel];
    accountLabel.text = @"账号";
    accountLabel.textColor = CCXColorWithHex(@"959595");
    accountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputView).offset(@(AdaptationWidth(30)));
        make.top.bottom.equalTo(_inputView);
        make.width.equalTo(@(AdaptationWidth(35)));
    }];
    
    _accountText = [[WQRedrawTextfield alloc]init];
    [_inputView addSubview:_accountText];
    _accountText.placeholder = @"请输入您的账号";
    _accountText.backgroundColor = [UIColor whiteColor];
    _accountText.layer.cornerRadius = AdaptationWidth(4);
    _accountText.layer.masksToBounds = YES;
    _accountText.leftOffset = AdaptationWidth(10);
    _accountText.delegate = self;
    [_accountText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.right).offset(@(AdaptationWidth(18)));
        make.centerY.equalTo(_inputView);
        make.height.equalTo(@(AdaptationHeight(28)));
        make.width.equalTo(_inputView).multipliedBy(0.48);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputView addSubview:sureButton];
    sureButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = AdaptationWidth(4);
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_inputView).offset(@(AdaptationWidth(-15)));
        make.centerY.equalTo(_inputView);
        make.height.equalTo(_accountText);
        make.width.equalTo(@(AdaptationWidth(50)));
    }];
}

#pragma mark - UITapGestureRecognizer
- (void)inputTXAccount
{
    _isTXAccount = YES;
    _inputView.hidden = NO;
    _accountText.keyboardType = UIKeyboardTypeNumberPad;
    if (![_txAccountLabel.text isEqualToString:@"[绑定账号]"]) {
        _accountText.text = _txAccountLabel.text;
    }else {
        _accountText.text = @"";
    }
    [_accountText becomeFirstResponder];
}

- (void)inputWXAccount
{
    _isTXAccount = NO;
    _inputView.hidden = NO;
    _accountText.keyboardType = UIKeyboardTypeDefault;
    if (![_wxAccountLabel.text isEqualToString:@"[绑定账号]"]) {
        _accountText.text = _wxAccountLabel.text;
    }else {
        _accountText.text = @"";
    }
    [_accountText becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endInput];
}

- (void)endInput
{
    _inputView.hidden = YES;
    [_accountText resignFirstResponder];
}

#pragma button click
- (void)sureClick
{
    if (_accountText.text.length == 0) {
        [self setHudWithName:@"请填写账号" Time:1 andType:1];
        return;
    }
    [self prepareDataWithCount:GJJSocialContactInfoRequestSubmit];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "] || [string isEqualToString:@"\n"]) {
        return NO;
    }
    
    return YES;
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
