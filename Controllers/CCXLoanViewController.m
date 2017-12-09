//
//  CCXLoanViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXLoanViewController.h"
#import "CCXWaveProgressView.h"
#import "WQLogViewController.h"
#import "CCXBillDetailViewController.h"
#import "CCXSlider.h"
#import "CCXUser.h"
#import "GJJPicInfoModel.h"
#import "WQQuickRepayViewController.h"
#import "GJJHomePageModel.h"
#import "GJJShowNoticeGuideView.h"
#import "GJJUserToSignViewController.h"
#import "GJJSignContactsModel.h"
#import "STAdultIdentityVerifyViewController.h"

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

@interface CCXLoanViewController ()<
UIAlertViewDelegate,
GJJShowNoticeGuideViewDelegate
>

@property(nonatomic,strong)CCXWaveProgressView *waveView;//水波
@property(nonatomic,strong)UIView *repayMonView;//每期还款显示
@property(nonatomic,strong)UISlider *moneySlider;//贷款金额滑动条
@property(nonatomic,strong)UILabel *minMoneyLabel;//贷款金额显示
@property(nonatomic,strong)UILabel *moneyLabel;//贷款金额显示
@property(nonatomic,strong)UISlider *monthSlider;//贷款月数滑动条
@property(nonatomic,strong)UILabel *minMonthLabel;//贷款月数显示
@property(nonatomic,strong)UILabel *monthLabel;//贷款月数显示
@property(nonatomic,assign)CGFloat p;//贷款利率

@end

@implementation CCXLoanViewController
{
    NSMutableArray *_picList;
    BOOL _isNeedShowAlert;
    GJJHomePageModel *_homePageModel;
}

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self isNeedShowGuide];
    [self setupData];
    [self prepareDataWithCount:0];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.backgroundColor = CCXColorWithHex(@"#FFFFFF");
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
        if ([_homePageModel.useAmt intValue] <= 1000) {
            self.dict = @{@"userId": seccsion.userId,
                          @"loanAmt":[NSString stringWithFormat:@"%d",(int)self.moneySlider.value * 100],
                          @"borrowDays":[NSString stringWithFormat:@"%d",(int)self.monthSlider.value] };
        }else{
            self.dict = @{@"userId": seccsion.userId,
                          @"loanAmt":[NSString stringWithFormat:@"%d",(int)self.moneySlider.value * 500],
                          @"borrowDays":[NSString stringWithFormat:@"%d",(int)self.monthSlider.value] };
        }
        
        MyLog(@"dict-->%@",self.dict);

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
        [_repayMonView removeFromSuperview];
        _repayMonView = [self setViewWithImage:@"每期还款" Name:[NSString stringWithFormat:@"本月待还：%.2f元",[_homePageModel.shouldPayAmt doubleValue]]];
        _repayMonView.frame = CCXRectMake(58, 430, 245, 34);
        [self.headerView addSubview:_repayMonView];
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"额度小于500，不能提现，赶紧去提高额度吧" preferredStyle:UIAlertControllerStyleAlert];
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
            
            
            if ([_homePageModel.useAmt intValue] <= 1000) {
                if ((int)self.moneySlider.value * 100 < [_homePageModel.minBorrowAmt intValue]) {
                    [self setHudWithName:@"借款金额不足500元，不能提现！" Time:1.0 andType:1];
                    return;
                }

            }else{
                if ((int)self.moneySlider.value * 500 < [_homePageModel.minBorrowAmt intValue]) {
                    [self setHudWithName:@"借款金额不足500元，不能提现！" Time:1.0 andType:1];
                    return;
                }
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
    switch (schedule) {
        case 0:
        {
//            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
//                GJJIdentityVerifyViewController *controller = [[GJJIdentityVerifyViewController alloc]init];
//                controller.hidesBottomBarWhenPushed = YES;
//                controller.title = @"身份认证";
//                controller.schedule = schedule;
//                controller.popViewController = self;
//                [self.navigationController pushViewController:controller animated:YES];
//            }else {
//                GJJAdultIdentityVerifyViewController *controller = [[GJJAdultIdentityVerifyViewController alloc]init];
//                controller.hidesBottomBarWhenPushed = YES;
//                controller.title = @"身份认证";
//                controller.schedule = schedule;
//                controller.popViewController = self;
//                [self.navigationController pushViewController:controller animated:YES];
//            }
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
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJIdentityVerifyViewController *controller = [[GJJIdentityVerifyViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"身份认证";
                controller.schedule = schedule;
                if (_picList.count) {
                    GJJPicInfoModel *model = _picList[0];
                    controller.requestIDCardFrontImageString = model.picUrl;
                }
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
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
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJIdentityVerifyViewController *controller = [[GJJIdentityVerifyViewController alloc]init];
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
            }else {
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
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJUserBindBankCardViewController *controller = [[GJJUserBindBankCardViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"银行卡认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                GJJAdultUserBindBankCardViewController *controller = [[GJJAdultUserBindBankCardViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"银行卡认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 5:
        {
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJUserLinkManViewController *controller = [[GJJUserLinkManViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"联系人信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
                
            }else {
                GJJAdultUserLinkManViewController *controller = [[GJJAdultUserLinkManViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"联系人信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 6:
        {
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJSelfInfomationViewController *controller = [[GJJSelfInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"在校信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                GJJAdultSelfInfomationViewController *controller = [[GJJAdultSelfInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"在职信息";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 7:
        {
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJUserOperatorsCreditViewController *controller = [[GJJUserOperatorsCreditViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"运营商认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                GJJAdultUserOperatorsCreditViewController *controller = [[GJJAdultUserOperatorsCreditViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"运营商认证";
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
            break;
        case 8:
        {
            if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                GJJUserInfomationViewController *controller = [[GJJUserInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"我的资料";
                controller.scheduleDict = dict;
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                GJJAdultUserInfomationViewController *controller = [[GJJAdultUserInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"我的资料";
                controller.scheduleDict = dict;
                controller.schedule = schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
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
    return 484*CCXSCREENSCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 800*CCXSCREENSCALE;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    for (UIView *view in self.headerView.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 500)];
    backImageView.image = [UIImage imageNamed:@"home_bg_header"];
    [self.headerView addSubview:backImageView];
    
    UIImageView *circleImg = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 330, 750, 60)];
    circleImg.image = [UIImage imageNamed:@"弯弧"];
    [self.headerView addSubview:circleImg];
    
    UIImageView *waveBackgroundImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(242, 96, 266, 266)];
    waveBackgroundImageView.image = [UIImage imageNamed:@"home_bg_wave"];
    [self.headerView addSubview:waveBackgroundImageView];
    
    self.waveView = [[CCXWaveProgressView alloc]initWithFrame:CCXRectMake(3, 3, 260, 260)];
    self.waveView.waveViewMargin = UIEdgeInsetsMake(0, 0, 0, 0);
    self.waveView.backgroundImageView.image = [UIImage imageNamed:@"home_bg_wave"];
    self.waveView.numberLabel.text = _homePageModel.useAmt;
    self.waveView.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.waveView.numberLabel.font = [UIFont boldSystemFontOfSize:60*CCXSCREENSCALE];
    self.waveView.numberLabel.textColor = [UIColor colorWithHexString:STBtnTextColor];
    self.waveView.explainLabel.text = @"可用金额";
    self.waveView.explainLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    self.waveView.explainLabel.adjustsFontSizeToFitWidth = YES;
    self.waveView.explainLabel.textColor = [UIColor colorWithHexString:STBtnTextColor];
    self.waveView.percent = [_homePageModel.useAmt floatValue]/[_homePageModel.creatAmt floatValue];
    if (self.waveView.percent>0.8) {
        self.waveView.percent = 0.8;
    }else if (self.waveView.percent<0.2){
        self.waveView.percent = 0.2;
    }
    if (_homePageModel.useAmt) {
        [self.waveView startWave];
    }
    [waveBackgroundImageView addSubview:self.waveView];
    
    UIView *leftView = [self setViewWithHeader:@"授信金额(元)" footerName:  _homePageModel.creatAmt ? [NSString stringWithFormat:@"￥%@", _homePageModel.creatAmt] : @"0.00"];
    leftView.frame = CCXRectMake(44, 215, 142, 80);
    [self.headerView addSubview:leftView];
    
    UIView *rightView = [self setViewWithHeader:@"累计借款(元)" footerName: _homePageModel.xiaofeiAmt ? [NSString stringWithFormat:@"￥%@", _homePageModel.xiaofeiAmt] : @"0.00" ];
    rightView.frame = CCXRectMake(563, 215, 142, 80);
    [self.headerView addSubview:rightView];
   
//    UIView *footRV = [self setViewWithImage:@"信用值" Name:[NSString stringWithFormat:@"信用值：%@", _homePageModel.levle?_homePageModel.levle:@"C"]];
//    footRV.frame = CCXRectMake(58, 430, 245, 34);
//    [self.headerView addSubview:footRV];
    return self.headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    view.userInteractionEnabled = YES;
    UIImageView *moneybackImage = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 50, 750, 220)] ;
    UIImageView *monthbackImage = [[UIImageView alloc]initWithFrame:CCXRectMake(0,294, 750, 220)];
    NSArray *arr = @[moneybackImage,monthbackImage];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageV = obj;
        imageV.userInteractionEnabled = YES;
        imageV.image =[UIImage imageNamed:@"底色"];
        [view addSubview:imageV];
    }];
    
//    self.moneySlider = [[CCXSlider alloc]initWithMaxImageName:@"进度条_灰" minImageName:@"进度条(1)" thumbImageName:[UIImage imageNamed:@"借款金额-1"]];
  
     self.moneySlider = [[CCXSlider alloc]initWithMaxImageName:@"进度条_灰" minImageName:@"进度条(1)" thumbImageName:[UIImage imageNamed:@"home_slider_money"]];
    [self.moneySlider addTarget:self action:@selector(moneySliderChange:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    self.moneySlider.frame = CCXRectMake(40, 56.425, 670, 52);
//    if ([_homePageModel.useAmt intValue] <= [_homePageModel.minBorrowAmt intValue]) {
//        self.moneySlider.maximumValue = [_homePageModel.useAmt intValue]/100;
//        self.moneySlider.minimumValue = 0;
//        if ([_homePageModel.useAmt intValue] == [_homePageModel.minBorrowAmt intValue]) {
//            self.moneySlider.value = self.moneySlider.maximumValue;
//            
//        }else{
//            self.moneySlider.value = self.moneySlider.minimumValue;
//        }
//        
//        if ([_homePageModel.useAmt intValue] < [_homePageModel.minBorrowAmt intValue]) {
//            self.moneySlider.userInteractionEnabled = NO;
//
//        }
//    }else {
//        self.moneySlider.maximumValue = [_homePageModel.useAmt intValue] / 100;
//        self.moneySlider.minimumValue = [_homePageModel.minBorrowAmt intValue] / 100;
//        self.moneySlider.userInteractionEnabled = YES;
//        self.moneySlider.value = self.moneySlider.maximumValue;
////        self.moneySlider.value = self.moneySlider.minimumValue;
//    }
    
    
    if ([_homePageModel.useAmt intValue] <= 1000) {
        if ([_homePageModel.useAmt intValue] <= [_homePageModel.minBorrowAmt intValue]) {
            self.moneySlider.maximumValue = [_homePageModel.useAmt intValue]/100;
            self.moneySlider.minimumValue = 0;
            if ([_homePageModel.useAmt intValue] == [_homePageModel.minBorrowAmt intValue]) {
                self.moneySlider.value = self.moneySlider.maximumValue;
                
            }else{
                self.moneySlider.value = self.moneySlider.minimumValue;
            }
            
            if ([_homePageModel.useAmt intValue] < [_homePageModel.minBorrowAmt intValue]) {
                self.moneySlider.userInteractionEnabled = NO;
                
            }
        }else {
            self.moneySlider.maximumValue = [_homePageModel.useAmt intValue] / 100;
            self.moneySlider.minimumValue = [_homePageModel.minBorrowAmt intValue] / 100;
            self.moneySlider.userInteractionEnabled = YES;
            self.moneySlider.value = self.moneySlider.maximumValue;
            //        self.moneySlider.value = self.moneySlider.minimumValue;
        }

    } else {
        self.moneySlider.maximumValue = [_homePageModel.useAmt intValue] / 500;
        self.moneySlider.minimumValue = 1;
        self.moneySlider.userInteractionEnabled = YES;
        self.moneySlider.value = self.moneySlider.maximumValue;
    }
    
//    if ([_homePageModel.useAmt intValue] < 500) {
//        self.moneySlider.maximumValue = 5;
//        self.moneySlider.minimumValue = 5;
//        self.moneySlider.value = self.moneySlider.minimumValue;
//        self.moneySlider.userInteractionEnabled = NO;
//    }else {
//        self.moneySlider.maximumValue = [_homePageModel.useAmt intValue] / 500;
//        self.moneySlider.minimumValue = 5;
//        self.moneySlider.userInteractionEnabled = YES;
//        self.moneySlider.value = self.moneySlider.maximumValue;
//    }
    
    [moneybackImage addSubview:self.moneySlider];
    
//    self.monthSlider = [[CCXSlider alloc]initWithMaxImageName:@"进度条_灰" minImageName:@"进度条(1)" thumbImageName:[UIImage imageNamed:@"借款期限-1"]];
     self.monthSlider = [[CCXSlider alloc]initWithMaxImageName:@"进度条_灰" minImageName:@"进度条(1)" thumbImageName:[UIImage imageNamed:@"home_slider_month"]];
    self.monthSlider.continuous = NO;
    [self.monthSlider addTarget:self action:@selector(monthSliderChange:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
    self.monthSlider.maximumValue = [_homePageModel.maxDayLine floatValue];
    self.monthSlider.minimumValue = [_homePageModel.minDayLine floatValue];
    self.monthSlider.value = self.monthSlider.minimumValue;
    self.monthSlider.frame = CCXRectMake(40, 56.425, 670, 52);
    self.p = [_homePageModel.rrhRate floatValue];
    _repayMonView = [self setViewWithImage:@"home_icon_needpay" Name:[NSString stringWithFormat:@"本月待还：%.2f元",  _homePageModel.shouldPayAmt?[_homePageModel.shouldPayAmt doubleValue]:0.00]];
    _repayMonView.frame = CCXRectMake(450, 430, 245, 34);
    [self.headerView addSubview:_repayMonView];
    [monthbackImage addSubview:self.monthSlider];

    UILabel *mLabel = [self setLeLabelWithTitle:@"借款金额"];
    [moneybackImage addSubview:mLabel];
    UILabel *label = [self setLeLabelWithTitle:@"借款期限"];
    [monthbackImage addSubview:label];
    
    self.minMoneyLabel = [[UILabel alloc]initWithFrame:CCXRectMake(34, 160, 200, 30)];
//    if ([_homePageModel.useAmt intValue] <= [_homePageModel.minBorrowAmt intValue]) {
////        self.minMoneyLabel.text =_homePageModel.minBorrowAmt ? [NSString stringWithFormat:@"%@元", _homePageModel.minBorrowAmt] : @"0元";
//        if ([_homePageModel.useAmt intValue] < [_homePageModel.minBorrowAmt intValue]) {
//              self.minMoneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
//        }
//        self.minMoneyLabel.text = @"0元";
//      
//    }else {
//        self.minMoneyLabel.text = _homePageModel.minBorrowAmt ? [NSString stringWithFormat:@"%@元", _homePageModel.minBorrowAmt] : @"500元";
////        self.minMoneyLabel.text = @"500元";
//    }
    
    
    if ([_homePageModel.useAmt intValue] <= 1000) {
        if ([_homePageModel.useAmt intValue] <= [_homePageModel.minBorrowAmt intValue]) {
            //        self.minMoneyLabel.text =_homePageModel.minBorrowAmt ? [NSString stringWithFormat:@"%@元", _homePageModel.minBorrowAmt] : @"0元";
            if ([_homePageModel.useAmt intValue] < [_homePageModel.minBorrowAmt intValue]) {
                self.minMoneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
            }
            self.minMoneyLabel.text = @"0元";
            
        }else {
            self.minMoneyLabel.text = _homePageModel.minBorrowAmt ? [NSString stringWithFormat:@"%@元", _homePageModel.minBorrowAmt] : @"500元";
            //        self.minMoneyLabel.text = @"500元";
        }

    }else{
        self.minMoneyLabel.text = _homePageModel.minBorrowAmt ? [NSString stringWithFormat:@"%@元", _homePageModel.minBorrowAmt] : @"500元";
    }
    
    
    
    
    
    
    
//    self.minMoneyLabel.textColor = [UIColor redColor];
    self.minMoneyLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    self.minMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [moneybackImage addSubview:self.minMoneyLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CCXRectMake(512, 160, 200, 30)];
//    self.moneyLabel.text =  [NSString stringWithFormat:@"%d元",(int)self.moneySlider.value * 100];
    
    if ([_homePageModel.useAmt intValue] <= 1000) {
        if ([_homePageModel.useAmt intValue] <= [_homePageModel.minBorrowAmt intValue]) {
            //        self.moneyLabel.text = @"500元";
            self.moneyLabel.text =  [NSString stringWithFormat:@"%d元",[_homePageModel.useAmt intValue]];
            if ([_homePageModel.useAmt intValue] == [_homePageModel.minBorrowAmt intValue]) {
                self.moneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
            }
        }else {
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元", _homePageModel.useAmt];
            self.moneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
        }

    }else{
        self.moneyLabel.text =  [NSString stringWithFormat:@"%d元",(int)self.moneySlider.value * 500];
        self.moneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
    }
    
    
    //    self.moneyLabel.text = [NSString stringWithFormat:@"%d元",[_homePageModel.useAmt intValue]];
    self.moneyLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    self.moneyLabel.textAlignment = NSTextAlignmentRight;
    [moneybackImage addSubview:self.moneyLabel];
    
    self.minMonthLabel = [[UILabel alloc]initWithFrame:CCXRectMake(34, 160, 200, 30)];
    self.minMonthLabel.text = _homePageModel.minDayLine ? [NSString stringWithFormat:@"%@天",_homePageModel.minDayLine]:@"7天";
    self.minMonthLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];;
    self.minMonthLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    self.minMonthLabel.textAlignment = NSTextAlignmentLeft;
    [monthbackImage addSubview:self.minMonthLabel];
    
    _monthLabel = [[UILabel alloc]initWithFrame:CCXRectMake(512, 160, 200, 30)];
//    _monthLabel.text =  [NSString stringWithFormat:@"%d天",(int)self.monthSlider.value];
    _monthLabel.text =  _homePageModel.maxDayLine ? [NSString stringWithFormat:@"%@天",_homePageModel.maxDayLine]:@"14天";
    _monthLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
    _monthLabel.textAlignment = NSTextAlignmentRight;
    [monthbackImage addSubview:self.monthLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CCXRectMake(75, 560, 600, 110);
//    [button setTitle:@"我要借款" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor colorWithHexString:GJJMainColorString];
//    button.titleLabel.font = [UIFont systemFontOfSize:40*CCXSCREENSCALE];
//    button.layer.cornerRadius = AdaptationWidth(5);
    [button setImage:[UIImage imageNamed:@"home_btn_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"home_btn_selected"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"home_btn_selected"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *imageV= [[UIImageView alloc]initWithFrame:CCXRectMake(120, 670, 510, 50)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:@"home_nostudent"];
    [view addSubview:imageV];
    
    return view;
}

#pragma mark - alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex) {
            [self prepareDataWithCount:2];
        }
}

#pragma mark - 自定义方法

/**
 贷款金额滑动条滑动事件

 @param slider 贷款金额滑动条
 */
-(void)moneySliderChange:(UISlider *)slider{
    
//    if ([_homePageModel.useAmt intValue] < 300) {
//        self.moneyLabel.text =  @"300元";
//    }else {
//        self.moneyLabel.text =  [NSString stringWithFormat:@"%d元",(int)slider.value * 100];
//    }
    
    if ([_homePageModel.useAmt intValue] <= 1000) {
        if (slider.value > (slider.maximumValue+slider.minimumValue)/2.0) {
            slider.value = slider.maximumValue;
            _minMoneyLabel.textColor = [UIColor blackColor];
            _moneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
            
        }else{
            slider.value = slider.minimumValue;
            _minMoneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
            _moneyLabel.textColor = [UIColor blackColor];
        }
        
        _moneyLabel.text = [NSString stringWithFormat:@"%d元",(int)slider.value * 100];
    }else{
        self.moneyLabel.text =  [NSString stringWithFormat:@"%d元",(int)slider.value * 500];
    }
    
    
    
    
    
//    if (slider.value > (slider.maximumValue+slider.minimumValue)/2.0) {
//        slider.value = slider.maximumValue;
//        _minMoneyLabel.textColor = [UIColor blackColor];
//        _moneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
//    }else{
//        slider.value = slider.minimumValue;
//        _minMoneyLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];
//        _moneyLabel.textColor = [UIColor blackColor];
//    }
    
    
//    [_repayMonView removeFromSuperview];
//    _repayMonView = [self setViewWithImage:@"每期还款" Name:[NSString stringWithFormat:@"本月待还：%.2f元",((int)self.moneySlider.value*100*self.p*(int)self.monthSlider.value+(int)self.moneySlider.value*100)]];
//    _repayMonView.frame = CCXRectMake(505, 430, 245, 34);
//    [self.headerView addSubview:_repayMonView];
}

/**
 贷款期数滑动条滑动事件

 @param slider 贷款期数滑动条
 */
-(void)monthSliderChange:(UISlider *)slider{
//    _monthLabel.text =  [NSString stringWithFormat:@"%d天",(int)self.monthSlider.value];
    
    if (slider.value > (slider.maximumValue+slider.minimumValue)/2.0) {
        slider.value = slider.maximumValue;
        _minMonthLabel.textColor = [UIColor blackColor];
        _monthLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];;
    }else{
        slider.value = slider.minimumValue;
        _minMonthLabel.textColor = [UIColor colorWithRed:0.99 green:0.36 blue:0.00 alpha:1];;
        _monthLabel.textColor = [UIColor blackColor];
    }

    
//    [_repayMonView removeFromSuperview];
//    _repayMonView = [self setViewWithImage:@"每期还款" Name:[NSString stringWithFormat:@"本月待还：%.2f元",((int)self.moneySlider.value*100*self.p*(int)self.monthSlider.value+(int)self.moneySlider.value*100)]];
//    _repayMonView.frame = CCXRectMake(58, 430, 245, 34);
//    [self.headerView addSubview:_repayMonView];
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

@end
