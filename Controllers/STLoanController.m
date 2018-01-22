//
//  STLoanController.m
//  XianJinDaiSystem
//
//  Created by 孙涛 on 2017/9/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STLoanController.h"


#import "WQLogViewController.h"
#import "CCXBillDetailViewController.h"
#import "CCXUser.h"
#import "GJJPicInfoModel.h"
#import "WQQuickRepayViewController.h"
#import "GJJHomePageModel.h"
#import "GJJShowNoticeGuideView.h"
#import "GJJUserToSignViewController.h"
#import "GJJSignContactsModel.h"
#import "STAdultIdentityVerifyViewController.h"
#import "SDAutoLayout.h"
#import "GJJInfoSuccessHintViewController.h"
#import "CCXBillViewController.h"
#import "GJJQueryServiceUrlModel.h"
//学生
#import "GJJIdentityVerifyViewController.h"
#import "GJJUserBindBankCardViewController.h"
#import "GJJUserLinkManViewController.h"
#import "GJJSelfInfomationViewController.h"
#import "GJJUserOperatorsCreditViewController.h"
#import "GJJUserInfomationViewController.h"

//成人
#import "GJJAdultIdentityVerifyViewController.h"
#import "GJJAdultUserBindBankCardViewController.h"
#import "GJJAdultUserLinkManViewController.h"
#import "GJJAdultSelfInfomationViewController.h"
#import "GJJAdultUserOperatorsCreditViewController.h"
#import "GJJAdultUserInfomationViewController.h"

@interface STLoanController ()<UIAlertViewDelegate,
GJJShowNoticeGuideViewDelegate>
@property (nonatomic,strong)UIButton *moneyLeftBtn;
@property (nonatomic,strong)UIButton *moneyRightBtn;
@property (nonatomic,strong)UIButton *monthLeftBtn;
@property (nonatomic,strong)UIButton *monthRightBtn;

@property (nonatomic,copy)NSString *borrowMoney;
@property (nonatomic,copy)NSString *borrowDate;
@end

@implementation STLoanController
{
    NSMutableArray *_picList;
    BOOL _isNeedShowAlert;
    GJJHomePageModel *_homePageModel;
}

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"借款界面";
    
    //    [self isNeedShowGuide];
    [self setupData];
    [self prepareDataWithCount:0];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.backgroundColor = CCXColorWithHex(@"#FFFFFF");
    //talkingData
    [TalkingData trackEvent:@"我要借款界面"];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeAll;
}
#endif

- (void)isNeedShowGuide
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *updateVersionNeedShowGuideString = [NSString stringWithFormat:@"%@NeedShowGuide", version];
    NSString *savedVersion = [[NSUserDefaults standardUserDefaults] objectForKey:GJJNeedShowGuide];
    if (![savedVersion isEqualToString:updateVersionNeedShowGuideString]) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:updateVersionNeedShowGuideString forKey:GJJNeedShowGuide];
        [userDefaults synchronize];
        
        [self showGuideViewWithUpdateString:updateVersionNeedShowGuideString];
    }
}

- (void)showGuideViewWithUpdateString:(NSString *)updateString
{
    GJJShowNoticeGuideView *guideView = [[GJJShowNoticeGuideView alloc]init];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:guideView];
    guideView.delegate = self;
    [guideView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

#pragma mark - GJJShowNoticeGuideViewDelegate
- (void)jumpToNoticeTabbarAndCloseGuideView:(GJJShowNoticeGuideView *)guideView
{
    [guideView removeFromSuperview];
    self.tabBarController.selectedIndex = 1;
}

- (void)setupData
{
    _picList = [NSMutableArray arrayWithCapacity:0];
    _isNeedShowAlert = YES;
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self prepareDataWithCount:0];
    [self setClearNavigationBar];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, ScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   CCXColorWithRGB(233, 233, 235).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBarController.tabBar setShadowImage:img];
    
    CGRect rectc = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rectc.size);
    CGContextRef contextc = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextc, [UIColor whiteColor].CGColor);
    CGContextFillRect(contextc, rectc);
    UIImage *imagec = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBarController.tabBar setBackgroundImage:imagec];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 父类方法

/**
 设置网络请求的参数
 */
-(void)setRequestParams{
    CCXUser *seccsion = [self getSeccsion];
    if (0 == self.requestCount) {//获取额度和利率
        self.cmd = CCXHomePage;
        self.dict = @{@"userId": seccsion.userId};
    }else if (1 == self.requestCount){//查询是否能够提交申请
        self.cmd = CCXQueryIsBorrow;
        self.dict = @{@"userId": seccsion.userId,@"loanAmt":[NSString stringWithFormat:@"%d",[_borrowMoney intValue]],@"borrowDays":[NSString stringWithFormat:@"%d",[_borrowDate intValue]]};
        
//        MyLog(@"dict-->%@",self.dict);
        
    }else if (2 == self.requestCount) {//查询资料进度
        self.cmd = GJJQuerySchedule;
        self.dict = @{@"userId":[self getSeccsion].userId};
    }
}

/**
 网络请求成功之后调用
 
 @param dict detail内容
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (0 == self.requestCount) {//获取额度和利率
        _homePageModel = [GJJHomePageModel yy_modelWithDictionary:dict];
        if (_homePageModel.isVirtualNetworkOperator) {
            CCXUser *user = [self getSeccsion];
            user.isVirtualNetworkOperator = _homePageModel.isVirtualNetworkOperator;
            [self saveSeccionWithUser:user];
        }
        //        _homePageModel.useAmt = @"1200";
        [self.tableV reloadData];
        if (_homePageModel.withId.length > 0) {
            if (_isNeedShowAlert) {
                _isNeedShowAlert = NO;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有一笔借款已审核通过\n尽快签字就可以收款啦！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再等等" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去签字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    CCXBillDetailViewController *billVC = [CCXBillDetailViewController new];
                    billVC.billId = _homePageModel.withId;
                    billVC.mesId = @"";
                    billVC.isJump = @"no";
                    billVC.title = @"订单详情";
                    billVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:billVC animated:YES];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }else if (1 == self.requestCount){//查询是否能够提交申请
        if ([dict[@"resultType"] intValue] == 1) {//资料未完善
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"客官,你提供的资料还不能够享受VIP超级服务哦，快去完善资料吧" delegate:self cancelButtonTitle:@"再等等" otherButtonTitles:@"去完善", nil];
            [alertV show];
        }else{
            CCXBillDetailViewController *detailVC = [[CCXBillDetailViewController alloc]init];
            detailVC.title = @"订单详情";
            detailVC.mesId = @"";
            detailVC.billId = @"";
            detailVC.isJump = @"no";
            detailVC.isPay = @"sure";
            detailVC.orderDict = dict;
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            detailVC.hidesBottomBarWhenPushed = YES;
        }
    }else if (2 == self.requestCount) {
        NSInteger schedule = [dict[@"schedule"] integerValue];
        
        
        
        if ( [_homePageModel.useAmt floatValue] < [_homePageModel.minBorrowAmt floatValue]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"借款金额不能大于可用金额，请重新选择借款金额" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去提额" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [self pushToWihchInfoControllerWithSchedule:schedule dict:dict];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        if (schedule == 8 && [dict[@"zhimaStatus"] integerValue] != 0) {
            
            if ([self.borrowMoney intValue] > [_homePageModel.useAmt intValue] ) {
                [self setHudWithName:@"借款金额不能大于可用金额，请重新选择借款金额" Time:1.0 andType:1];
                return;

            }
            
            [self prepareDataWithCount:1];
        }else {
            
            if (schedule != 8) {
                [_picList removeAllObjects];
                NSArray *picList = dict[@"picList"];
                for (NSDictionary *picDict in picList) {
                    GJJPicInfoModel *model = [GJJPicInfoModel yy_modelWithDictionary:picDict];
                    [_picList addObject:model];
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"客官,你提供的资料还不能够享受VIP超级服务哦，快去完善资料吧" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再等等" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    [self pushToWihchInfoControllerWithSchedule:schedule dict:dict];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if (schedule == 8 && [dict[@"zhimaStatus"] integerValue] == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的芝麻信用未认证，请到我的资料中认证" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                    [self pushToWihchInfoControllerWithSchedule:schedule dict:dict];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [self setHudWithName:dict[@"resultNote"] Time:0.5 andType:1];
}

- (void)pushToWihchInfoControllerWithSchedule:(NSInteger)schedule dict:(NSDictionary *)dict
{
    
    NSInteger getOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_1.integerValue;//简洁审核开关
    if (!getOff) {
        if (schedule == 5 || schedule == 6 || schedule == 7) {
            schedule = 8;
        }
    }
   
    switch (schedule) {
        case 0:
        {
            
            STAdultIdentityVerifyViewController *controller = [[STAdultIdentityVerifyViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"身份认证";
            controller.schedule = schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 1:
        {
           
                GJJAdultIdentityVerifyViewController *controller = [[GJJAdultIdentityVerifyViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"身份认证";
                controller.schedule = schedule;
                if (_picList.count) {
                    GJJPicInfoModel *model = _picList[0];
                    controller.requestIDCardFrontImageString = model.picUrl;
                }
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 2:
        {
            GJJPicInfoModel *frontModel = nil;
            GJJPicInfoModel *backModel = nil;
            if (_picList.count) {
                if (_picList.count == 1) {
                    GJJPicInfoModel *model = _picList[0];
                    if ([model.picType isEqualToString:@"0"]) {
                        frontModel = model;
                    }else {
                        backModel = model;
                    }
                }else if (_picList.count == 2) {
                    GJJPicInfoModel *firstPicModel = _picList[0];
                    GJJPicInfoModel *secondPicModel = _picList[1];
                    if ([firstPicModel.picType isEqualToString:@"0"]) {
                        frontModel = firstPicModel;
                        backModel = secondPicModel;
                    }else {
                        backModel = firstPicModel;
                        frontModel = secondPicModel;
                    }
                }
            }
           
                GJJAdultIdentityVerifyViewController *controller = [[GJJAdultIdentityVerifyViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"身份认证";
                controller.schedule = schedule;
                if (_picList.count) {
                    controller.requestIDCardFrontImageString = frontModel.picUrl;
                    if (_picList.count == 2) {
                        controller.requestIDCardBackImageString = backModel.picUrl;
                    }
                }
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 3:
        {
            STAdultIdentityVerifyViewController *controller = [[STAdultIdentityVerifyViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            if (schedule == 3) {
                controller.title = @"芝麻信用认证";
                
            }else{
                controller.title = @"身份认证";
            }
            
            controller.schedule = schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 4:
        {
            
                GJJAdultUserBindBankCardViewController *controller = [[GJJAdultUserBindBankCardViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"银行卡认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
           
        }
            break;
        case 5:
        {
            
                GJJAdultUserLinkManViewController *controller = [[GJJAdultUserLinkManViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"联系人信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
           
        }
            break;
        case 6:
        {
            
                GJJAdultSelfInfomationViewController *controller = [[GJJAdultSelfInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"在职信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 7:
        {
           
                GJJAdultUserOperatorsCreditViewController *controller = [[GJJAdultUserOperatorsCreditViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"运营商认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 8:
        {
            
                GJJAdultUserInfomationViewController *controller = [[GJJAdultUserInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"我的资料";
                controller.scheduleDict = dict;
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

/**
 下拉刷新触发事件
 */
-(void)headerRefresh{
    [self prepareDataWithCount:0];
}

#pragma mark - tableView代理方法

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptationWidth(240);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 800*CCXSCREENSCALE;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    for (UIView *view in self.headerView.subviews) {
        [view removeFromSuperview];
    }
    self.headerView.backgroundColor = [UIColor clearColor];
    self.headerView.frame = XWMRectMake(0, 0, 375, 240);
    self.headerView.backgroundColor = CCXColorWithRGB(78, 142, 220);
    
//    UIImageView *bgView = [UIImageView new];
//    [bgView setImage:[UIImage imageNamed:@"Loan_indexBg"]];
//    bgView.userInteractionEnabled = YES;
//    [self.headerView addSubview:bgView];
    
    UILabel *useAmount = [UILabel new];
    useAmount.text = @"可用额度 (元)";
    useAmount.textColor = [UIColor whiteColor];
    useAmount.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
    [self.headerView addSubview:useAmount];
    
    UILabel *useAmountMoney = [UILabel new];
    useAmountMoney.text = [NSString stringWithFormat:@"%.f",[_homePageModel.useAmt floatValue]?:0.00];
    useAmountMoney.textColor = [UIColor whiteColor];
    useAmountMoney.font = [UIFont fontWithName:@"mexcellent" size:AdaptationWidth(64)];
    [self.headerView addSubview:useAmountMoney];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = CCXColorWithRGB(65, 131, 192);
    [self.headerView addSubview:line];
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = CCXColorWithRGB(18, 99, 103);
    [self.headerView addSubview:line2];
    
    UILabel *autLabel = [UILabel new];
    autLabel.text = @"授信总额";
    autLabel.textColor = CCXColorWithRBBA(255, 255, 255, 0.64);
    autLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    [self.headerView addSubview:autLabel];
    
    UILabel *autMoneyLabel = [UILabel new];
    autMoneyLabel.text = [NSString stringWithFormat:@"%.f元", _homePageModel.creatAmt?[_homePageModel.creatAmt floatValue]:0];
    
    autMoneyLabel.textColor = CCXColorWithRBBA(255, 255, 255, 0.64);
    autMoneyLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    autMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:autMoneyLabel];
    


    UIButton *needPay = [[UIButton alloc]init];
    [needPay setTitle:[NSString stringWithFormat:@"到期应还 %.2f元 >", _homePageModel.shouldPayAmt?[_homePageModel.shouldPayAmt floatValue]:0.00] forState: UIControlStateNormal];
    [needPay setTitleColor:CCXColorWithRGB(141, 155, 169) forState:UIControlStateNormal];
    [needPay.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [needPay addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview: needPay];
    
    
    
    
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.headerView);
//    }];
    [useAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView).offset(AdaptationWidth(80));
        make.left.mas_equalTo(self.headerView).offset(16);
    }];

    [useAmountMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(useAmount.mas_bottom).offset(5);
        make.left.mas_equalTo(self.headerView).offset(16);
    }];
    

    [autMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(useAmountMoney);
    }];

    [autLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(autMoneyLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(useAmountMoney);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(autLabel.mas_left).offset(-16);
        make.centerY.mas_equalTo(useAmountMoney);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(autLabel);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(line.mas_left).offset(-0.5);
        make.centerY.mas_equalTo(useAmountMoney);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(autLabel);
    }];
    [needPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView).offset(16);
        make.bottom.mas_equalTo(self.headerView).offset(-AdaptationWidth(4));
    }];
    
    return self.headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //默认一进来借款为1000元，7天
    _borrowDate = _homePageModel.minDayLine ?: @"7";
    _borrowMoney = _homePageModel.maxBorrowAmt ?: @"1000";
    
    UIView *view = [UIView new];
    view.frame = CCXRectMake(0, 0, 750, 800);
    view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    view.userInteractionEnabled = YES;
    
    UILabel *amountLabel = [UILabel new];
    amountLabel.text = @"借款金额 (元)";
    amountLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    amountLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.48);
    [view addSubview:amountLabel];
    
    amountLabel.sd_layout
    .leftSpaceToView(view,16)
    .topSpaceToView(view,50*CCXSCREENSCALE)
    .rightSpaceToView(view, 20)
    .heightIs(30*CCXSCREENSCALE);
    



    _moneyLeftBtn = [UIButton new];
    _moneyLeftBtn.backgroundColor = [UIColor whiteColor];
    [_moneyLeftBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.minBorrowAmt intValue]?:500] forState:UIControlStateNormal];

     _moneyLeftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_moneyLeftBtn setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_moneyLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateHighlighted];
    [_moneyLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected];
    [_moneyLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected | UIControlStateHighlighted];

    [_moneyLeftBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [_moneyLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_moneyLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [_moneyLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    _moneyLeftBtn.titleLabel.backgroundColor = [UIColor whiteColor];
   
    _moneyLeftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_moneyLeftBtn addTarget:self action:@selector(moneyLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_moneyLeftBtn];
    
    
    _moneyLeftBtn.sd_layout
    .leftSpaceToView(view, 16)
    .topSpaceToView(amountLabel, 20)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(80*CCXSCREENSCALE);
    
    if (iOS9) {
        //  设置button的图片的约束
        _moneyLeftBtn.imageView.sd_layout
        .leftSpaceToView(_moneyLeftBtn, 0)
        .centerYEqualToView(_moneyLeftBtn)
        .heightRatioToView(_moneyLeftBtn, 0.7)
        .widthEqualToHeight();
        
        // 设置button的label的约束
        _moneyLeftBtn.titleLabel.sd_layout
        .topSpaceToView(_moneyLeftBtn, 10)
        .leftSpaceToView(_moneyLeftBtn.imageView,0)
        .rightEqualToView(_moneyLeftBtn)
        .bottomSpaceToView(_moneyLeftBtn, 10);
    }else{
        _moneyLeftBtn.imageView.sd_layout
        .leftSpaceToView(_moneyLeftBtn, 0)
        .centerYEqualToView(_moneyLeftBtn)
        .heightIs(AdaptationWidth(28))
        .widthIs(AdaptationWidth(28));
        
        // 设置button的label的约束
        _moneyLeftBtn.titleLabel.sd_layout
        .topSpaceToView(_moneyLeftBtn, 10)
        .widthIs(AdaptationWidth(64))
        .rightEqualToView(_moneyLeftBtn)
        .bottomSpaceToView(_moneyLeftBtn, 10);

    }
    
    
    
    _moneyRightBtn = [UIButton new];
    _moneyRightBtn.backgroundColor = [UIColor whiteColor];
    [_moneyRightBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.maxBorrowAmt intValue]?:1000] forState:UIControlStateNormal];
    [_moneyRightBtn setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_moneyRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateHighlighted];
    [_moneyRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected];
    [_moneyRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_moneyRightBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [_moneyRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_moneyRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [_moneyRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    _moneyRightBtn.selected = YES;
    _moneyRightBtn.titleLabel.backgroundColor = [UIColor whiteColor];
    _moneyRightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _moneyRightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_moneyRightBtn addTarget:self action:@selector(moneyRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_moneyRightBtn];
    
    
    _moneyRightBtn.sd_layout
    .leftSpaceToView(view, ScreenWidth/2.0)
    .topSpaceToView(amountLabel, 20)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(80*CCXSCREENSCALE);
    
    
    if (iOS9) {
        // 设置button的图片的约束
        _moneyRightBtn.imageView.sd_layout
        .leftSpaceToView(_moneyRightBtn, 0)
        .centerYEqualToView(_moneyRightBtn)
        .heightRatioToView(_moneyRightBtn, 0.7)
        .widthEqualToHeight();
        
        // 设置button的label的约束
        _moneyRightBtn.titleLabel.sd_layout
        .topSpaceToView(_moneyRightBtn, 10)
        .leftSpaceToView(_moneyRightBtn.imageView,0)
        .rightEqualToView(_moneyRightBtn)
        .bottomSpaceToView(_moneyRightBtn, 10);

    }else{
        _moneyRightBtn.imageView.sd_layout
        .leftSpaceToView(_moneyRightBtn, 0)
        .centerYEqualToView(_moneyRightBtn)
        .heightIs(AdaptationWidth(28))
        .widthIs(AdaptationWidth(28));
        
        // 设置button的label的约束
        _moneyRightBtn.titleLabel.sd_layout
        .topSpaceToView(_moneyRightBtn, 10)
        .widthIs(140*CCXSCREENSCALE)
        .rightEqualToView(_moneyRightBtn)
        .bottomSpaceToView(_moneyRightBtn, 10);

    }
    
    
    
    
    
    UIView *seperator = [UIView new];
    seperator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [view addSubview:seperator];
    
    seperator.sd_layout
    .leftSpaceToView(view,16)
    .topSpaceToView(view,250*CCXSCREENSCALE)
    .rightSpaceToView(view, 20)
    .heightIs(1);
    
    UILabel *dateLabel = [UILabel new];
    dateLabel.text = @"借款期限 (天)";
    dateLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    dateLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.48);
    [view addSubview:dateLabel];
    
    dateLabel.sd_layout
    .leftSpaceToView(view,16)
    .topSpaceToView(seperator,50*CCXSCREENSCALE)
    .rightSpaceToView(view, 20)
    .heightIs(30*CCXSCREENSCALE);
    
    _monthLeftBtn = [UIButton new];
    _monthLeftBtn.backgroundColor = [UIColor whiteColor];
    [_monthLeftBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.minDayLine intValue]?:7] forState:UIControlStateNormal];
    [_monthLeftBtn setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_monthLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateHighlighted];
    [_monthLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected];
    [_monthLeftBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_monthLeftBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [_monthLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_monthLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [_monthLeftBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    _monthLeftBtn.selected = YES;
    _monthLeftBtn.titleLabel.backgroundColor = [UIColor whiteColor];
    _monthLeftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _monthLeftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_monthLeftBtn addTarget:self action:@selector(monthLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_monthLeftBtn];
    
    
    _monthLeftBtn.sd_layout
    .leftSpaceToView(view, 16)
    .topSpaceToView(dateLabel, 20)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(80*CCXSCREENSCALE);
    
    if (iOS9) {
        //设置button的图片的约束
        _monthLeftBtn.imageView.sd_layout
        .leftSpaceToView(_monthLeftBtn, 0)
        .centerYEqualToView(_monthLeftBtn)
        .heightRatioToView(_monthLeftBtn, 0.7)
        .widthEqualToHeight();
        
        // 设置button的label的约束
        _monthLeftBtn.titleLabel.sd_layout
        .topSpaceToView(_monthLeftBtn, 10)
        .leftSpaceToView(_monthLeftBtn.imageView,0)
        .rightEqualToView(_monthLeftBtn)
        .bottomSpaceToView(_monthLeftBtn, 10);

    }else{
        _monthLeftBtn.imageView.sd_layout
        .leftSpaceToView(_monthLeftBtn, 0)
        .centerYEqualToView(_monthLeftBtn)
        .heightIs(AdaptationWidth(28))
        .widthIs(AdaptationWidth(28));
        
        // 设置button的label的约束
        _monthLeftBtn.titleLabel.sd_layout
        .topSpaceToView(_monthLeftBtn, 10)
        .widthIs(140*CCXSCREENSCALE)
        .rightEqualToView(_monthLeftBtn)
        .bottomSpaceToView(_monthLeftBtn, 10);
    }
    
    

    

    
    
    _monthRightBtn = [UIButton new];
    _monthRightBtn.backgroundColor = [UIColor whiteColor];
    [_monthRightBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.maxDayLine intValue]?:14] forState:UIControlStateNormal];
    [_monthRightBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.maxDayLine intValue]?:14] forState:UIControlStateSelected];
    [_monthRightBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.maxDayLine intValue]?:14] forState:UIControlStateHighlighted];
    [_monthRightBtn setTitle:[NSString stringWithFormat:@"%d",[_homePageModel.maxDayLine intValue]?:14] forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_monthRightBtn setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_monthRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateHighlighted];
    [_monthRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected];
    [_monthRightBtn setTitleColor:CCXColorWithRGB(78, 142 , 220) forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [_monthRightBtn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [_monthRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_monthRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [_monthRightBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    _monthRightBtn.titleLabel.backgroundColor = [UIColor whiteColor];
    _monthRightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _monthRightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_monthRightBtn addTarget:self action:@selector(monthRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_monthRightBtn];
    
    
    
    _monthRightBtn.sd_layout
    .leftSpaceToView(view, ScreenWidth/2.0)
    .topSpaceToView(dateLabel, 20)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(80*CCXSCREENSCALE);
    
    if (iOS9) {
        // 设置button的图片的约束
        _monthRightBtn.imageView.sd_layout
        .leftSpaceToView(_monthRightBtn, 0)
        .centerYEqualToView(_monthRightBtn)
        .heightRatioToView(_monthRightBtn, 0.7)
        .widthEqualToHeight();

        // 设置button的label的约束
        _monthRightBtn.titleLabel.sd_layout
        .topSpaceToView(_monthRightBtn, 10)
        .leftSpaceToView(_monthRightBtn.imageView,0)
        .rightEqualToView(_monthRightBtn)
        .bottomSpaceToView(_monthRightBtn, 10);

    }else{
        _monthRightBtn.imageView.sd_layout
        .leftSpaceToView(_monthRightBtn, 0)
        .centerYEqualToView(_monthRightBtn)
        .heightIs(AdaptationWidth(28))
        .widthIs(AdaptationWidth(28));
        
        // 设置button的label的约束
        _monthRightBtn.titleLabel.sd_layout
        .topSpaceToView(_monthRightBtn, 10)
        .widthIs(140*CCXSCREENSCALE)
        .rightEqualToView(_monthRightBtn)
        .bottomSpaceToView(_monthRightBtn, 10);

    }
    

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"我要借款" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    button.backgroundColor = CCXColorWithRGB(78, 142, 220);
    button.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    button.layer.cornerRadius = AdaptationWidth(5);

  
    [button addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];

    button.sd_layout
    .leftSpaceToView(view,16)
    .topSpaceToView(_monthLeftBtn,70*CCXSCREENSCALE)
    .rightSpaceToView(view, 16)
    .heightIs(AdaptationWidth(48));
    
    
    UILabel *detailLab = [[UILabel alloc]init];
    detailLab.textAlignment = NSTextAlignmentCenter;
    detailLab.numberOfLines = 2;
    detailLab.font = [UIFont systemFontOfSize:AdaptationWidth(12)];
    detailLab.textColor = CCXColorWithRBBA(34, 58, 80, 0.6);
//    NSInteger getOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_1.integerValue;//
    [detailLab setText:@"Copyright 2017 Xin Baobao (Xiamen) network leading information intermediary service Co., Ltd."];
    
    
    [view addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(button.mas_bottom).offset(AdaptationWidth(12));
        make.centerX.mas_equalTo(button);
    }];
   
    
    return view;
}

#pragma mark - alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [self prepareDataWithCount:2];
    }
}

#pragma mark - 自定义方法

-(void)moneyLeftButtonClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        _moneyRightBtn.selected = NO;
        _borrowMoney = _homePageModel.minBorrowAmt ?: @"500";
    }
    
    
//    sender.selected = !sender.selected;
//   
//    if (sender.selected) {
//        _moneyRightBtn.selected = NO;
//        _borrowMoney = @"500";
//    }else{
//        _moneyRightBtn.selected = YES;
//        _borrowMoney = @"1000";
//    }
}

-(void)moneyRightButtonClick:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
        _moneyLeftBtn.selected = NO;
        _borrowMoney = _homePageModel.maxBorrowAmt ?: @"1000";
        
    }

}

-(void)monthLeftButtonClick:(UIButton *)sender{

    if (sender.selected == NO) {
        sender.selected = YES;
        _monthRightBtn.selected = NO;
        _borrowDate = _homePageModel.minDayLine ?: @"7";
        
    }
}

-(void)monthRightButtonClick:(UIButton *)sender{

    if (sender.selected == NO) {
        sender.selected = YES;
        _monthLeftBtn.selected = NO;
        _borrowDate = _homePageModel.maxDayLine ?: @"14";
        
    }


}

#pragma mark -btn
- (void)onBtnClick:(UIButton *)sender{
    CCXUser *user = [self getSeccsion];
    if ([user.userId intValue] == -100) {
        [self pushToLoin];
        return;
    }
    
    //talkingdata
    [TalkingData trackEvent:@"我的账单"];
    
    CCXBillViewController *billVC = [CCXBillViewController new];
    billVC.hidesBottomBarWhenPushed = YES;
    billVC.title = @"我的账单";
    [self.navigationController pushViewController:billVC animated:YES];
}
- (void)pushToLoin
{
    WQLogViewController *loginVC = [WQLogViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.title = @"登录";
    loginVC.popViewController = self;
    loginVC.block = ^(id result) {
        if ([GJJQueryServiceUrlModel sharedInstance].switch_on_off_3.integerValue == 1 ) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更多贷款产品" message:@"是否进入全网贷超市" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[GJJQueryServiceUrlModel sharedInstance].switch_on_off_3_url]];
//                NSLog(@"%@",[GJJQueryServiceUrlModel sharedInstance].switch_on_off_3_url);
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:NO completion:nil];
        }
    };
    [self.navigationController pushViewController:loginVC animated:YES];
}
/**
 提交申请按钮
 */
-(void)submitClick{
    CCXUser *seccsion = [self getSeccsion];
    if ([seccsion.userId intValue] != -100) {
        
        //        if ([seccsion.orgId isEqualToString:@"0"]) {
        //            [self setHudWithName:@"暂不提供该功能" Time:1 andType:1];
        //            return;
        //        }
    
        [self prepareDataWithCount:2];
    }else{
        WQLogViewController *loginVC = [WQLogViewController new];
        loginVC.title = @"登录";
        loginVC.popViewController = self;
        loginVC.hidesBottomBarWhenPushed = YES;
        loginVC.block = ^(id result) {
            if ([GJJQueryServiceUrlModel sharedInstance].switch_on_off_3.integerValue == 1 ) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更多贷款产品" message:@"是否进入全网贷超市" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[GJJQueryServiceUrlModel sharedInstance].switch_on_off_3_url]];
                    //                NSLog(@"%@",[GJJQueryServiceUrlModel sharedInstance].switch_on_off_3_url);
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:NO completion:nil];
            }
        };
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

/**
 创建一个有上下两个标题的view
 
 @param headerName 上面标题
 @param footerName 下面标题
 
 @return 组合的view
 */
-(UIView *)setViewWithHeader:(NSString *)headerName footerName:(NSString *)footerName{
    UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 142, 80)];
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CCXRectMake(0, 0, 142, 28)];
    headerLabel.text = headerName;
    headerLabel.textColor = CCXColorWithHex(@"#ffffff");
    headerLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    headerLabel.adjustsFontSizeToFitWidth = YES;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:headerLabel];
    UILabel *footerLabel = [[UILabel alloc]initWithFrame:CCXRectMake(0, 40, 142, 40)];
    footerLabel.text = footerName;
    footerLabel.textColor = CCXColorWithHex(@"#ffffff");
    footerLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    footerLabel.adjustsFontSizeToFitWidth = YES;
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:footerLabel];
    return view;
}

/**
 创建一个左图标右标题的组合图形
 
 @param imageName 图片名字
 @param title     标题名
 
 @return 组合的view
 */
-(UIView *)setViewWithImage:(NSString *)imageName Name:(NSString *)title{
    UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 245, 34)];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageV.frame = CCXRectMake(0, 0, 34, 34);
    [view addSubview:imageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(38, 0, 245, 34)];
    label.text = title;
    label.textColor = CCXColorWithHex(@"#ffffff");
    label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    label.adjustsFontSizeToFitWidth = YES;
    [view addSubview:label];
    [view addSubview:label];
    return view;
}

/**
 创建一个带标题的label
 
 @param title 标题
 
 @return label
 */
-(UILabel *)setLeLabelWithTitle:(NSString *)title{
    UILabel *Label = [[UILabel alloc]initWithFrame:CCXRectMake(20, 10, 200,20)];
    Label.text = title;
    Label.textColor = CCXColorWithHex(@"#000000");
    Label.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    return Label;
}

#pragma mark - UITapGestureRecognizer
- (void)paybackTap:(UITapGestureRecognizer *)sender
{
    WQQuickRepayViewController *controller = [[WQQuickRepayViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
