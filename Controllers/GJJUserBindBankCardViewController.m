//
//  GJJUserBindBankCardViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/7.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJUserBindBankCardViewController.h"
#import "GJJChoosePickerView.h"
#import "GJJBankModel.h"
#import "GJJDropBankNameView.h"
#import "GJJUserLinkManViewController.h"
#import "GJJBindCardScanSuccessView.h"
#import "GJJGetBankModel.h"
#import "GJJBankTableViewCell.h"
#import "GJJChangeBingCardViewController.h"
#import "UITextField+ExtendRange.h"
#import "GJJCountDownButton.h"
#import "STBankInfoCell.h"
typedef NS_ENUM(NSInteger, GJJUserBindBankCardRequest) {
    GJJUserBindBankCardRequestData,
    GJJUserBindBankCardRequestBankInfo,
    GJJUserBindBankCardRequestGetCode,
    GJJUserBindBankCardRequestSubmit,
    GJJUserBindBankCardRequestSupportedBank,
};

@interface GJJUserBindBankCardViewController ()
<GJJChoosePickerViewDelegate,
GJJBindCardScanSuccessViewDelegate,
UITextFieldDelegate>

@end

@implementation GJJUserBindBankCardViewController
{
    UITextField *_bankNumberText;
    
    NSDictionary *_bankInfoDict;
    
    GJJBindCardScanSuccessView *_scanSuccessView;
    
    GJJChoosePickerView *_chooseBankPickerView;
    UILabel *_chooseBankLabel;
    NSMutableArray *_bankArray;
    UITextField *_phoneText;
    UITextField *_codeText;
    UIButton *_getCodeButton;
    NSTimer *_timerCode;
    NSTimer *_timerClose;
    NSInteger _timer;
    GJJBankModel *_selectedModel;
    
    GJJGetBankModel *_getBankModel;
    
    GJJBindCardScanSuccessView *_successView;
    NSDictionary *_scanSuccessDict;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
    
    GJJCountDownButton *_getVerificationButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
//    [self setupView];
    if (_schedule == 8) {
        [self createTableViewWithFrame:CGRectZero];
        [self.tableV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    [self prepareDataWithCount:GJJUserBindBankCardRequestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_schedule == 8) {
        [self prepareDataWithCount:GJJUserBindBankCardRequestData];
    }
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJUserBindBankCardRequestData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

- (void)setupData
{
    _bankArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"持卡人", @"银行卡号", @"开户银行", @"手机号", @"验证码"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    
    UIView *peopleView = [[UIView alloc]init];
    [self.view addSubview:peopleView];
    peopleView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    peopleView.layer.cornerRadius = AdaptationWidth(5);
    peopleView.layer.masksToBounds = YES;
    peopleView.layer.borderWidth = 0.5;
    peopleView.layer.borderColor = borderColor.CGColor;
    [peopleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.mas_height).multipliedBy(1.0/14);
    }];
    
    UILabel *peopleLabel = [[UILabel alloc]init];
    [peopleView addSubview:peopleLabel];
    peopleLabel.text = @"持卡人";
    peopleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    peopleLabel.textColor = CCXColorWithHex(@"888888");
    [peopleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleView.mas_left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(peopleView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [peopleView addSubview:nameLabel];
    if (_getBankModel.userName.length != 0) {
        nameLabel.text = _getBankModel.userName;
    }else {
        nameLabel.text = [self getSeccsion].customName;
    }
    nameLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    nameLabel.textColor = CCXColorWithHex(@"888888");
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleLabel.mas_right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(peopleView);
    }];
    
    UIView *cardNumberView = [[UIView alloc]init];
    [self.view addSubview:cardNumberView];
    cardNumberView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    cardNumberView.layer.cornerRadius = AdaptationWidth(5);
    cardNumberView.layer.masksToBounds = YES;
    cardNumberView.layer.borderWidth = 0.5;
    cardNumberView.layer.borderColor = borderColor.CGColor;
    [cardNumberView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peopleView.mas_bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.mas_height);
    }];
    
    UILabel *cardNumberLabel = [[UILabel alloc]init];
    [cardNumberView addSubview:cardNumberLabel];
    cardNumberLabel.text = @"银行卡号";
    cardNumberLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    cardNumberLabel.textColor = CCXColorWithHex(@"888888");
    [cardNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNumberView.mas_left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(cardNumberView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    UIButton *scanCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cardNumberView addSubview:scanCardButton];
    [scanCardButton setImage:[UIImage imageNamed:@"绑定银行卡扫描"] forState:UIControlStateNormal];
    [scanCardButton addTarget:self action:@selector(scanBankCard) forControlEvents:UIControlEventTouchUpInside];
    [scanCardButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cardNumberView).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(cardNumberView);
        make.width.equalTo(@(AdaptationWidth(40)));
        make.height.equalTo(@(AdaptationWidth(30)));
    }];
    
    _bankNumberText = [[UITextField alloc]init];
    [cardNumberView addSubview:_bankNumberText];
    _bankNumberText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _bankNumberText.keyboardType = UIKeyboardTypeNumberPad;
    _bankNumberText.delegate = self;
    if (_getBankModel.bankCard.length != 0) {
        _bankNumberText.text = _getBankModel.bankCard;
    }
    _bankNumberText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请扫描您的借记卡" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _bankNumberText.textColor = CCXColorWithHex(@"888888");
    _bankNumberText.adjustsFontSizeToFitWidth = YES;
    _bankNumberText.userInteractionEnabled = NO;
    [_bankNumberText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNumberLabel.mas_right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(cardNumberView);
        make.right.equalTo(scanCardButton.mas_left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIView *bankView = [[UIView alloc]init];
    [self.view addSubview:bankView];
    bankView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    bankView.layer.cornerRadius = AdaptationWidth(5);
    bankView.layer.masksToBounds = YES;
    bankView.layer.borderWidth = 0.5;
    bankView.layer.borderColor = borderColor.CGColor;
    [bankView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardNumberView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.mas_height);
    }];
    
    UILabel *bankLabel = [[UILabel alloc]init];
    [bankView addSubview:bankLabel];
    bankLabel.text = @"开户银行";
    bankLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    bankLabel.textColor = CCXColorWithHex(@"888888");
    [bankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.mas_left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(bankView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _chooseBankLabel = [[UILabel alloc]init];
    [bankView addSubview:_chooseBankLabel];
    if (_getBankModel.bankName.length != 0) {
        _chooseBankLabel.text = _getBankModel.bankName;
        _chooseBankLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _chooseBankLabel.text = @"请选择您的开户银行";
        _chooseBankLabel.textColor = placeholderColor;
    }
    _chooseBankLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _chooseBankLabel.adjustsFontSizeToFitWidth = YES;
    _chooseBankLabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *chooseBankTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBank)];
//    [_chooseBankLabel addGestureRecognizer:chooseBankTap];
    [_chooseBankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLabel.mas_right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(bankView);
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [self.view addSubview:hintLabel];
    hintLabel.text = @"* 所填写的手机号必须为银行预留手机号，以便您顺利申请贷款。";
    hintLabel.textColor = CCXColorWithHex(@"cccccc");
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(12)];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_bottom);
        make.left.equalTo(self.view).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(@(AdaptationHeight(30)));
    }];
    
    UIView *phoneView = [[UIView alloc]init];
    [self.view addSubview:phoneView];
    phoneView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    phoneView.layer.cornerRadius = AdaptationWidth(5);
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.borderWidth = 0.5;
    phoneView.layer.borderColor = borderColor.CGColor;
    [phoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.mas_height);
    }];
    
    UILabel *phoneNameLabel = [[UILabel alloc]init];
    [phoneView addSubview:phoneNameLabel];
    phoneNameLabel.text = @"手机号";
    phoneNameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    phoneNameLabel.textColor = CCXColorWithHex(@"888888");
    [phoneNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left).offset(AdaptationWidth(10));
        make.centerY.equalTo(phoneView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    UIButton *changePhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneView addSubview:changePhoneButton];
    [changePhoneButton setImage:[UIImage imageNamed:@"绑定银行卡修改"] forState:UIControlStateNormal];
    [changePhoneButton addTarget:self action:@selector(changePhoneClick) forControlEvents:UIControlEventTouchUpInside];
    [changePhoneButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneView).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(phoneView);
        make.width.equalTo(@(AdaptationWidth(40)));
        make.height.equalTo(@(AdaptationWidth(30)));
    }];
    
    _phoneText = [[UITextField alloc]init];
    [phoneView addSubview:_phoneText];
    _phoneText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _phoneText.keyboardType = UIKeyboardTypePhonePad;
    if (_getBankModel.bankPhone.length != 0) {
        _phoneText.text = _getBankModel.bankPhone;
    }else {
        _phoneText.text = [self getSeccsion].phone;
    }
    _phoneText.userInteractionEnabled = NO;
    _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您银行预留的手机号" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _phoneText.textColor = CCXColorWithHex(@"888888");
    _phoneText.adjustsFontSizeToFitWidth = YES;
    [_phoneText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNameLabel.mas_right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(phoneView);
        make.right.equalTo(changePhoneButton.mas_left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIView *codeView = [[UIView alloc]init];
    [self.view addSubview:codeView];
    codeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    codeView.layer.cornerRadius = AdaptationWidth(5);
    codeView.layer.masksToBounds = YES;
    codeView.layer.borderWidth = 0.5;
    codeView.layer.borderColor = borderColor.CGColor;
    [codeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.mas_height);
    }];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    [codeView addSubview:codeLabel];
    codeLabel.text = @"验证码";
    codeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    codeLabel.textColor = CCXColorWithHex(@"888888");
    [codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView.mas_left).offset(AdaptationWidth(AdaptationWidth(10)));
        make.centerY.equalTo(codeView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
//    _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [codeView addSubview:_getCodeButton];
//    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _getCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_getCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
//    _getCodeButton.backgroundColor = [UIColor clearColor];
//    [_getCodeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    GJJCountDownButton *getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    [codeView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    getVerificationCodeButton.backgroundColor = [UIColor clearColor];
    getVerificationCodeButton.layer.cornerRadius = AdaptationWidth(5);
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    getVerificationCodeButton.layer.masksToBounds = YES;
    //    [getVerificationCodeButton sizeToFit];
    getVerificationCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [getVerificationCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView.right).offset(@(AdaptationWidth(-20)));
        make.centerY.equalTo(codeView.centerY);
        make.height.equalTo(codeView.height).multipliedBy(6.0/9);
        make.width.equalTo(getVerificationCodeButton.height).multipliedBy(2.8);
    }];
    [getVerificationCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView.mas_right).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(codeView.mas_centerY);
        make.height.equalTo(codeView.mas_height).multipliedBy(6.0/9);
        make.width.equalTo(getVerificationCodeButton.mas_height).multipliedBy(2.8);
    }];
    
    _codeText = [[UITextField alloc]init];
    [codeView addSubview:_codeText];
    _codeText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    _codeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机验证码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _codeText.textColor = CCXColorWithHex(@"888888");
    [_codeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLabel.mas_right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(codeView);
        make.right.equalTo(getVerificationCodeButton.mas_left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    certificationButton.layer.masksToBounds = YES;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(@(AdaptationHeight(30)));
        make.left.equalTo(self.view.mas_left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.mas_right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.mas_height).multipliedBy(1.0/13);
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
//            make.bottom.equalTo(_scheduleProgressView.mas_top).offset(@(-6));
//        }];
//        
//        _scheduleProgressView.progress = 0.5;
//        _scheduleProgressLabel.text = @"50%";
//    }
}

- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    if (_phoneText.text == 0) {
        [self setHudWithName:@"请输入手机号" Time:1 andType:1];
        return;
    }
    
    if (_phoneText.text.length != 11) {
        [self setHudWithName:@"请输入11位手机号" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJUserBindBankCardRequestGetCode];
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


#pragma makr - UITapGestureRecognizer
- (void)scanBankCard
{
    self.title = @"银行卡扫描";
    [self startBankCardOCR];
}

/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name
{
    NSLog(@"%s", __func__);
    _bankInfoDict = @{@"bank_num":bank_num,
                      @"bank_name":bank_name
                      };
}

/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage
{
    NSLog(@"%s", __func__);
    _scanSuccessView = [[GJJBindCardScanSuccessView alloc]initWithImage:BankCardImage];
    [self.view addSubview:_scanSuccessView];
    _scanSuccessView.delegate = self;
    _scanSuccessView.bankListArray = _bankArray;
    [_scanSuccessView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _scanSuccessView.infoDict = _bankInfoDict;
}

- (void)chooseBank
{
    if (_bankArray.count == 0) {
        [self prepareDataWithCount:GJJUserBindBankCardRequestBankInfo];
    }else {
        [self showBankPickerView];
    }
}

- (void)setRequestParams
{
    if (self.requestCount == GJJUserBindBankCardRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"4"};
    }else if (self.requestCount == GJJUserBindBankCardRequestBankInfo) {
        self.cmd = GJJQueryBankAndLog;
        self.dict = @{};
    }else if (self.requestCount == GJJUserBindBankCardRequestGetCode) {
        self.cmd = GJJGetValiCodeFromPhone;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"phone":_phoneText.text,
                      @"type":@"3"};
    }else if (self.requestCount == GJJUserBindBankCardRequestSubmit) {
        self.cmd = GJJBankCardCheck;
        NSString *bankCardNo = [_bankNumberText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.dict = @{@"realName":[self getSeccsion].customName,
                      @"certNo":[self getSeccsion].identityCard,
                      @"userId":[self getSeccsion].userId,
                      @"mobileNo":_phoneText.text,
                      @"bankCardNo":bankCardNo,
                      @"valiCode":_codeText.text,
                      @"bankName":_chooseBankLabel.text,
                      @"type":@"3"};
    }else if (self.requestCount == GJJUserBindBankCardRequestSupportedBank) {
        self.cmd = GJJQuerySupportedBank;
        self.dict = @{@"bankName":_scanSuccessDict[@"bank_name"]};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJUserBindBankCardRequestData) {
        _getBankModel = [GJJGetBankModel yy_modelWithDictionary:dict];
        CCXUser *user = [self getSeccsion];
        user.identityCard = dict[@"identityCard"];
        user.customName = dict[@"userName"];
        [self saveSeccionWithUser:user];
        [self prepareDataWithCount:GJJUserBindBankCardRequestBankInfo];
    }else if (self.requestCount == GJJUserBindBankCardRequestBankInfo) {
        NSArray *detaList = dict[@"detaList"];
        [_bankArray removeAllObjects];
        for (NSDictionary *dict in detaList) {
            GJJBankModel *model = [GJJBankModel yy_modelWithDictionary:dict];
            [_bankArray addObject:model];
        }
        if (_schedule == 8) {
            [self.tableV reloadData];
            UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            changeButton.frame = CGRectMake(0, 0, 64, 64);
            [changeButton setTitle:@"修改" forState:UIControlStateNormal];
            changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            changeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
            [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [changeButton addTarget:self action:@selector(changeCard) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeButton];
        }else {
            [self setupView];
        }

    }else if (self.requestCount == GJJUserBindBankCardRequestGetCode) {
        [self beginCountDown];
//        _timer = 60;
//        _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//        [_timerCode setFireDate:[NSDate date]];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
//        _getCodeButton.userInteractionEnabled = NO;
//        [_getCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];
    }else if (self.requestCount == GJJUserBindBankCardRequestSubmit) {
        if ([dict[@"isBank"] integerValue]) {
            if (_schedule == 8) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                GJJUserLinkManViewController *controller = [[GJJUserLinkManViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"联系人信息";
                controller.popViewController = self.popViewController;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else {
            [self setHudWithName:@"保存银行卡信息失败" Time:1 andType:1];
        }
    }else if (self.requestCount == GJJUserBindBankCardRequestSupportedBank) {
        self.title = @"银行卡认证";
        [_successView removeFromSuperview];
        _bankNumberText.text = _scanSuccessDict[@"bank_num"];
        _chooseBankLabel.text = _scanSuccessDict[@"bank_name"];
        _chooseBankLabel.textColor = CCXColorWithHex(@"888888");
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJUserBindBankCardRequestData) {
        [self setupView];
    }
}

- (void)showBankPickerView
{
    NSMutableArray *bankNameArray = [NSMutableArray arrayWithCapacity:0];
    for (GJJBankModel *model in _bankArray) {
        [bankNameArray addObject:model.bankName];
    }
    
    _chooseBankPickerView = [[GJJChoosePickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseBankPickerView.delegate = self;
    _chooseBankPickerView.chooseThings = bankNameArray;
    [_chooseBankPickerView showView];
}

#pragma mark - GJJChoosePickerViewDelegate
- (void)chooseThing:(NSString *)thing pickView:(GJJChoosePickerView *)pickView row:(NSInteger)row
{
    _chooseBankLabel.text = thing;
    _chooseBankLabel.textColor = CCXColorWithHex(@"888888");
    _selectedModel = _bankArray[row];
}

#pragma mark - button click
- (void)getCodeClick:(UIButton *)sender
{
    if (_phoneText.text == 0) {
        [self setHudWithName:@"请输入手机号" Time:1 andType:1];
        return;
    }
    
    if (_phoneText.text.length != 11) {
        [self setHudWithName:@"请输入11位手机号" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJUserBindBankCardRequestGetCode];
}

- (void)changePhoneClick
{
    _phoneText.userInteractionEnabled = YES;
}

- (void)timerFired
{
    [_getCodeButton setTitle:[NSString stringWithFormat:@"(%@)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer
{
    UIColor *mainColor = CCXMainColor;
    _getCodeButton.userInteractionEnabled = YES;
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton setTitleColor:mainColor forState:UIControlStateNormal];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}

- (void)changeCard
{
    GJJChangeBingCardViewController *controller = [[GJJChangeBingCardViewController alloc]init];
    controller.title = @"银行卡认证";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)certificationClick:(UIButton *)sender
{
    if (_bankNumberText.text == 0) {
        [self setHudWithName:@"请输入/扫描您的借记卡" Time:1 andType:1];
        return;
    }
    
    if (_bankNumberText.text.length < 14) {
        [self setHudWithName:@"请输入有效的银行卡号" Time:1 andType:1];
        return;
    }
    
    if ([_chooseBankLabel.text isEqualToString:@"请选择您的开户银行"]) {
        [self setHudWithName:@"请选择您的开户银行" Time:1 andType:1];
        return;
    }
    
    if (_codeText.text.length == 0) {
        [self setHudWithName:@"请输入手机验证码" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJUserBindBankCardRequestSubmit];
}

#pragma mark - GJJBindCardScanSuccessViewDelegate
- (void)bankCardScanSureInfoWithDict:(NSDictionary *)dict infoView:(GJJBindCardScanSuccessView *)infoView
{
    _successView = infoView;
    _scanSuccessDict = dict;
    [self prepareDataWithCount:GJJUserBindBankCardRequestSupportedBank];
}

- (void)bankCardRescan
{
    [self scanBankCard];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_getBankModel) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptationHeight(150);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GJJBankTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GJJBankTableViewCell class]) owner:self options:nil]lastObject];
//    [cell.bankImageView setImageWithURL:[NSURL URLWithString:_getBankModel.bankLogUrl] placeholderImage:[UIImage imageNamed:@"加载图"]];
//    NSString *securityStr = [_getBankModel.bankCard stringByReplacingCharactersInRange:NSMakeRange((_getBankModel.bankCard.length - 8) / 2, 8) withString:@"********"];
//    cell.bankNameLabel.text = _getBankModel.bankName;
//    cell.bankCardLabel.text = securityStr;
    static NSString *cellId = @"cellId";
    
    STBankInfoCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[STBankInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = _getBankModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITextFieldDelegate

static NSInteger const kGroupSize = 4;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _bankNumberText) {
        
        NSString *text = textField.text;
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNo = [self removingSapceString:beingString];
        //校验卡号只能是数字，且不能超过20位
        if ( (string.length != 0 && ![self isValidNumbers:cardNo]) || cardNo.length > 20) {
            return NO;
        }
        //获取【光标右侧的数字个数】
        NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
        //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
        if (beingString.length > kGroupSize) {
            textField.text = [self groupedString:beingString];
        } else {
            textField.text = beingString;
        }
        text = textField.text;
        /**
         * 计算光标位置(相对末尾)
         * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
         * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
         */
        NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
        NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
        
        //如果光标左侧是一个空格，则光标回退一格
        if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:@" "]) {
            currentSelectedRange.location -= 1;
        }
        [textField setSelectedRange:currentSelectedRange];
        return NO;
    }
    return YES;
}

#pragma mark - Helper
/**
 *  计算光标相对末尾的位置偏移
 *
 *  @param length           卡号的长度(不包括空格)
 *  @param rightNumberCount 光标右侧的数字个数
 *
 *  @return 光标相对末尾的位置偏移
 */
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount -1 > 0? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount -1 > 0? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

/**
 *  校验给定字符串是否是纯数字
 *
 *  @param numberStr 字符串
 *
 *  @return 字符串是否是纯数字
 */
- (BOOL)isValidNumbers:(NSString *)numberStr {
    NSString* numberRegex = @"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPre evaluateWithObject:numberStr];
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == _phoneText) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
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
