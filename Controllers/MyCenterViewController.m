//
//  MyCenterViewController.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "MyCenterViewController.h"
#import "CCXBillViewController.h"
#import "WQLogViewController.h"
#import "CCXSettingViewController.h"
#import "CCXRootWebViewController.h"
#import "GJJSelfAndLogoutViewController.h"
#import "WQOrderViewController.h"
#import "WQQuickRepayViewController.h"
#import "WQResetViewController.h"
#import "WQSuggestionViewController.h"
#import "GJJMineModel.h"
#import "CCXBillDetailViewController.h"
#import "CCXBillPayViewController.h"
#import "ProgressView.h"
#import "GJJHomePageModel.h"
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
#import "STAdultIdentityVerifyViewController.h"
#import "GJJPicInfoModel.h"

typedef NS_ENUM(NSInteger, CCXMyCenterRequest) {
    CCXMyCenterRequestMine,
    CCXMyCenterRequestSchedule,
    WQModifyPwdGetValiCodeFromPhone,
};
@interface MyCenterViewController ()

@end

@implementation MyCenterViewController
{
    UIImageView *_headerBackgroundImageView;
    NSMutableArray *_picList;
    GJJMineModel *_mineModel;
    NSInteger schedule;
    ProgressView *progressView;
    BOOL isPoss;
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setClearNavigationBar];
   
    [self prepareDataWithCount:CCXMyCenterRequestMine];

    [self showTabBar];
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (OnOff) {
        [self creatNavigation];
    }
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
   
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    //talkingdata
    [TalkingData trackEvent:@"我的页面"];
}
- (void)creatNavigation{
    UIButton *message = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    [message setTitleColor:CCXColorWithRGB(34, 58, 80) forState:UIControlStateNormal];
    [message.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
    [message setTitle:@"订单消息" forState:UIControlStateNormal];
    [message addTarget:self action:@selector(onClickOkBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *redImage =[[UIImageView alloc]init];
    [redImage setImage:[UIImage imageNamed:@"redDot"]];
    [message addSubview:redImage];
    if (_mineModel.mesSize.intValue > 0) {
        [redImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(message);
            make.width.height.mas_equalTo(6);
        }];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)setData{
     NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (OnOff) {
        NSArray *nameArr = @[@"我的账单",@"快速还款",@"修改密码",@"关于信宝宝",@"常见问题",@"我要反馈",@"退出账号"];
        NSArray *imageArr =@[@"mine_icon_info",@"mine_icon_bill",@"mine_icon_quickpay",@"mine_icon_modify",@"mine_icon_aboutus",@"mine_icon_question",@"mine_icon_feedback"];
        [nameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{@"title":obj,@"imageName":imageArr[idx]};
            [self.dataSourceArr addObject:dic];
        }];
    }else {
        NSArray *nameArr = @[@"修改密码",@"我要反馈",@"退出账号"];
        NSArray *imageArr =@[@"mine_icon_quickpay",@"mine_icon_question",@"mine_icon_feedback"];
        [nameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{@"title":obj,@"imageName":imageArr[idx]};
            [self.dataSourceArr addObject:dic];
        }];
    }
   
    [self.tableV reloadData];
    _picList = [NSMutableArray arrayWithCapacity:0];
}
-(UIView *)setHeader{
    CCXUser *user = [self getSeccsion];
    
    NSArray *promptArr = @[@"开始第一步：完成身份认证，让您可以被信任",@"开始第一步：完成身份认证，让您可以被信任",@"开始第一步：完成身份认证，让您可以被信任",@"完成芝麻信用分认证，让我们知道您有偿还能力",@"完成银行卡认证，让我们知道您不是老赖",@"完成联系人信息认证，让您更加可信",@"完成工作信息认证，让您更加可信",@"一步之遥！完成最后一步认证即可贷款"];
    
    NSString *userId = [NSString stringWithFormat:@"%@", user.userId];
    
    UIView *headerView = [[UIView alloc]init];
    headerView.userInteractionEnabled = YES;
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *headerBg = [UIImageView new];
    headerBg.image = [UIImage imageNamed:@"Login_tatoo"];
    headerBg.userInteractionEnabled = YES;
    [headerView addSubview:headerBg];
    
    
    UIButton *avatar = [[UIButton alloc]init];
    if ([userId isEqualToString:@"-100"]) {
        [avatar setTitle:@"请登录" forState:UIControlStateNormal];
    }else{
        if (schedule > 2) {
            [avatar setTitle:user.customName forState:UIControlStateNormal];
        }else{
            [avatar setTitle:@"请完成认证" forState:UIControlStateNormal];
        }
    }
    [avatar setTitleColor:CCXColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];

    [avatar.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(32)]];
    [avatar addTarget:self action:@selector(avatarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:avatar];
    
    UILabel *labDetail = [[UILabel alloc]init];
    labDetail.text = @"点击查看我的资料";
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [labDetail setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [headerView addSubview:labDetail];
    
//    schedule = 8;
    
    if (![userId isEqualToString:@"-100"]) {
        progressView = [[ProgressView alloc]init];
        progressView.hidden = NO;
        if (schedule < 3) {
            progressView.view1.hidden = NO;
            progressView.view1.backgroundColor = [UIColor clearColor];
            [progressView.view1.layer setMasksToBounds:YES];
            [progressView.view1.layer setBorderWidth:1];
            [progressView.view1.layer setBorderColor:CCXColorWithRGB(255, 189, 76).CGColor];
        }
        if (schedule == 3) {
            progressView.view1.hidden = NO;
            progressView.view1.backgroundColor = CCXColorWithRGB(255, 189, 76);
        }
        if (schedule == 4) {
            progressView.view1.hidden = NO;
            progressView.view2.hidden = NO;
        }
        if (schedule == 5) {
            progressView.view1.hidden = NO;
            progressView.view2.hidden = NO;
            progressView.view3.hidden = NO;
        }
        if (schedule == 6) {
            progressView.view1.hidden = NO;
            progressView.view2.hidden = NO;
            progressView.view3.hidden = NO;
            progressView.view4.hidden = NO;
        }
        if (schedule == 7) {
            progressView.view1.hidden = NO;
            progressView.view2.hidden = NO;
            progressView.view3.hidden = NO;
            progressView.view4.hidden = NO;
            progressView.view5.hidden = NO;
        }
        
        [headerView addSubview:progressView];
        
        
        UILabel *labProgress = [[UILabel alloc]init];
        
        [labProgress setText:schedule < 8 ? promptArr[schedule] : @""];
        [labProgress setTextColor:CCXColorWithRGB(255, 187, 76)];
        [labProgress setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [headerView addSubview:labProgress];
        
        
        UILabel *labMoney = [[UILabel alloc]init];
        GJJHomePageModel *model = [GJJHomePageModel sharedInstance];
        [labMoney setText:[NSString stringWithFormat:@"累计借款 %@元",model.xiaofeiAmt]];
        [labMoney setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [labMoney setTextColor:CCXColorWithRBBA(34, 58, 80, 0.32)];
        [headerView addSubview:labMoney];
        NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
        if (OnOff) {
            labProgress.hidden = NO;
            labDetail.hidden = NO;
            labMoney.hidden = NO;
            
        }else{
            labProgress.hidden = YES;
            labDetail.hidden = YES;
            labMoney.hidden = YES;
            [avatar setTitle:@"欢迎光临" forState:UIControlStateNormal];
        }
        
        if( schedule < 8 ){
            
            [labProgress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(headerView).offset(AdaptationWidth(24));
                make.bottom.mas_equalTo(headerView).offset(-AdaptationWidth(11));
            }];
            
            [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(8));
                make.left.mas_equalTo(headerView).offset(AdaptationWidth(24));
                make.bottom.mas_equalTo(labProgress.mas_top).offset(-AdaptationWidth(8));
                make.width.mas_equalTo(AdaptationWidth(269));
                
            }];
            
        }else{
            [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(headerView).offset(-AdaptationWidth(24));
                make.bottom.mas_equalTo(headerView).offset(-AdaptationWidth(16));
            }];
            progressView.hidden = YES;
        }
    }
    
    
    [headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatar);
        make.right.mas_equalTo(headerView).offset(-AdaptationWidth(24));
        make.width.mas_equalTo(AdaptationWidth(40));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(headerView).offset(AdaptationWidth(17));
//        make.width.mas_equalTo(AdaptationWidth(96));
//        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(avatar.mas_bottom).offset(2);
    }];
    return headerView;
}
#pragma mark - 父类方法

/**
 设置网络请求参数
 */
-(void)setRequestParams{
    self.cmd = GJJMine;
    self.dict = @{@"userId":[self getSeccsion].userId};
    //    self.dict = @{@"userId":@"189"};
    if (self.requestCount == CCXMyCenterRequestMine) {
        self.cmd = GJJMine;
        self.dict = @{@"userId":[self getSeccsion].userId};
    }else if (self.requestCount == CCXMyCenterRequestSchedule) {
        self.cmd = GJJQuerySchedule;
        self.dict = @{@"userId":[self getSeccsion].userId};
    }
}

/**
 网络请求成功
 
 @param dict 网络请求成功之后的数据
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    
    if (self.requestCount == CCXMyCenterRequestMine) {
        //        _headerDic = (NSMutableDictionary *)dict;
        _mineModel = [GJJMineModel yy_modelWithDictionary:dict];
        CCXUser *user = [self getSeccsion];
        user.customName = _mineModel.customName;
        user.phone = _mineModel.phone;
        user.isVirtualNetworkOperator = _mineModel.isVirtualNetworkOperator;
        [self saveSeccionWithUser:user];
        
        isPoss = NO;
        [self prepareDataWithCount:CCXMyCenterRequestSchedule];
        
    }else if (self.requestCount == CCXMyCenterRequestSchedule) {
        schedule = [dict[@"schedule"] integerValue];
        if (schedule != 8) {
            NSArray *picList = dict[@"picList"];
            [_picList removeAllObjects];
            for (NSDictionary *picDict in picList) {
                GJJPicInfoModel *model = [GJJPicInfoModel yy_modelWithDictionary:picDict];
                [_picList addObject:model];
            }
        }
        [self.tableV reloadData];
        if (isPoss) {
             [self pushToWihchInfoControllerWithSchedule:schedule dict:dict];
        }
       
    }
}

/**
 网络请求操作失败
 
 @param dict 网络请求失败的原因
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == CCXMyCenterRequestMine)  {
        //        _headerDic = [NSMutableDictionary new];
        //        [_headerDic setObject:@"请登录" forKey:@"phone"];
        //        [_headerDic setObject:@"莫愁花" forKey:@"customName"];
        //        [_headerDic setObject:@"1000" forKey:@"useAmt"];
        if (![dict[@"resultNote"] isEqualToString:@"未登录"]) {
            [self setHudWithName:dict[@"resultNote"] Time:1 andType:1];
        }
        
        [self.tableV reloadData];
    }else if (self.requestCount == CCXMyCenterRequestSchedule) {
        [super requestFaildWithDictionary:dict];
    }
}

/**
 下拉刷新
 */
-(void)headerRefresh{
    [self prepareDataWithCount:CCXMyCenterRequestMine];
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
                }                controller.popViewController = self;
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
#pragma mark - tableView代理协议

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(65);
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CCXUser *user = [self getSeccsion];
    if ([user.userId isEqualToString:@"-100"]) {
        return AdaptationWidth(127);
    }
    if(schedule < 8){
        return AdaptationWidth(181);
    }else{
        return AdaptationWidth(146);
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [self setHeader];

    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellId = @"cellId";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    UITableViewCell*  cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellDetail = [[UILabel alloc]init];
        _cellLab = [[UILabel alloc]init];
        _cellImage = [[UIImageView alloc]init];
//    }
    
    [_cellLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [_cellLab setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    _cellLab.text = self.dataSourceArr[indexPath.row][@"title"];
    [cell.contentView addSubview:_cellLab];
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 6) {
        
        [self.cellDetail setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [self.cellDetail setTextColor:CCXColorWithRBBA(34, 58, 80, 0.32)];
        
        if (indexPath.row == 0) {
            CCXUser *user = [self getSeccsion];
            if (![user.userId isEqualToString:@"-100"]) {
                self.cellDetail.text =  [NSString stringWithFormat:@"已逾期 %.2f元",_mineModel.overdue.floatValue];
            }else{
                self.cellDetail.text = [NSString stringWithFormat:@"已逾期 0.00元"];
            }
            
        }
        
        if (indexPath.row == 1) {
            CCXUser *user = [self getSeccsion];
            if (![user.userId isEqualToString:@"-100"]) {
                self.cellDetail.text =  [NSString stringWithFormat:@"本次应还 %.2f元",_mineModel.shouldPayAmt.floatValue];
            }else{
                self.cellDetail.text = [NSString stringWithFormat:@"本次应还 0.00元"];
            }
//            self.cellDetail.text = (schedule == 8) ? _mineModel.shouldPayAmt : @"本次应还 0.00元";
        }
        if (indexPath.row == 6) {
            CCXUser *user = [self getSeccsion];
            if (![user.userId isEqualToString:@"-100"]) {
                self.cellDetail.text =  [user.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }else{
                self.cellDetail.text = @"请登录";
            }
            
        }
        [cell.contentView addSubview:self.cellDetail];
        [_cellLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
            make.top.mas_equalTo(cell).offset(AdaptationWidth(10));
        }];
        [self.cellDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
            make.bottom.mas_equalTo(cell).offset(-AdaptationWidth(10));
        }];
        
    }else{
        [_cellLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
            make.centerY.mas_equalTo(cell);
        }];
    }
    
    
    [self.cellImage setImage:[UIImage imageNamed:self.dataSourceArr[indexPath.row][@"imageName"]]];
    [cell.contentView addSubview :self.cellImage];
    
    
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(cell);
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(27));
        make.width.height.mas_equalTo(AdaptationWidth(22));
    }];
    
    
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (OnOff) {
        self.cellDetail.hidden = NO;
    }else {
        self.cellDetail.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCXUser *user = [self getSeccsion];
    NSInteger row = indexPath.row;
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (!OnOff) {
        row = row + 2;
        if (row > 2) {
            row = row + 2;
        }
    }
    switch (row) {
        case 0:{//我的账单
            if ([user.userId intValue] == -100) {
                [self pushToLoin];
                return;
            }

            CCXBillViewController *billVC = [CCXBillViewController new];
            billVC.hidesBottomBarWhenPushed = YES;
            billVC.title = @"我的账单";
            [self.navigationController pushViewController:billVC animated:YES];
        } break;
        case 100:{//我的资料
            if ([user.userId intValue] == -100) {
                [self pushToLoin];
                return;
            }
            //talkingdata
            [TalkingData trackEvent:@"我的资料"];
            [self prepareDataWithCount:CCXMyCenterRequestSchedule];
            //            }
        }break;
        case 1:
        {//快速还款
            if ([user.userId integerValue] == -100) {
                [self pushToLoin];
                return;
            }
            //            WQQuickRepayViewController *controller = [WQQuickRepayViewController new];
            //            controller.title = @"还款";
            //            controller.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:controller animated:YES];

            if (_mineModel.withDrawId.length > 0) {
                CCXBillPayViewController *payVC = [CCXBillPayViewController new];
                payVC.title = @"还款记录";
                payVC.billId = _mineModel.withDrawId;
                payVC.status = @"0";
                payVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:payVC animated:YES];
            }else {
                [self setHudWithName:@"您没有需要还款的订单" Time:1 andType:2];
            }
            //            CCXBillDetailViewController *billVC = [CCXBillDetailViewController new];
            //            billVC.title = @"订单详情";
            //            billVC.billId = _mineModel.withDrawId;
            //            billVC.mesId = @"";
            //            billVC.isJump = @"no";
            //            billVC.hidesBottomBarWhenPushed = YES;
            //            [self.navigationController pushViewController:billVC animated:YES];
        }
            break;
        case 2:
        {//修改密码
            if ([user.userId intValue] == -100) {
                [self pushToLoin];
                return;
            }
            //            [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
            [self pushToModifiyController];
        }
            break;
        case 3:
        {//关于我们
            
            if (!OnOff) {
                return;
            }
            CCXRootWebViewController *rooVC = [CCXRootWebViewController new];
            rooVC.title = @"关于信宝宝";
            rooVC.url = CCXABOUT;
            rooVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rooVC animated:YES];
        }
            break;
        case 4:{
            
            if (!OnOff) {
                return;
            }
            
            CCXRootWebViewController *rooVC = [CCXRootWebViewController new];
            rooVC.title = @"常见问题";
            rooVC.url = CCXQUESTION;
            rooVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rooVC animated:YES];
        }
            break;
        case 5:{
            if ([[self getSeccsion].userId intValue] == -100) {
                [self pushToLoin];
                return;
            }
            
            
            WQSuggestionViewController *suggestionVC = [[WQSuggestionViewController alloc]init];
            suggestionVC.hidesBottomBarWhenPushed = YES;
            suggestionVC.title = @"意见反馈";
            [self.navigationController pushViewController:suggestionVC animated:YES];
        }
            break;
        case 6:{//退出登录
            CCXUser *user = [self getSeccsion];
            if (![user.userId isEqualToString:@"-100"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    user.userId = @"-100";
                    user.uuid = @"";
                    user.token = @"";
                    user.customName = APPDEFAULTNAME;
                    user.password = @"";
                    [self saveSeccionWithUser:user];
                    //    self.tabBarController.selectedIndex = 0;
                    [self pushToLoin];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:cancel];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
            break;
    }
}
#pragma  mark -btn
-(void)onClickOkBtn{
    CCXUser *user = [self getSeccsion];
    if ([user.userId integerValue] == -100) {
        [self pushToLoin];
        return;
    }
    WQOrderViewController *controller = [[WQOrderViewController alloc] init];
    //拿到block的值
    //    [controller returnToCenter:^(NSMutableArray *orderMesArr) {
    //        _getArr = orderMesArr;
    //    }];
    controller.title = @"订单消息";
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)avatarButtonClick:(UIButton *)btn{
    ///点击头像
//    if ([[self getSeccsion].userId intValue] == -100) {
//        [self pushToLoin];
//        return;
//    }

    
    if ([[self getSeccsion].userId intValue] == -100) {
        [self pushToLoin];
        return;
    }
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (!OnOff) {
        return;
    }
    
    isPoss = YES;
    [self prepareDataWithCount:CCXMyCenterRequestSchedule];
}
- (void)pushToLoin
{
    WQLogViewController *loginVC = [WQLogViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.title = @"登录";
    loginVC.popViewController = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)pushToModifiyController{
    CCXUser *user = [self getSeccsion];
    WQResetViewController *resetPasswordVC = [[WQResetViewController alloc]init];
    resetPasswordVC.hidesBottomBarWhenPushed = YES;
    resetPasswordVC.title = @"修改密码";
    [self.navigationController pushViewController:resetPasswordVC animated:YES];
    resetPasswordVC.phoneString = user.phone;
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
