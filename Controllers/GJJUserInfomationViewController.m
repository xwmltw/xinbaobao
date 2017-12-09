//
//  GJJUserInfomationViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJUserInfomationViewController.h"
#import "GJJMyInfomationTableViewCell.h"
#import "GJJLiftingInfoTableViewCell.h"
#import "GJJOnlineShopCreditViewController.h"
//#import "GJJLiftingSocialViewController.h"
#import "GJJSocialContactInfoViewController.h"
#import "GJJUserBindBankCardViewController.h"
#import "GJJUserLinkManViewController.h"
#import "GJJSelfInfomationViewController.h"
#import "GJJUserOperatorsCreditViewController.h"
#import "ZMCreditSDK.framework/Headers/ALCreditService.h"
#import "GJJCertIdModel.h"
#import "GJJZMCreditModel.h"

typedef NS_ENUM(NSUInteger, GJJUserInfomationRequest) {
    GJJUserInfomationRequestData,
    GJJUserInfomationRequestGetID,
    GJJUserInfomationRequestZM,
    GJJUserInfomationRequestZMBack,
};

@interface GJJUserInfomationViewController ()

@end

@implementation GJJUserInfomationViewController
{
    NSArray *_borrowInfomationArray;
    NSArray *_liftingInfomationArray;
    
    GJJCertIdModel *_certIdModel;
    GJJZMCreditModel *_zmCreditModel;
    NSDictionary *_zmDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self prepareDataWithCount:GJJUserInfomationRequestData];
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJUserInfomationRequestData];
}

- (void)setupData
{
    _borrowInfomationArray = @[ @"芝麻信用认证", @"运营商信息", @"银行卡信息", @"联系人信息", @"学籍信息"];
    _liftingInfomationArray = @[@"电商信息", @"社交信息"];
    
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
    return AdaptationHeight(50);
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
        
        cell.infoImageView.image = [UIImage imageNamed:_liftingInfomationArray[indexPath.row]];
        cell.infoLabel.text = _liftingInfomationArray[indexPath.row];
        
        if (indexPath.row == 0) {
            if ([_scheduleDict[@"dsStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头"];

            }else if ([_scheduleDict[@"dsStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头认证"];
            }
            
        }else if (indexPath.row == 1) {
            if ([_scheduleDict[@"sjStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头"];
            }else if ([_scheduleDict[@"sjStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头认证"];
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
        
        if (indexPath.row == 0) {
            if ([_scheduleDict[@"zhimaStatus"] integerValue] == 0) {
                cell.authenticationLabel.text = @"未填写";
                cell.authenticationLabel.textColor = CCXColorWithHex(@"999999");
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头"];
            }else if ([_scheduleDict[@"zhimaStatus"] integerValue] == 1) {
                cell.authenticationLabel.text = @"已填写";
                cell.authenticationLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
                cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头认证"];
            }
            cell.infoDetailLabel.text = @"(定期更新)";
        }else {
            cell.authenticationLabel.text = @"已填写";
            cell.authenticationLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
            cell.infoDetailLabel.text = @"(可修改)";
            cell.arrowImageView.image = [UIImage imageNamed:@"我的资料箭头认证"];
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
            GJJOnlineShopCreditViewController *controller = [[GJJOnlineShopCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"电商信息";
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 1) {
            GJJSocialContactInfoViewController *controller = [[GJJSocialContactInfoViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"社交信息";
            controller.scheduleDict = self.scheduleDict;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([_scheduleDict[@"zhimaStatus"] integerValue] == 0) {
                [self prepareDataWithCount:GJJUserInfomationRequestGetID];
            }else {
                [self setHudWithName:@"芝麻信用已填写" Time:1 andType:0];
            }
        }else if (indexPath.row == 1) {
            GJJUserOperatorsCreditViewController *controller = [[GJJUserOperatorsCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"运营商认证";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 2) {
            GJJUserBindBankCardViewController *controller = [[GJJUserBindBankCardViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"银行卡认证";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 3) {
            GJJUserLinkManViewController *controller = [[GJJUserLinkManViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"联系人信息";
            controller.schedule = self.schedule;
            controller.popViewController = self;
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 4) {
            GJJSelfInfomationViewController *controller = [[GJJSelfInfomationViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"在校信息";
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
    if (self.requestCount == GJJUserInfomationRequestData) {
        self.cmd = GJJQuerySchedule;
        self.dict = @{@"userId":[self getSeccsion].userId};
    }else if (self.requestCount == GJJUserInfomationRequestGetID) {
        //芝麻信用认证
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"0"};
    }else if (self.requestCount == GJJUserInfomationRequestZM) {
        self.cmd = GJJAuthorizeQry;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"name":_certIdModel.userName,
                      @"certNo":_certIdModel.identityCard};
    }else if (self.requestCount == GJJUserInfomationRequestZMBack) {
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
    if (self.requestCount == GJJUserInfomationRequestData) {
        _scheduleDict = dict;
        _schedule = [dict[@"schedule"] integerValue];
        [self.tableV reloadData];
    }else if (self.requestCount == GJJUserInfomationRequestGetID) {
        _certIdModel = [GJJCertIdModel yy_modelWithDictionary:dict];
        [self prepareDataWithCount:GJJUserInfomationRequestZM];
    }else if (self.requestCount == GJJUserInfomationRequestZM) {
        _zmCreditModel = [GJJZMCreditModel yy_modelWithDictionary:dict];
        [self launchSDK];
    }else if (self.requestCount == GJJUserInfomationRequestZMBack) {
        [self setHudWithName:@"芝麻信用认证成功" Time:1 andType:0];
        [self prepareDataWithCount:GJJUserInfomationRequestData];
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
    [self prepareDataWithCount:GJJUserInfomationRequestZMBack];
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
