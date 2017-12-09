//
//  GJJChangeBingCardViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJChangeBingCardViewController.h"
#import "GJJChoosePickerView.h"
#import "GJJBankModel.h"
#import "GJJDropBankNameView.h"
#import "GJJAdultUserLinkManViewController.h"
#import "GJJBindCardScanSuccessView.h"
#import "GJJGetBankModel.h"
#import "UITextField+ExtendRange.h"
#import "GJJSignAContractWebViewController.h"
#import "GJJCountDownButton.h"
typedef NS_ENUM(NSInteger, GJJChangeBingCardRequest) {
    GJJChangeBingCardRequestData,
    GJJChangeBingCardRequestBankInfo,
    GJJChangeBingCardRequestGetCode,
    GJJChangeBingCardRequestSubmit,
    GJJChangeBingCardRequestSupportedBank,
};

@interface GJJChangeBingCardViewController ()
<GJJChoosePickerViewDelegate,
GJJBindCardScanSuccessViewDelegate,
UITextFieldDelegate>

@end

@implementation GJJChangeBingCardViewController
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
    GJJCountDownButton *_getVerificationButton;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    [self prepareDataWithCount:GJJChangeBingCardRequestData];
}

- (void)setupData
{
    _bankArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
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
        make.top.equalTo(self.view.top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    UILabel *peopleLabel = [[UILabel alloc]init];
    [peopleView addSubview:peopleLabel];
    peopleLabel.text = @"持卡人";
    peopleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    peopleLabel.textColor = CCXColorWithHex(@"888888");
    [peopleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(peopleView.centerY);
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
        make.left.equalTo(peopleLabel.right).offset(@(AdaptationWidth(10)));
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
        make.top.equalTo(peopleView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.height);
    }];
    
    UILabel *cardNumberLabel = [[UILabel alloc]init];
    [cardNumberView addSubview:cardNumberLabel];
    cardNumberLabel.text = @"银行卡号";
    cardNumberLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    cardNumberLabel.textColor = CCXColorWithHex(@"888888");
    [cardNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNumberView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(cardNumberView.centerY);
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
    if (_getBankModel.bankCard.length != 0) {
        _bankNumberText.text = _getBankModel.bankCard;
    }
    _bankNumberText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请扫描您的借记卡" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _bankNumberText.textColor = CCXColorWithHex(@"888888");
    _bankNumberText.adjustsFontSizeToFitWidth = YES;
    _bankNumberText.delegate = self;
    _bankNumberText.userInteractionEnabled = NO;
    [_bankNumberText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardNumberLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(cardNumberView);
        make.right.equalTo(scanCardButton.left).offset(@(AdaptationWidth(-10)));
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
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.height);
    }];
    
    UILabel *bankLabel = [[UILabel alloc]init];
    [bankView addSubview:bankLabel];
    bankLabel.text = @"开户银行";
    bankLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    bankLabel.textColor = CCXColorWithHex(@"888888");
    [bankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(bankView.centerY);
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
        make.left.equalTo(bankLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(bankView);
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [self.view addSubview:hintLabel];
    hintLabel.text = @"* 所填写的手机号必须为银行预留手机号，以便您顺利申请贷款。";
    hintLabel.textColor = CCXColorWithHex(@"cccccc");
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(12)];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.bottom);
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
        make.top.equalTo(hintLabel.bottom);
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.height);
    }];
    
    UILabel *phoneNameLabel = [[UILabel alloc]init];
    [phoneView addSubview:phoneNameLabel];
    phoneNameLabel.text = @"手机号";
    phoneNameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    phoneNameLabel.textColor = CCXColorWithHex(@"888888");
    [phoneNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.left).offset(AdaptationWidth(10));
        make.centerY.equalTo(phoneView.centerY);
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
        make.left.equalTo(phoneNameLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(phoneView);
        make.right.equalTo(changePhoneButton.left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIView *codeView = [[UIView alloc]init];
    [self.view addSubview:codeView];
    codeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    codeView.layer.cornerRadius = AdaptationWidth(5);
    codeView.layer.masksToBounds = YES;
    codeView.layer.borderWidth = 0.5;
    codeView.layer.borderColor = borderColor.CGColor;
    [codeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(peopleView.height);
    }];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    [codeView addSubview:codeLabel];
    codeLabel.text = @"验证码";
    codeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    codeLabel.textColor = CCXColorWithHex(@"888888");
    [codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView.left).offset(AdaptationWidth(AdaptationWidth(10)));
        make.centerY.equalTo(codeView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    GJJCountDownButton *getVerificationCodeButton = [GJJCountDownButton buttonWithType:UIButtonTypeCustom];
    [codeView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
    getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    getVerificationCodeButton.backgroundColor = [UIColor clearColor];
    getVerificationCodeButton.layer.cornerRadius = AdaptationWidth(5);
    getVerificationCodeButton.layer.masksToBounds = YES;
    //    [getVerificationCodeButton sizeToFit];
    getVerificationCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [getVerificationCodeButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codeView.right).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(codeView.centerY);
        make.height.equalTo(codeView.height).multipliedBy(6.0/9);
        make.width.equalTo(getVerificationCodeButton.height).multipliedBy(2.8);
    }];

//    _getCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [codeView addSubview:_getCodeButton];
//    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    _getCodeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [_getCodeButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
//    _getCodeButton.backgroundColor = [UIColor clearColor];
//    [_getCodeButton addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_getCodeButton makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(codeView.right).offset(@(AdaptationWidth(-10)));
//        make.centerY.equalTo(codeView.centerY);
//        make.height.equalTo(codeView.height).multipliedBy(6.0/9);
//        make.width.equalTo(_getCodeButton.height).multipliedBy(2.8);
//    }];
    
    _codeText = [[UITextField alloc]init];
    [codeView addSubview:_codeText];
    _codeText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    _codeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机验证码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _codeText.textColor = CCXColorWithHex(@"888888");
    [_codeText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.equalTo(codeView);
        make.right.equalTo(getVerificationCodeButton.left).offset(@(AdaptationWidth(-10)));
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
        make.top.equalTo(codeView.bottom).offset(@(AdaptationHeight(30)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
}


- (void)getVerificationCodeClick:(GJJCountDownButton *)sender
{
    _getVerificationButton = sender;
    if (_phoneText.text.length == 0) {
        [self setHudWithName:@"请输入手机号" Time:1 andType:1];
        return;
    }
    
    if (_phoneText.text.length != 11) {
        [self setHudWithName:@"请输入11位手机号" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJChangeBingCardRequestGetCode];
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
        [self prepareDataWithCount:GJJChangeBingCardRequestBankInfo];
    }else {
        [self showBankPickerView];
    }
}

- (void)setRequestParams
{
    if (self.requestCount == GJJChangeBingCardRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"4"};
    }else if (self.requestCount == GJJChangeBingCardRequestBankInfo) {
        self.cmd = GJJQueryBankAndLog;
        self.dict = @{};
    }else if (self.requestCount == GJJChangeBingCardRequestGetCode) {
        self.cmd = GJJGetValiCodeFromPhone;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"phone":_phoneText.text,
                      @"type":@"3"};
    }else if (self.requestCount == GJJChangeBingCardRequestSubmit) {
        self.cmd = GJJBankCardCheck;
        NSString *bankCardNo = [_bankNumberText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (_withDrawId.length == 0) {
            _withDrawId = @"";
        }
        self.dict = @{@"realName":[self getSeccsion].customName,
                      @"certNo":[self getSeccsion].identityCard,
                      @"userId":[self getSeccsion].userId,
                      @"mobileNo":_phoneText.text,
                      @"bankCardNo":bankCardNo,
                      @"valiCode":_codeText.text,
                      @"bankName":_chooseBankLabel.text,
                      @"type":@"3",
                      @"withDrawId":_withDrawId};
    }else if (self.requestCount == GJJChangeBingCardRequestSupportedBank) {
        self.cmd = GJJQuerySupportedBank;
        self.dict = @{@"bankName":_scanSuccessDict[@"bank_name"]};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJChangeBingCardRequestData) {
        _getBankModel = [GJJGetBankModel yy_modelWithDictionary:dict];
        CCXUser *user = [self getSeccsion];
        user.identityCard = dict[@"identityCard"];
        user.customName = dict[@"userName"];
        [self saveSeccionWithUser:user];
        [self prepareDataWithCount:GJJChangeBingCardRequestBankInfo];
        
    }else if (self.requestCount == GJJChangeBingCardRequestBankInfo) {
        NSArray *detaList = dict[@"detaList"];
        [_bankArray removeAllObjects];
        for (NSDictionary *dict in detaList) {
            GJJBankModel *model = [GJJBankModel yy_modelWithDictionary:dict];
            [_bankArray addObject:model];
        }
        
        [self setupView];
    }else if (self.requestCount == GJJChangeBingCardRequestGetCode) {
        NSLog(@"%s", __func__);
        [self beginCountDown];
//        _timer = 60;
//        _timerCode = [NSTimer  timerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
//        [_timerCode setFireDate:[NSDate date]];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerCode forMode:NSDefaultRunLoopMode];
//        _getCodeButton.userInteractionEnabled = NO;
//        [_getCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        _timerClose = [NSTimer  timerWithTimeInterval:60.0 target:self selector:@selector(CloseTimer) userInfo:nil repeats:YES];
//        [[NSRunLoop  currentRunLoop] addTimer:_timerClose forMode:NSDefaultRunLoopMode];
    }else if (self.requestCount == GJJChangeBingCardRequestSubmit) {
        if ([dict[@"isBank"] integerValue]) {
            if (_withDrawId.length == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                GJJSignAContractWebViewController *rooVC = [GJJSignAContractWebViewController new];
                rooVC.title = @"签订合同";
                rooVC.url = [NSString stringWithFormat:@"%@&type=3",dict[@"link"]];
                rooVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:rooVC animated:YES];
            }
        }else {
            [self setHudWithName:@"保存银行卡信息失败" Time:1 andType:1];
        }
    }else if (self.requestCount == GJJChangeBingCardRequestSupportedBank) {
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
    if (self.requestCount == GJJChangeBingCardRequestData) {
        [self setupView];
    }else if (self.requestCount == GJJChangeBingCardRequestSubmit) {
        switch ([dict[@"status"] integerValue]) {
            case 1:
                
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                [self.navigationController popViewControllerAnimated:YES];
            default:
                break;
        }
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
    
    [self prepareDataWithCount:GJJChangeBingCardRequestGetCode];
}

- (void)changePhoneClick
{
    _phoneText.userInteractionEnabled = YES;
}

- (void)timerFired
{
    NSLog(@"%s", __func__);
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
    
    [self prepareDataWithCount:GJJChangeBingCardRequestSubmit];
}


#pragma mark - GJJBindCardScanSuccessViewDelegate
- (void)bankCardScanSureInfoWithDict:(NSDictionary *)dict infoView:(GJJBindCardScanSuccessView *)infoView
{
    _successView = infoView;
    _scanSuccessDict = dict;
    [self prepareDataWithCount:GJJChangeBingCardRequestSupportedBank];
}

- (void)bankCardRescan
{
    [self scanBankCard];
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
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
        }
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
