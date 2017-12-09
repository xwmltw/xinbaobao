//
//  GJJAdultUserInfomationViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultUserInfomationViewController.h"
#import "GJJMyInfomationTableViewCell.h"
#import "GJJLiftingInfoTableViewCell.h"
#import "GJJAdultOnlineShopCreditViewController.h"
//#import "GJJAdultLiftingSocialViewController.h"
#import "GJJSocialContactInfoViewController.h"
#import "GJJAdultAccumulationViewController.h"
#import "GJJAdultCreditCardListViewController.h"
#import "GJJAdultUserBindBankCardViewController.h"
#import "GJJAdultUserLinkManViewController.h"
#import "GJJAdultSelfInfomationViewController.h"
#import "GJJAdultUserOperatorsCreditViewController.h"
#import "ZMCreditSDK.framework/Headers/ALCreditService.h"
#import "GJJCertIdModel.h"
#import "GJJZMCreditModel.h"
#import "GJJSelfAndLogoutViewController.h"
#import "GJJQueryServiceUrlModel.h"

typedef NS_ENUM(NSUInteger, GJJAdultUserInfomationRequest) {
    GJJAdultUserInfomationRequestData,
    GJJAdultUserInfomationRequestGetID,
    GJJAdultUserInfomationRequestZM,
    GJJAdultUserInfomationRequestZMBack,
};

@interface GJJAdultUserInfomationViewController ()

@end

@implementation GJJAdultUserInfomationViewController
{
    NSArray *_borrowInfomationArray;
    NSArray *_liftingInfomationArray;
    NSArray *_liftingInfomationImageArray;
    
    GJJCertIdModel *_certIdModel;
    GJJZMCreditModel *_zmCreditModel;
    NSDictionary *_zmDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"我的资料"];
    
    [self setupData];
    [self setupView];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareDataWithCount:GJJAdultUserInfomationRequestData];
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJAdultUserInfomationRequestData];
}

- (void)setupData
{
     if ([GJJQueryServiceUrlModel sharedInstance].switch_on_off_3.integerValue == 1 ) {
         _borrowInfomationArray = @[@"个人信息",@"芝麻信用认证", @"运营商信息", @"银行卡信息", @"联系人信息", @"在职信息"];
     }else{
         _borrowInfomationArray = @[@"个人信息",@"芝麻信用认证", @"运营商信息", @"银行卡信息", @"在职信息"];
     }
    _liftingInfomationArray = @[@"我的电商", @"我的社交", @"我的公积金", @"我的信用卡"];
    _liftingInfomationImageArray = @[@"info_icon_ec", @"info_icon_social", @"info_icon_accumulation", @"info_icon_creditcard"];
}

- (void)setupView
{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.backgroundColor = [UIColor whiteColor];
}


#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _liftingInfomationArray.count;
    }else {
        return _borrowInfomationArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AdaptationHeight(38);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CCXSIZE_W, AdaptationHeight(38))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [headerView addSubview:titleLabel];
    titleLabel.textColor = CCXColorWithHex(@"666666");
    titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(15)];
    if (section == 0) {
        titleLabel.text = @"提额资料";
        
    }else if (section == 1) {
        titleLabel.text = @"借款资料";
    }
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(AdaptationWidth(13));
        make.centerY.equalTo(headerView);
    }];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptationHeight(66);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"myLiftingCell";
        
        GJJLiftingInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[GJJLiftingInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.infoImageView.image = [UIImage imageNamed:_liftingInfomationImageArray[indexPath.row]];
        
        cell.infoLabel.text = _liftingInfomationArray[indexPath.row];
        
        if (indexPath.row == 0) {
            if ([_scheduleDict[@"dsStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
            }else if ([_scheduleDict[@"dsStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
            }
            
        }else if (indexPath.row == 1) {
            if ([_scheduleDict[@"sjStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
            }else if ([_scheduleDict[@"sjStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
            }
        }else if (indexPath.row == 2) {
            if ([_scheduleDict[@"gjjStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
            }else if ([_scheduleDict[@"gjjStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
            }
        }else if (indexPath.row == 3) {
            if ([_scheduleDict[@"xykStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
            }else if ([_scheduleDict[@"xykStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
            }
        }
        
        return cell;
        
    }else if (indexPath.section == 1) {
        static NSString *cellId = @"myInfomationCell";
        
        GJJMyInfomationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            cell = [[GJJMyInfomationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.infoLabel.text = _borrowInfomationArray[indexPath.row];
        if(indexPath.row == 0){
            cell.infoDetailLabel.text = @"(可修改)";
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
        }else if (indexPath.row == 1) {
            if ([_scheduleDict[@"zhimaStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
            }else if ([_scheduleDict[@"zhimaStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已认证";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];;
                cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
            }
            cell.infoDetailLabel.text = @"(定期更新)";
        }else if (indexPath.row == 2){
            cell.authenticationLabel.text = @"已认证";
            cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
            cell.infoDetailLabel.text = @"(可修改)";
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
        }else {
            cell.authenticationLabel.text = @"已填写";
            cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
            cell.infoDetailLabel.text = @"(可修改)";
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GJJAdultOnlineShopCreditViewController *controller = [[GJJAdultOnlineShopCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"电商信息";
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 1) {
            GJJSocialContactInfoViewController *controller = [[GJJSocialContactInfoViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"社交信息";
            controller.scheduleDict = self.scheduleDict;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 2) {
            GJJAdultAccumulationViewController *controller = [[GJJAdultAccumulationViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"公积金信息";
            controller.scheduleDict = self.scheduleDict;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 3) {
            GJJAdultCreditCardListViewController *controller = [[GJJAdultCreditCardListViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"信用卡信息";
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
                GJJSelfAndLogoutViewController *controller = [[GJJSelfAndLogoutViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"个人信息";
                [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row == 1) {
            if ([_scheduleDict[@"zhimaStatus"] integerValue] == 0) {
                [self prepareDataWithCount:GJJAdultUserInfomationRequestGetID];
            }else {
                [self setHudWithName:@"芝麻信用已填写" Time:1 andType:0];
            }
        }else if (indexPath.row == 2) {
            GJJAdultUserOperatorsCreditViewController *controller = [[GJJAdultUserOperatorsCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"运营商认证";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 3) {
            GJJAdultUserBindBankCardViewController *controller = [[GJJAdultUserBindBankCardViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"银行卡认证";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 4) {
            if ([GJJQueryServiceUrlModel sharedInstance].switch_on_off_3.integerValue == 1 ) {
                GJJAdultUserLinkManViewController *controller = [[GJJAdultUserLinkManViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"联系人信息";
                controller.schedule = self.schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                GJJAdultSelfInfomationViewController *controller = [[GJJAdultSelfInfomationViewController alloc]init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.title = @"在职信息";
                controller.schedule = self.schedule;
                controller.popViewController = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if (indexPath.row == 5) {
            GJJAdultSelfInfomationViewController *controller = [[GJJAdultSelfInfomationViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"在职信息";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
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

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultUserInfomationRequestData) {
        self.cmd = GJJQuerySchedule;
        self.dict = @{@"userId":[self getSeccsion].userId};
    }else if (self.requestCount == GJJAdultUserInfomationRequestGetID) {
        //芝麻信用认证
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"0"};
    }else if (self.requestCount == GJJAdultUserInfomationRequestZM) {
        self.cmd = GJJAuthorizeQry;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"name":_certIdModel.userName,
                      @"certNo":_certIdModel.identityCard};
    }else if (self.requestCount == GJJAdultUserInfomationRequestZMBack) {
        self.cmd = GJJZhimaCallBack;
        NSString *paramsStr = _zmDict[@"params"];
        NSString *sign = _zmDict[@"sign"];
        sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"params":[paramsStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]],
                      @"sign":[sign stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]]};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultUserInfomationRequestData) {
        _scheduleDict = dict;
        _schedule = [dict[@"schedule"] integerValue];
        [self.tableV reloadData];
    }else if (self.requestCount == GJJAdultUserInfomationRequestGetID) {
        _certIdModel = [GJJCertIdModel yy_modelWithDictionary:dict];
        [self prepareDataWithCount:GJJAdultUserInfomationRequestZM];
    }else if (self.requestCount == GJJAdultUserInfomationRequestZM) {
        _zmCreditModel = [GJJZMCreditModel yy_modelWithDictionary:dict];
        [self launchSDK];
    }else if (self.requestCount == GJJAdultUserInfomationRequestZMBack) {
        [self setHudWithName:@"芝麻信用认证成功" Time:1 andType:0];
        [self prepareDataWithCount:GJJAdultUserInfomationRequestData];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
}

- (void)launchSDK {
    // 商户需要从服务端获取
    NSString* appId = ALZMAPPID;
    [[ALCreditService sharedService] queryUserAuthReq:appId sign:_zmCreditModel.sign params:_zmCreditModel.params extParams:nil selector:@selector(result:) target:self];
}

- (void)result:(NSMutableDictionary *)dict
{
    MyLog(@"dict：%@", dict);
    if ([dict[@"authResult"] isEqualToString:@""]) {
        return;
    }
    
    _zmDict = dict;
    [self prepareDataWithCount:GJJAdultUserInfomationRequestZMBack];
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
