#import "WQLogViewController.h"
#import "XWMRegisterViewController.h"
#import "WQModifyPasswordViewController.h"
#import "WQRedrawTextfield.h"
#import "GJJCountDownButton.h"
#import "GJJQueryServiceUrlModel.h"

typedef NS_ENUM(NSInteger,WQLogInRequest){
    WQAccountLogInRequest,
    WQQuickLogInRequest,
    WQQuickGetValiCodeFromPhone,
};

@interface WQLogViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UIView *loginView;
@property (nonatomic ,strong) UIImageView *loginImage;

@property (nonatomic, strong) UIView * greenView;
@property (nonatomic, strong) UIView * orangeView;

/**底部按钮视图中间的分割线*/
@property (nonatomic, strong) UIView * centerView;

/**底部按钮视图中间的下划线*/
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * buttonView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *buttonA;
@property (nonatomic, strong) UIButton *buttonB;


@property (nonatomic,strong)UIView *seperatorLine;

@end

@implementation WQLogViewController{
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_phoneTextQuick;
    UITextField *_verificationTextQuick;
    UIButton          *_vericationRightBtn;
    NSInteger          _timer;
    NSTimer           *_timerCode;
    NSTimer           *_timerClose;
    NSDictionary      *_dict;
    NSString          *_phoneString;
    GJJCountDownButton *_getVerificationButton;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = CCXBackColor;
    [self setup_UI];
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}


/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    if (self.requestCount == WQAccountLogInRequest) {
        self.cmd = WQLogin;
        self.dict = @{@"userCode":_phoneTextAccount.text,
                      @"passWord":[self md5:_pwdTextAccount.text]};
    }else if (self.requestCount == WQQuickGetValiCodeFromPhone){
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone": _phoneTextQuick.text,
                      @"userId":@"",
                      @"type":  @"1"};
    }else if (self.requestCount == WQQuickLogInRequest){
        self.cmd = WQFastLogin;
        self.dict = @{@"userCode":_phoneTextQuick.text,
                      @"valiCode":_verificationTextQuick.text,
                      @"type": @"1"};
    }
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    MyLog(@"%@", dict);
    if (self.requestCount == WQAccountLogInRequest) {
        //talkingData 数据统计
        [TalkingData onLogin:dict[@"phone"] type:TDAccountTypeRegistered name:dict[@"customName"]];
        
        
        [self setHudWithName:@"登录成功" Time:1 andType:0];
        
        CCXUser *user = [[CCXUser alloc]initWithDictionary:@{
                                                             @"name":dict[@"userCode"],
                                                             @"password":_pwdTextAccount.text,
                                                             @"phone":dict[@"phone"],
                                                             @"userId":@"1",
                                                             @"customName":dict[@"customName"],
                                                             @"orgId":[NSString stringWithFormat:@"%@",dict[@"orgId"]],
                                                             @"token":[NSString stringWithFormat:@"%@",dict[@"token"]],
                                                    @"uuid":[NSString stringWithFormat:@"%@",dict[@"uuid"]]
                                                             }];
//        [NSString stringWithFormat:@"%@", dict[@"userId"]]
        [TalkingData onLogin:dict[@"phone"] type:TDAccountTypeRegistered name:dict[@"customName"]];
        
        [self saveSeccionWithUser:user];
        
        
        [self.navigationController popToViewController:self.popViewController animated:YES];
        XBlockExec(self.block,nil);
        
    }else if(self.requestCount == WQQuickGetValiCodeFromPhone){
        _dict = dict;
        [self setHudWithName:@"验证码获取成功" Time:1 andType:0];

        _getVerificationButton.userInteractionEnabled = NO;
        
        [_getVerificationButton startCountDownWithSecond:60];
        
        [_getVerificationButton countDownChanging:^NSString *(GJJCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"(%@)", @(second)];
            return title;
        }];
        [_getVerificationButton countDownFinished:^NSString *(GJJCountDownButton *countDownButton, NSUInteger second) {
            _getVerificationButton.userInteractionEnabled = YES;
            return @"重新获取";
        }];

    }else if (self.requestCount == WQQuickLogInRequest){
        CCXUser *user = [[CCXUser alloc]initWithDictionary:@{
                                                             @"name":dict[@"userCode"],
                                                             @"password":_pwdTextAccount.text,
                                                             @"phone":dict[@"phone"],
                                                             @"userId":@"1",
                                                             @"customName":dict[@"customName"],
                                                             @"orgId":[NSString stringWithFormat:@"%@",dict[@"orgId"]],
                                                             @"token":dict[@"token"],
                                                      @"uuid":dict[@"uuid"]       
                                                             }];
        [self saveSeccionWithUser:user];
        
        [self.navigationController popToViewController:self.popViewController animated:YES];
        XBlockExec(self.block,nil);
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    MyLog(@"%@",dict);
    [super requestFaildWithDictionary:dict];
}

#pragma mark -账号密码登录界面
/*******************************************************************************/
//初始化控件，添加到控件到视图上并设置控件属性。
- (void)setup_UI {
    //v1.2
    self.btnBack = [[UIButton alloc]init];
    [self.btnBack addTarget:self action:@selector(onBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBack setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
    [self.view addSubview:self.btnBack];
    
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"登录"];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [self.lblLogin setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
 
    self.loginView  = [[UIView alloc]init];
    self.loginView.backgroundColor = CCXColorWithRGB(255, 226, 134);
    
    self.loginImage  = [[UIImageView alloc]init];
    self.loginImage.image = [UIImage imageNamed:@"Login_tatoo"];
    
    [self.view addSubview:self.loginView];
    [self.view addSubview:_lblLogin];
    [self.view addSubview:self.loginImage];
    
    //配置scrollView的属性
    self.scrollView = [[UIScrollView alloc] init];
//    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:@"#f0eff5"]];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setContentSize:CGSizeMake(CCXSIZE_W * 2, 0)];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.greenView  = [[UIView alloc] init];
    self.orangeView = [[UIView alloc] init];
    self.buttonView = [[UIView alloc] init];
    //    self.centerView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.buttonA = [[UIButton alloc] init];
    self.buttonB = [[UIButton alloc] init];
    
    [self.view addSubview:self.scrollView];
//    [self.scrollView addSubview:self.greenView];
//    [self.scrollView addSubview:self.orangeView];
        for (int i = 0; i<2; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(CCXSIZE_W*i, 115, CCXSIZE_W, CCXSIZE_H-115)];
            if (i == 0) {
                self.greenView = view;
                [self.scrollView addSubview:self.greenView];
            }else{
                self.orangeView = view;
                [self.scrollView addSubview:self.orangeView];
            }
        }
    
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.buttonA];
    [self.buttonView addSubview:self.buttonB];
    self.seperatorLine =[UIView new];
    self.seperatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.buttonView addSubview:self.seperatorLine];
    [self.buttonView addSubview:self.bottomView];
    [self.bottomView setBackgroundColor:CCXColorWithRGB(23, 143, 149)];
    
    [self.buttonA setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [self.buttonB setTitle:@"验证码登录" forState:UIControlStateNormal];
    [self.buttonA setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [self.buttonA setTitle:@"账号密码登录" forState:UIControlStateSelected];
    [self.buttonB setTitle:@"验证码登录" forState:UIControlStateSelected];
    [self.buttonA setTitleColor:CCXColorWithRGB(17, 142, 149) forState:UIControlStateSelected];
    [self.buttonB setTitleColor:CCXColorWithRGB(17, 142, 149) forState:UIControlStateSelected];
    
    self.buttonA.titleLabel.font = [UIFont systemFontOfSize:12];
    self.buttonB.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.buttonA.selected = YES;
    
    [self.buttonA addTarget:self action:@selector(clickButtonA) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonB addTarget:self action:@selector(clickButtonB) forControlEvents:UIControlEventTouchUpInside];
    
    [self setup_Layout];
    
    [self createTextfieldAccount];
    [self createButtonAccount];
    [self createTextfieldQuick];
    [self createButtonQuick];
}


//为各个控件设置约束，用Masonry设置约束。Masonry设置约束一定要注意：先添加然后再设置约束，不然会崩溃报错。
#pragma mark - 约束设置
- (void)setup_Layout {
    
    [self.btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(28);
        make.left.mas_equalTo(self.view).offset(16);
        make.width.height.mas_equalTo(28);
    }];
    
    
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(104);
        make.left.mas_equalTo(self.view).offset(24);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(50);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self.lblLogin);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(23);
    }];
    [self.loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-24);
        make.top.mas_equalTo(self.lblLogin);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(1);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(50);
    }];
    
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.buttonView.bottom);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(CCXSIZE_H - 115);
    }];
    
    [self.orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.bottom);
        make.left.mas_equalTo(self.greenView.mas_right);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(CCXSIZE_H - 115);
    }];
    
    [self.buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 3);
        make.left.mas_equalTo(self.buttonView);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    [self.buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 3);
        make.left.mas_equalTo(self.buttonA.mas_right);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    //    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(3);
    //        make.height.mas_equalTo(34);
    //        make.center.mas_equalTo(self.buttonView);
    //    }];
    
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(0);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 3 );
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(self.buttonView);
    }];
}
//按钮的点击方法，当按钮被点击时，移动到相应的位置，显示相应的view。
#pragma mark - 按钮的点击事件
- (void)onBtnclick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)clickButtonA {
    self.buttonB.selected = NO;
    self.buttonA.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
}

- (void)clickButtonB {
    self.buttonA.selected = NO;
    self.buttonB.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(CCXSIZE_W, 0) animated:NO];
    }];
}



//ScrollView代理方法的代理方法，通过此方法获取当前拖动时的contentOffset.x来判断当前的位置，然后选中相应的按钮，执行相应的动画效果。
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%s",__func__);
//    [self.view endEditing:YES];
    //判断当前滚动的水平距离时候超过一半
    if (scrollView.contentOffset.x > CCXSIZE_W / 2) {
        //更新约束动画
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CCXSIZE_W / 3);
        }];
        if (_phoneString) {
            _phoneTextQuick.text = _phoneString;
        }
        //修改button按钮的状态
        [UIView animateWithDuration:0.3 animations:^{
            //强制刷新页面布局，不执行此方法，约束动画是没有用的！！！！！
            [self.buttonView layoutIfNeeded];
            self.buttonA.selected = NO;
            self.buttonB.selected = YES;
            self.buttonB.titleLabel.font = [UIFont systemFontOfSize:12];
            self.buttonA.titleLabel.font = [UIFont systemFontOfSize:12];
        }];
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buttonView);
        }];
        if (_phoneString) {
            _phoneTextAccount.text = _phoneString;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.buttonView layoutIfNeeded];
            self.buttonB.selected = NO;
            self.buttonA.selected = YES;
            self.buttonB.titleLabel.font = [UIFont systemFontOfSize:12];
            self.buttonA.titleLabel.font = [UIFont systemFontOfSize:12];
        }];
    }
}

/**
 创建textfield tag:(手机号码输入框)1   (密码输入框)2
 */
-(void)createTextfieldAccount{
    _phoneTextAccount = [[UITextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = CCXBackColor;
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{}];
    if (![[self getSeccsion].phone isEqualToString:@"请登录"]) {
    _phoneTextAccount.text = [self getSeccsion].phone;
    }
    _phoneTextAccount.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _phoneTextAccount.tag = 1;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
//    _phoneTextAccount.leftOffset = 10;
//    _phoneTextAccount.rightOffset = 10;
    [self.greenView addSubview:_phoneTextAccount];
    
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
    [lalPhone setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:14]];
    [self.greenView addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.greenView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.greenView addSubview:lineView2];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"密码"];
    [lalPwd setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:14]];
    [self.greenView addSubview:lalPwd];
//    UIImageView *imageV1 = [[UIImageView alloc]
//                            initWithImage:[UIImage imageNamed:@"number"]];
//    imageV1.frame = CCXRectMake(0, 0, 30, 40);
//    _phoneTextAccount.leftView = imageV1;
//    _phoneTextAccount.leftViewMode = UITextFieldViewModeAlways;
    
     _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = CCXBackColor;
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{}];
    if ([self getSeccsion].password.length != 0) {
        _pwdTextAccount.text = [self getSeccsion].password;
    }
    _pwdTextAccount.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
//    _pwdTextAccount.leftOffset = 10;
//    _pwdTextAccount.rightOffset = 10;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [self.greenView addSubview:_pwdTextAccount];

    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CCXSCREENSCALE*48);
        make.top.mas_equalTo(self.seperatorLine.mas_bottom).offset(20);
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(CCXSCREENSCALE*48);
        make.right.mas_equalTo(self.greenView).offset(-(CCXSCREENSCALE*48));
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(4);
        make.height.mas_equalTo(43);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(CCXSCREENSCALE*48);
        make.right.mas_equalTo(self.greenView).offset(-(CCXSCREENSCALE*48));
        make.top.mas_equalTo(_phoneTextAccount.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CCXSCREENSCALE*48);
        make.top.mas_equalTo(lineView.mas_bottom).offset(12);
    }];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(CCXSCREENSCALE*48);
        make.right.mas_equalTo(self.greenView).offset(-(CCXSCREENSCALE*48));
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(4);
        make.height.mas_equalTo(43);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(CCXSCREENSCALE*48);
        make.right.mas_equalTo(self.greenView).offset(-(CCXSCREENSCALE*48));
        make.top.mas_equalTo(_pwdTextAccount.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
   
}



/**
 创建textfield tag:(手机号码输入框)100 (验证码输入框)4   (获取验证码)30
 */
-(void)createTextfieldQuick{
    _phoneTextQuick = [[UITextField alloc]init];
    _phoneTextQuick.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextQuick.backgroundColor = CCXBackColor;
    _phoneTextQuick.borderStyle = UITextBorderStyleNone;
    _phoneTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{}];
    if (![[self getSeccsion].phone isEqualToString:@"请登录"]) {
        _phoneTextQuick.text = [self getSeccsion].phone;
    }
    _phoneTextQuick.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _phoneTextQuick.tag = 100;
    [_phoneTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextQuick.keyboardType = UIKeyboardTypeNumberPad;

    [self.orangeView addSubview:_phoneTextQuick];

    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
    [lalPhone setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:14]];
    [self.orangeView addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.orangeView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = CCXColorWithRGB(233, 233, 235);
    [self.orangeView addSubview:lineView2];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"验证码"];
    [lalPwd setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:14]];
    [self.orangeView addSubview:lalPwd];
    
    
    
    _verificationTextQuick = [[UITextField alloc]init];
    _verificationTextQuick.backgroundColor = CCXBackColor;
    _verificationTextQuick.borderStyle = UITextBorderStyleNone;
    _verificationTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{}];
    _verificationTextQuick.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    [_verificationTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationTextQuick.keyboardType = UIKeyboardTypeNumberPad;
    _verificationTextQuick.tag = 4;
    [self.orangeView addSubview:_verificationTextQuick];
    

    
    GJJCountDownButton *getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CCXRectMake(0, 0, 188, 86);
    [_orangeView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:CCXColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];

    _verificationTextQuick.rightView = getVerificationCodeButton;
    _verificationTextQuick.rightViewMode = UITextFieldViewModeAlways;

//    [getVerificationCodeButton sizeToFit];
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    [self.orangeView addSubview:_vericationRightBtn];
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(XWMSCREENSCALE*24);
        make.top.mas_equalTo(self.seperatorLine.mas_bottom).offset(20);
    }];
    [_phoneTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(XWMSCREENSCALE*24);
        make.right.mas_equalTo(self.orangeView).offset(-(XWMSCREENSCALE*24));
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(4);
        make.height.mas_equalTo(43);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(XWMSCREENSCALE*24);
        make.right.mas_equalTo(self.orangeView).offset(-(XWMSCREENSCALE*24));
        make.top.mas_equalTo(_phoneTextQuick.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(XWMSCREENSCALE*24);
        make.top.mas_equalTo(lineView.mas_bottom).offset(12);
    }];
    [_verificationTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(XWMSCREENSCALE*24);
        make.right.mas_equalTo(self.orangeView).offset(-(XWMSCREENSCALE*24));
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(4);
        make.height.mas_equalTo(43);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(XWMSCREENSCALE*24);
        make.right.mas_equalTo(self.orangeView).offset(-(XWMSCREENSCALE*24));
        make.top.mas_equalTo(_verificationTextQuick.mas_bottom).offset(12);
        make.height.mas_equalTo(1);
    }];
    
    
    
}
/**
 *  密码切换显示
 */
- (void)securePasswordClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _pwdTextAccount.secureTextEntry = NO;
    }else{
        _pwdTextAccount.secureTextEntry = YES;
    }
    NSString *text = _pwdTextAccount.text;
    _pwdTextAccount.text = @" ";
    _pwdTextAccount.text = text;
}

- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    if (_phoneTextQuick.text.length != 11) {
        [self setHudWithName:@"请输入正确的手机号码" Time:1 andType:0];
        return;
    }
    _getVerificationButton = sender;
    [self prepareDataWithCount:WQQuickGetValiCodeFromPhone];
}




/**
   accountBtn     tag:(登录)10 (快速注册)11 (忘记密码)12
 */
-(void)createButtonAccount{
        UIButton *loginButtonAccount = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButtonAccount.frame = CCXRectMake(40, 460, 670, 100);
        loginButtonAccount.layer.cornerRadius = 20*CCXSCREENSCALE;
        loginButtonAccount.clipsToBounds = YES;
        loginButtonAccount.backgroundColor = CCXColorWithRGB(78, 142, 220);
        [loginButtonAccount setTitle:@"登录" forState:UIControlStateNormal];
        [loginButtonAccount setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
        loginButtonAccount.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
        loginButtonAccount.tag = 10;
        [loginButtonAccount addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.greenView addSubview:loginButtonAccount];
        
        NSArray *array = @[@"快速注册",@"忘记密码?"];
        UIColor *fastRegesterBtnColor = CCXColorWithRGB(78, 142, 220);
        UIColor *forgetPwdColor = CCXColorWithRBBA(34, 58, 80, 0.48);
        NSArray *colorArr = @[fastRegesterBtnColor,forgetPwdColor];
        for (NSInteger i = 0; i<2; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CCXRectMake(40+(750-280)*i, 580, 200, 40);
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:colorArr[i] forState:UIControlStateNormal];
            btn.tag = 11 +i;
            [self.greenView addSubview:btn];
        }
}



/**
    QuickBtn    tag:(登录)20  (快速注册)21  (忘记密码)22
 */
-(void)createButtonQuick{
    UIButton *loginButtonQuick = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButtonQuick.frame = CCXRectMake(40, 460, 670, 100);
    loginButtonQuick.layer.cornerRadius = 20*CCXSCREENSCALE;
    loginButtonQuick.clipsToBounds = YES;
    loginButtonQuick.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [loginButtonQuick setTitle:@"登录" forState:UIControlStateNormal];
    [loginButtonQuick setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    loginButtonQuick.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    loginButtonQuick.tag = 20;
    [loginButtonQuick addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orangeView addSubview:loginButtonQuick];
    
    NSArray *array = @[@"快速注册",@"忘记密码?"];
    UIColor *fastRegesterBtnColor = CCXColorWithRGB(78, 142, 220);
    UIColor *forgetPwdColor = [UIColor colorWithHexString:GJJBlackTextColorString];
    NSArray *colorArr = @[fastRegesterBtnColor,forgetPwdColor];
    for (NSInteger i = 0; i<1; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CCXRectMake(40+(750-280)*i, 580, 200, 40);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:colorArr[i] forState:UIControlStateNormal];
        btn.tag = 21+i;
        [self.orangeView addSubview:btn];
    }
}

/**
 *   注意事项:
 *  在XIB,SB,或者是在代码中创建Button的时候,Button的样式要设置成为 Custom 样式,否则在倒计时过程中 Button 的Tittle 会闪动.
 */

//倒计时
- (void)timerFired{
    [_vericationRightBtn setTitle:[NSString stringWithFormat:@"(%@)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer{
    [_vericationRightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vericationRightBtn.userInteractionEnabled = YES;
    _vericationRightBtn.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [_vericationRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}


-(void)buttonClick:(UIButton *)btn{
    [self.view endEditing:YES];
        if (btn.tag == 10) {//登录
            if (_phoneTextAccount.text.length == 0) {
                [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
                return;
            }
            if (_pwdTextAccount.text.length == 0) {
                [self setHudWithName:@"请输入密码" Time:0.5 andType:3];
                return;
            }
            if (_phoneTextAccount.text.length != 11) {
                [self setHudWithName:@"请输入正确的手机号" Time:1 andType:3];
                return;
            }
            [self prepareDataWithCount:WQAccountLogInRequest];
        }else if (btn.tag == 12) {//找回密码
            WQModifyPasswordViewController *modifyPwdVC = [[WQModifyPasswordViewController alloc]init];
            modifyPwdVC.title = @"找回密码";
            modifyPwdVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
            modifyPwdVC.phontString = _phoneTextAccount.text;
        }else if (btn.tag == 11){//快速注册
            XWMRegisterViewController *registerVC = [[XWMRegisterViewController alloc]init];
            registerVC.title = @"注册";
            registerVC.hidesBottomBarWhenPushed = YES;
            registerVC.popViewController = self.popViewController;
//            NSLog(@"%@", registerVC.popViewController);
            [self.navigationController pushViewController:registerVC animated:YES];
        }else if (btn.tag == 20) {//登录
            if (_phoneTextQuick.text.length == 0) {
                [self setHudWithName:@"请输入手机号码" Time:1 andType:3];
                return;
            }
            if (_verificationTextQuick.text.length == 0) {
                [self setHudWithName:@"请输入短信验证码" Time:1 andType:3];
                return;
            }
            [self prepareDataWithCount:WQQuickLogInRequest];
        }else if (btn.tag == 22) {//找回密码
            WQModifyPasswordViewController *modifyPwdVC = [[WQModifyPasswordViewController alloc]init];
            modifyPwdVC.title = @"找回密码";
            modifyPwdVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyPwdVC animated:YES];
            modifyPwdVC.phontString = _phoneTextAccount.text;
        }else if (btn.tag == 21){//快速注册
            XWMRegisterViewController *registerVC = [[XWMRegisterViewController alloc]init];
            registerVC.title = @"注册";
            registerVC.hidesBottomBarWhenPushed = YES;
            registerVC.popViewController = self.popViewController;
      
            [self.navigationController pushViewController:registerVC animated:YES];
        }else if (btn.tag == 30){
            [self.view endEditing:YES];
            if (_phoneTextQuick.text.length == 0) {
                [self setHudWithName:@"请输入手机号码" Time:1 andType:3];
                return;
            }
            if (_phoneTextQuick.text.length != 11) {
                [self setHudWithName:@"请输入正确的手机号" Time:1 andType:3];
                return;
            }
            [self prepareDataWithCount:WQQuickGetValiCodeFromPhone];
        }
}

#pragma mark - UITextfield TextChange

-(CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectMake(0, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
            _phoneString = _phoneTextAccount.text;
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
    }else if (textField == _phoneTextQuick) {
        if (_phoneTextQuick.text.length >= 11) {
            _phoneTextQuick.text = [_phoneTextQuick.text substringToIndex:11];
            _phoneString = _phoneTextQuick.text;
        }
    }else if (textField == _verificationTextQuick) {
        if (_verificationTextQuick.text.length >= 6) {
            _verificationTextQuick.text = [_verificationTextQuick.text substringToIndex:6];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
