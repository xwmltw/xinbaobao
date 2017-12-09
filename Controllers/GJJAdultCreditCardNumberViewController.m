//
//  GJJAdultCreditCardNumberViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultCreditCardNumberViewController.h"
#import "GJJBasicInfoModel.h"
#import "GJJAdultCreditCardNumberModel.h"
#import "GJJDropBankNameView.h"
#import "GJJPaddingLabel.h"
#import "GJJBankModel.h"
#import "GJJBankTableViewCell.h"
#import "GJJBindCardScanSuccessView.h"
#import "GJJAdultChangeCreditCardViewController.h"
#import "STBankInfoCell.h"
#import "STYRHBankInfoCell.h"
#import "GJJChoosePickerView.h"
typedef NS_ENUM(NSInteger, GJJAdultCreditCardNumberRequest) {
    GJJAdultCreditCardNumberRequestData,
    GJJAdultCreditCardNumberRequestBankList,
    GJJAdultCreditCardNumberRequestSubmit,
    GJJAdultCreditCardNumberRequestSupportedBank,
};

@interface GJJAdultCreditCardNumberViewController ()
<MBProgressHUDDelegate,
GJJBindCardScanSuccessViewDelegate,GJJChoosePickerViewDelegate>
@property (nonatomic,strong)GJJChoosePickerView *chooseBankPickerView;
@property (nonatomic, strong) NSMutableArray *bankArray;

@end

@implementation GJJAdultCreditCardNumberViewController
{
    GJJAdultCreditCardNumberModel *_numberModel;
    GJJDropBankNameView *_dropBankView;
    UITextField *_accountText;
    GJJPaddingLabel *_bankNameLabel;
    UIImageView *_bankImageView;
    UITextField *_passwordText;
    __block GJJBankModel *_selectedModel;
    GJJBindCardScanSuccessView *_scanSuccessView;
    NSDictionary *_bankInfoDict;
    
    GJJBindCardScanSuccessView *_successView;
    NSDictionary *_scanSuccessDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareDataWithCount:GJJAdultCreditCardNumberRequestData];
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJAdultCreditCardNumberRequestData];
}

- (void)setupData
{
    _bankArray = [NSMutableArray array];
}

- (void)setModel:(GJJBasicInfoModel *)model
{
    _model = model;
    if ([model.authenStatus isEqualToString:@"0"]) {
        [self setupView];
    }else {
        [self createTableViewWithFrame:CGRectZero];
        [self.tableV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultCreditCardNumberRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"6"};
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestSubmit) {
        self.cmd = GJJSaveXykAndGjj;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"accont":_accountText.text,
                      @"authenType":@"6",
//                      @"password":_passwordText.text,
                      @"cityOrbank":_bankNameLabel.text};
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestBankList) {
        self.cmd = GJJQueryBankAndLog;
        self.dict = @{};
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestSupportedBank) {
        self.cmd = GJJQuerySupportedBank;
        self.dict = @{@"bankName":_scanSuccessDict[@"bank_name"]};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultCreditCardNumberRequestData) {
        _numberModel = [GJJAdultCreditCardNumberModel yy_modelWithDictionary:dict];
        [self prepareDataWithCount:GJJAdultCreditCardNumberRequestBankList];
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestBankList) {
        [_bankArray removeAllObjects];
        NSArray *detaList = dict[@"detaList"];
        for (NSDictionary *dict in detaList) {
            GJJBankModel *model = [GJJBankModel yy_modelWithDictionary:dict];
            [_bankArray addObject:model];
        }
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];
        if (![_model.authenStatus isEqualToString:@"0"]) {
            UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            changeButton.frame = CGRectMake(0, 0, 64, 64);
            [changeButton setTitle:@"修改" forState:UIControlStateNormal];
            changeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            changeButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
            [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [changeButton addTarget:self action:@selector(changeCard) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:changeButton];
        }
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestSubmit) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.requestCount == GJJAdultCreditCardNumberRequestSupportedBank) {
        self.title = @"信用卡认证";
        [_successView removeFromSuperview];
        _accountText.text = _scanSuccessDict[@"bank_num"];
        _bankNameLabel.text = _scanSuccessDict[@"bank_name"];
        _bankNameLabel.textColor = CCXColorWithHex(@"888888");
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultCreditCardNumberRequestData) {
        [self.tableV.mj_header endRefreshing];
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
    CGFloat maxLabelWidth = [self calculatorMaxWidthWithString:@[@"卡号", @"卡户银行", @"密码"]];
    UIColor *placeholderColor = CCXColorWithHex(@"cacaca");
    
    UIView *accountView = [[UIView alloc]init];
    [self.view addSubview:accountView];
    accountView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    accountView.layer.cornerRadius = 5;
    accountView.layer.masksToBounds = YES;
    [accountView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(@22);
        make.left.equalTo(self.view.mas_left).offset(@20);
        make.right.equalTo(self.view.mas_right).offset(@-20);
        make.height.equalTo(self.view.mas_height).multipliedBy(1.0/14);
    }];
    
    UILabel *accountLabel = [[UILabel alloc]init];
    [accountView addSubview:accountLabel];
    accountLabel.text = @"卡号";
    accountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    accountLabel.textColor = CCXColorWithHex(@"888888");
    [accountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountView.mas_left).offset(@10);
        make.centerY.equalTo(accountView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    UIButton *scanCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountView addSubview:scanCardButton];
    [scanCardButton setImage:[UIImage imageNamed:@"绑定银行卡扫描"] forState:UIControlStateNormal];
    [scanCardButton addTarget:self action:@selector(scanBankCard) forControlEvents:UIControlEventTouchUpInside];
    [scanCardButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accountView).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(accountView);
        make.width.equalTo(@(AdaptationWidth(40)));
        make.height.equalTo(@(AdaptationWidth(30)));
    }];
    
    _accountText = [[UITextField alloc]init];
    [accountView addSubview:_accountText];
    _accountText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _accountText.keyboardType = UIKeyboardTypeNumberPad;
    _accountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请扫描您的信用卡" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _accountText.textColor = CCXColorWithHex(@"888888");
    _accountText.userInteractionEnabled = NO;
    [_accountText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(accountLabel.mas_right).offset(@10);
        make.top.bottom.equalTo(accountView);
        make.right.equalTo(scanCardButton.mas_left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIView *bankView = [[UIView alloc]init];
    [self.view addSubview:bankView];
    bankView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    bankView.layer.cornerRadius = 5;
    bankView.layer.masksToBounds = YES;
    [bankView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountView.mas_bottom).offset(@10);
        make.left.equalTo(self.view.mas_left).offset(@20);
        make.right.equalTo(self.view.mas_right).offset(@-20);
        make.height.equalTo(accountView.mas_height);
    }];
    
    UILabel *bankLabel = [[UILabel alloc]init];
    [bankView addSubview:bankLabel];
    bankLabel.text = @"开户银行";
    bankLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    bankLabel.textColor = CCXColorWithHex(@"888888");
    [bankLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankView.mas_left).offset(@10);
        make.centerY.equalTo(bankView.mas_centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _bankNameLabel = [[GJJPaddingLabel alloc]init];
    [bankView addSubview:_bankNameLabel];
    _bankNameLabel.userInteractionEnabled = YES;
    _bankNameLabel.font = [UIFont systemFontOfSize:14];
    _bankNameLabel.textColor = CCXColorWithHex(@"cacaca");
    _bankNameLabel.text = @"请选择开户银行";
    _bankNameLabel.adjustsFontSizeToFitWidth = YES;
    _bankNameLabel.layer.cornerRadius = 5;
    _bankNameLabel.layer.masksToBounds = YES;
    _bankNameLabel.layer.borderWidth = 0.5;
    UIColor *lineColor = CCXColorWithHex(@"e7e7e7");
    _bankNameLabel.layer.borderColor = lineColor.CGColor;
    _bankNameLabel.backgroundColor = [UIColor whiteColor];
//    UITapGestureRecognizer *dropBankTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropBankMenu)];
//    [_bankNameLabel addGestureRecognizer:dropBankTap];
    [_bankNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLabel.mas_right).offset(@10);
        make.height.equalTo(bankView).multipliedBy(6.0/9);
        make.width.equalTo(bankView).multipliedBy(0.5);
        make.centerY.equalTo(bankView.mas_centerY);
    }];
    
    _bankImageView = [[UIImageView alloc]init];
    [bankView addSubview:_bankImageView];
    _bankImageView.image = [UIImage imageNamed:@"银行卡页面图标"];
    _bankImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageDropBankTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dropBankMenu)];
    [_bankImageView addGestureRecognizer:imageDropBankTap];
    [_bankImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankNameLabel);
        make.bottom.equalTo(_bankNameLabel).offset(@5);
        make.left.equalTo(_bankNameLabel.mas_right);
        make.width.equalTo(_bankImageView.mas_height).multipliedBy(27.0/31);
    }];
    
//    UIView *passwordView = [[UIView alloc]init];
//    [self.view addSubview:passwordView];
//    passwordView.backgroundColor = CCXColorWithHex(@"f7f7f8");
//    passwordView.layer.cornerRadius = 5;
//    passwordView.layer.masksToBounds = YES;
//    [passwordView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bankView.bottom).offset(@10);
//        make.left.equalTo(self.view.left).offset(@20);
//        make.right.equalTo(self.view.right).offset(@-20);
//        make.height.equalTo(accountView.height);
//    }];
//    
//    UILabel *passwordLabel = [[UILabel alloc]init];
//    [passwordView addSubview:passwordLabel];
//    passwordLabel.text = @"密码";
//    passwordLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//    passwordLabel.textColor = CCXColorWithHex(@"888888");
//    [passwordLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordView.left).offset(@10);
//        make.centerY.equalTo(passwordView.centerY);
//        make.width.equalTo(maxLabelWidth);
//    }];
//    
//    _passwordText = [[UITextField alloc]init];
//    [passwordView addSubview:_passwordText];
//    _passwordText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//    _passwordText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的信用卡密码" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
//    _passwordText.textColor = CCXColorWithHex(@"888888");
//    [_passwordText makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(passwordLabel.right).offset(@10);
//        make.top.right.bottom.equalTo(passwordView);
//    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_bottom).offset(@50);
        make.left.equalTo(self.view.mas_left).offset(@20);
        make.right.equalTo(self.view.mas_right).offset(@-20);
        make.height.equalTo(self.view.mas_height).multipliedBy(1.0/13);
    }];
    
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_numberModel) {
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
    return 90;
//    return AdaptationHeight(150);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GJJBankTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GJJBankTableViewCell class]) owner:self options:nil]lastObject];
//    [cell.bankImageView setImageWithURL:[NSURL URLWithString:_numberModel.bankLogUrl] placeholderImage:[UIImage imageNamed:@"加载图"]];
//    NSString *securityStr = [_numberModel.xykzh stringByReplacingCharactersInRange:NSMakeRange((_numberModel.xykzh.length - 8) / 2, 8) withString:@"********"];
//    cell.bankNameLabel.text = _numberModel.bankName;
//    cell.bankCardLabel.text = securityStr;
    
    
    
    static NSString *cellId = @"cellId";
    
    STYRHBankInfoCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[STYRHBankInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.creditCardNumberModel = _numberModel;

    
//    STBankInfoCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[STBankInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    cell.creditCardNumberModel = _numberModel;
    
    return cell;
}

#pragma mark - UITapGestureRecognizer
- (void)dropBankMenu
{
    if (_bankArray.count == 0) {
        [self prepareDataWithCount:GJJAdultCreditCardNumberRequestBankList];
    }else {
        [self showPickerView];
    }
}

- (void)showPickerView
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
    _bankNameLabel.text = thing;
    _bankNameLabel.textColor = CCXColorWithHex(@"888888");
    _selectedModel = _bankArray[row];
}





- (void)showDropView
{
    if (_dropBankView) {
        [_dropBankView removeFromSuperview];
        _dropBankView = nil;
    }else {
        _dropBankView = [[GJJDropBankNameView alloc]init];
        [self.view addSubview:_dropBankView];
        _dropBankView.bankArray = _bankArray;
        [_dropBankView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bankNameLabel.bottom).offset(@5);
            make.height.equalTo(@(44*4));
            make.left.equalTo(_bankNameLabel.left);
            make.right.equalTo(_bankImageView.right);
        }];
        
        __weak typeof (self)weak = self;
        _dropBankView.returnBank = ^(GJJBankModel *model) {
            __strong typeof(weak) weakself = weak;
            weakself->_bankNameLabel.text = model.bankName;
            weakself->_bankNameLabel.textColor = CCXColorWithHex(@"888888");
            _selectedModel = model;
            _dropBankView = nil;
        };
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_dropBankView) {
        [_dropBankView removeFromSuperview];
    }
}

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if (_accountText.text.length == 0) {
        [self setHudWithName:@"请输入您的信用卡账号" Time:1 andType:1];
        return;
    }
    
    if (_accountText.text.length < 9) {
        [self setHudWithName:@"请输入有效的信用卡账号" Time:1 andType:1];
        return;
    }
    
    if ([_bankNameLabel.text isEqualToString:@"请选择开户银行"]) {
        [self setHudWithName:@"请选择开户银行" Time:1 andType:1];
        return;
    }
    
//    if (_passwordText.text.length == 0) {
//        [self setHudWithName:@"请输入您的信用卡密码" Time:1 andType:1];
//        return;
//    }
    
    [self prepareDataWithCount:GJJAdultCreditCardNumberRequestSubmit];
}

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

- (void)changeCard
{
    GJJAdultChangeCreditCardViewController *controller = [[GJJAdultChangeCreditCardViewController alloc]init];
    controller.title = @"信用卡认证";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - GJJBindCardScanSuccessViewDelegate
- (void)bankCardScanSureInfoWithDict:(NSDictionary *)dict infoView:(GJJBindCardScanSuccessView *)infoView
{
    _successView = infoView;
    _scanSuccessDict = dict;
    [self prepareDataWithCount:GJJAdultCreditCardNumberRequestSupportedBank];
}

- (void)bankCardRescan
{
    [self scanBankCard];
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
