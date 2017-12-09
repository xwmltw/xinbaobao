//
//  CCXBillDetailViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillDetailViewController.h"
#import "CCXBillDetailModel.h"
#import "CCXBillDetailTableViewCell.h"
#import "CCXPopViewController.h"
#import "CCXRootWebViewController.h"
#import "CCXBillPayViewController.h"
#import "GJJApplyForSuccessViewController.h"
#import "GJJBillDetailModel.h"
#import "GJJSignContactsModel.h"
#import "GJJUserToSignViewController.h"
#import "GJJChangeBingCardViewController.h"
#import "GJJAdultChangeBingCardViewController.h"
#import "YBPopupMenu.h"

typedef NS_ENUM(NSInteger, CCXBillDetailViewRequest) {
    CCXBillDetailViewRequestOrderDetail,
    CCXBillDetailViewRequestIneedMoney,
//    CCXBillDetailViewRequestSignContacts,
};

@interface CCXBillDetailViewController ()
<CCXPopViewControllerDelegate,YBPopupMenuDelegate>

@end

@implementation CCXBillDetailViewController{
    NSArray *_headerArr;
    GJJSignContactsModel *_singContactsModel;
    NSString *_withDrawId;
    NSArray *_signContractSuccessArray;
}

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"订单详情页"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signContractSuccess:) name:GJJSIGNCONTRACTSUCCESS object:nil];
    if ([self.isPay isEqualToString:@"sure"]) {//从提现过来
        self.detailDict = self.orderDict;
        self.dataSourceArr = [NSMutableArray new];
        [[self.detailDict objectForKey:@"detaList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCXBillDetailModel *model = [[CCXBillDetailModel alloc]initWithDict:obj];
            [self.dataSourceArr addObject:model];
        }];
    }
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.backgroundColor = CCXColorWithHex(@"#ffffff");
    [self setHeader];
    [self setFooter];
    [self isToPay];
    [self setRightNaviBarButtonWithTag:10000];
    // Do any additional setup after loading the view.
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
    if (![self.isPay isEqualToString:@"sure"]) {//不是从提现过来
        [self prepareDataWithCount:CCXBillDetailViewRequestOrderDetail];
    }
}

- (void)signContractSuccess:(NSNotification *)sender
{
    _signContractSuccessArray = sender.object;
    [self prepareDataWithCount:CCXBillDetailViewRequestOrderDetail];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)BarbuttonClick:(UIButton *)button{
    if (_isNeedPopToRootController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)isToPay
{
    UIButton *button = (UIButton *)[self.view viewWithTag:888];
    if (button) {
        [button removeFromSuperview];
    }
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bottomButton];
    bottomButton.tag = 888;
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(20)];
    [bottomButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(AdaptationHeight(49)));
    }];
    if ([self.isPay isEqualToString:@"true"]) {//从消息过来
        if ([self.detailDict[@"status"] integerValue] == 5) {//已结清
            UIButton *removeButton = (UIButton *)[self.view viewWithTag:888];
            [removeButton removeFromSuperview];
        }else {
            if ([self.detailDict[@"status"] integerValue] == 4 || [self.detailDict[@"status"] integerValue] == 6) {
                bottomButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
                [bottomButton setTitle:@"去还款" forState:UIControlStateNormal];
//                [self.view addSubview:bottomButton];
            }
        }
    }else if ([self.isPay isEqualToString:@"sure"]) {//从提现过来
        bottomButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
        NSString *withdrawCashString = @"已阅读合同与协议，申请提现";
        NSMutableAttributedString *withdrawCashAttributedString = [[NSMutableAttributedString alloc]initWithString:withdrawCashString];
        [withdrawCashAttributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:STBtnTextColor], NSFontAttributeName: [UIFont systemFontOfSize:AdaptationWidth(13)]} range:NSMakeRange(0, withdrawCashString.length)];
        [withdrawCashAttributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:STBtnTextColor], NSFontAttributeName: [UIFont systemFontOfSize:AdaptationWidth(16)]} range:NSMakeRange(0, 9)];
        [bottomButton setAttributedTitle:withdrawCashAttributedString forState:UIControlStateNormal];
//        [self.view addSubview:bottomButton];
    }else {
        if ([self.detailDict[@"status"] integerValue] == 1) {//签约
            if ([self.detailDict[@"isValid"] integerValue] == 0) {//有效
                [bottomButton setTitle:@"签订合同" forState:UIControlStateNormal];
                bottomButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
//                [self.view addSubview:bottomButton];
            }else {//失效
                [bottomButton setTitle:@"已失效" forState:UIControlStateNormal];
                [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                bottomButton.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
//                [self.view addSubview:bottomButton];
            }
        }
    }
}

- (void)bottomButtonClick:(UIButton *)sender
{
    if ([self.isPay isEqualToString:@"true"]) {//还款
        CCXBillPayViewController *payVC = [CCXBillPayViewController new];
        payVC.title = @"还款记录";
        payVC.billId = self.billId;
        payVC.status = @"0";
        [self.navigationController pushViewController:payVC animated:YES];
    }else if ([self.isPay isEqualToString:@"sure"]) {//从提现过来
        [self prepareDataWithCount:CCXBillDetailViewRequestIneedMoney];
    }else {
        if ([self.detailDict[@"status"] integerValue] == 1) {//签约
            if ([self.detailDict[@"isValid"] integerValue] == 0) {//有效
                //                [self prepareDataWithCount:CCXBillDetailViewRequestSignContacts];
                GJJUserToSignViewController *controller = [GJJUserToSignViewController new];
                controller.title = @"提示";
                controller.withDrawId = self.billId;
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else {//失效
                return;
            }
        }
    }
}


#pragma mark - 父类方法

-(void)headerRefresh{
    if ([self.isPay isEqualToString:@"sure"]) {
        self.detailDict = self.orderDict;
        [self.tableV.mj_header endRefreshing];
        self.dataSourceArr = [NSMutableArray new];
        [[self.detailDict objectForKey:@"detaList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCXBillDetailModel *model = [[CCXBillDetailModel alloc]initWithDict:obj];
            [self.dataSourceArr addObject:model];
        }];
    }else {
        [self prepareDataWithCount:CCXBillDetailViewRequestOrderDetail];
    }
}

-(void)setRequestParams{
    if (self.requestCount == CCXBillDetailViewRequestOrderDetail) {
        self.cmd = CCXQueryOrderDetail;
        NSDictionary *paramsDict = [NSDictionary dictionary];
        if (_signContractSuccessArray.count) {
            paramsDict = _signContractSuccessArray.firstObject;
        }
        
        self.dict = @{ @"withDrawId": self.billId,
                       @"mesId": self.mesId,
                       @"isJump": self.isJump,
                       @"status": paramsDict[@"status"]?paramsDict[@"status"]:@""};
    }else if (self.requestCount == CCXBillDetailViewRequestIneedMoney) {
        CCXUser *seccsion = [self getSeccsion];
        self.cmd = CCXIneedMoney;
        self.dict = @{@"userId":seccsion.userId,
                      @"loanAmt":self.detailDict[@"borrowAmt"],
                      @"loanPerion":self.detailDict[@"perions"],
                      @"orderNum":self.detailDict[@"orderNum"]};
     
    }
//    else if (self.requestCount == CCXBillDetailViewRequestSignContacts) {
//        self.cmd = GJJSignContacts;
//        self.dict = @{@"userId":[self getSeccsion].userId,
//                      @"withDrawId": self.billId};
//    }
}

-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == CCXBillDetailViewRequestOrderDetail) {
        self.dataSourceArr = [NSMutableArray new];
        [[dict objectForKey:@"detaList"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCXBillDetailModel *model = [[CCXBillDetailModel alloc]initWithDict:obj];
            [self.dataSourceArr addObject:model];
        }];
        self.detailDict = dict;
        self.isPay = self.detailDict[@"isPay"];
        [self.tableV reloadData];
        [self setHeader];
        [self setFooter];
        [self isToPay];
    }else if (self.requestCount == CCXBillDetailViewRequestIneedMoney) {
        self.detailDict = dict;
        [self pushToSuccessControllerWithWithDrawId:dict[@"withDrawId"]];
    }

}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
//    if (self.requestCount != CCXBillDetailViewRequestSignContacts) {
//        [super requestFaildWithDictionary:dict];
//    }else {
        if ([dict[@"detail"][@"status"] integerValue] == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dict[@"resultNote"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去绑卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
                    GJJChangeBingCardViewController *controller = [[GJJChangeBingCardViewController alloc]init];
                    controller.title = @"银行卡认证";
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.withDrawId = self.billId;
                    [self.navigationController pushViewController:controller animated:YES];
                }else {
                    GJJAdultChangeBingCardViewController *controller = [[GJJAdultChangeBingCardViewController alloc]init];
                    controller.title = @"银行卡认证";
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.withDrawId = self.billId;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }else {
            [super requestFaildWithDictionary:dict];
        }
//    }
}

- (void)pushToSuccessControllerWithWithDrawId:(NSString *)withDrawId
{
    GJJApplyForSuccessViewController *controller = [[GJJApplyForSuccessViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.title = @"提示";
    controller.withDrawId = withDrawId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - tableView的代理协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    150
    return 148*CCXSCREENSCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70*CCXSCREENSCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.isPay isEqualToString:@"true"] || [self.isPay isEqualToString:@"sure"] || [self.detailDict[@"status"] integerValue] == 1) {
        return AdaptationHeight(49);
    }
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    CCXBillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CCXBillDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSourceArr.count) {
        CCXBillDetailModel *model = self.dataSourceArr[indexPath.row];
        cell.model = model;
        if (self.dataSourceArr.count > 1) {
            if (indexPath.row == self.dataSourceArr.count-1) {
                cell.imageV.image = [UIImage imageNamed:@"状态3"];
            }else if (indexPath.row == 0){
                cell.imageV.image = [UIImage imageNamed:@"progress01"];
            }else{
                cell.imageV.image = [UIImage imageNamed:@"状态2"];
            }

        }else{
            cell.imageV.image = [UIImage imageNamed:@"progress01"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"3"]) {
        if (indexPath.row == 0) {
            CCXBillDetailModel *model = self.dataSourceArr[indexPath.row];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:model.detail preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.detailDict[@"status"]) {
        UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 70)];
        view.backgroundColor = CCXColorWithHex(@"#ffffff");
        
        UIImageView *progressImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(30, 11, 48, 48)];
        [view addSubview:progressImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(98, 0, 710, 70)];
        label.backgroundColor = CCXColorWithHex(@"#ffffff");
        label.text = @"借款进度";
        label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
        label.textColor = CCXColorWithHex(@"#666666");
        [view addSubview:label];
        
        if ([self.detailDict[@"status"] integerValue] == 0) {
            progressImageView.image = [UIImage imageNamed:@"进度借款"];
        }else if ([self.detailDict[@"status"] integerValue] == 1) {
            progressImageView.image = [UIImage imageNamed:@"进度签约"];
        }else if ([self.detailDict[@"status"] integerValue] == 2) {
            progressImageView.image = [UIImage imageNamed:@"进度驳回"];
        }else if ([self.detailDict[@"status"] integerValue] == 3) {
            progressImageView.image = [UIImage imageNamed:@"进度借款"];
        }else if ([self.detailDict[@"status"] integerValue] == 4) {
            progressImageView.image = [UIImage imageNamed:@"进度还款"];
            label.text = @"还款进度";
        }else if ([self.detailDict[@"status"] integerValue] == 5) {
            progressImageView.image = [UIImage imageNamed:@"进度结清"];
            label.text = @"还款进度";
        }else if ([self.detailDict[@"status"] integerValue] == 6) {
            progressImageView.image = [UIImage imageNamed:@"进度逾期"];
            label.text = @"还款进度";
        }
        
        return view;

    }else{
        UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 70)];
        view.backgroundColor = CCXColorWithHex(@"#ffffff");
        
        UIImageView *progressImageView = [[UIImageView alloc]initWithFrame:CCXRectMake(30, 11, 48, 48)];
        [view addSubview:progressImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(98, 0, 710, 70)];
        label.backgroundColor = CCXColorWithHex(@"#ffffff");
        label.text = @"借款进度";
        label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
        label.textColor = CCXColorWithHex(@"#666666");
        [view addSubview:label];
        
        progressImageView.image = [UIImage imageNamed:@"进度借款"];
        
        return view;

    }
//    return nil;
}

#pragma mark - 自定义方法
-(void)setHeader{
    UIView *backView = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 530)];
    backView.backgroundColor = CCXColorWithHex(@"#ffffff");
    NSArray *arr = @[@"订单编号:",@"借款金额:",@"借款期限:",@"到账金额:",@"到期还款:",@"到账卡号:",@"账单说明:"];
    if (!self.detailDict.count) {
        self.detailDict = @{@"orderNum":@"",@"borrowAmt":@"",@"perions":@"",@"actualAmt":@"",@"monthPay":@"",@"bankNum":@"",@"orderExplanin":@""};
    }
    NSArray *dictArr = @[[NSString stringWithFormat:@"%@", self.detailDict[@"orderNum"]],
                         [NSString stringWithFormat:@"%@（元整）",self.detailDict[@"borrowAmt"]],
                         [NSString stringWithFormat:@"%@",self.detailDict[@"perions"]],
                         [NSString stringWithFormat:@"%@（元整）",self.detailDict[@"actualAmt"]],
                         [NSString stringWithFormat:@"%@（元整）",self.detailDict[@"monthPay"]],
                         [NSString stringWithFormat:@"%@", self.detailDict[@"bankNum"]],
                         [NSString stringWithFormat:@"%@", self.detailDict[@"orderExplanin"]]
                         ];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
            UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(40, 40+56*idx, 160, 28)];
            label.text = arr[idx];
            label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
            label.textColor = CCXColorWithHex(@"#666666");
            [backView addSubview:label];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CCXRectMake(230, 40+56*idx, 500, 28);
            [button setTitle:dictArr[idx] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
        
        if (idx == 6) {
            
            button.frame = CCXRectMake(230, 40+56*idx, 500, 100);
            button.titleLabel.adjustsFontSizeToFitWidth = NO;
            button.titleLabel.numberOfLines = 0;
        }
        
        [backView addSubview:button];
        
    }];
    UIView *bottomView = [[UIView alloc]initWithFrame:CCXRectMake(0, 500, 750, 30)];
    bottomView.backgroundColor = CCXColorWithHex(@"f2f2f2");
    [backView addSubview:bottomView];
    self.tableV.tableHeaderView = backView;
}

-(void)setFooter{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 646)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 646)];
    UIImageView *imageV = [UIImageView new];
    [bgView addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"无订单"];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView).offset(AdaptationHeight(-20));
        make.size.equalTo(CGSizeMake(AdaptationWidth(150), AdaptationWidth(150)));;
    }];

    if (!self.dataSourceArr.count) {
        self.tableV.tableFooterView = bgView;
    }else{
        self.tableV.tableFooterView = nil;
    }
}

/**
 设置导航栏右按钮
 
 @param tag 按钮的tag值
 */
-(void)setRightNaviBarButtonWithTag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-30, 64, 60, 30);
    [button setTitle:@"合同" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.tag = tag;
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem =item;
}

/**
 按钮的点击事件
 
 @param btn 被点击的按钮
 */
-(void)onButtonClick:(UIButton *)btn{
    [self createPopoverViewWithView:btn];
    
}

/**
 创建popVIew
 */
-(void)createPopoverViewWithView:(UIButton *)button{

    
//     self.automaticallyAdjustsScrollViewInsets = NO;
//    NaviMenuView *menuView = [[NaviMenuView alloc] initWithPositionOfDirection:CGPointMake(self.view.frame.size.width - 40, 80) images:nil titleArray:@[@"扫一扫",@"发起群聊"]];
//    menuView.clickedBlock = ^(NSInteger index){
//        
//        
//        
//        if (0==index) {
//            
//            
//        }else if(1 == index){
//            
//            
//            
//        }
//    };
//    
//    [self.view addSubview:menuView];

    NSArray *tmpArray = [NSArray array];
    if ([self.detailDict[@"jqzmurl"] length]) {
        tmpArray = @[@"分期服务合同",@"结清证明"];
    }else{
        tmpArray = @[@"分期服务合同"];
    }

    [YBPopupMenu showRelyOnView:button titles:tmpArray icons:nil menuWidth:AdaptationWidth(130) delegate:self];
    
    
//    CCXPopViewController *popVC = [[CCXPopViewController alloc]initWithPopView:button orBaritem:nil];
//    if ([self.detailDict[@"jqzmurl"] length]) {
//        popVC.listsArr = @[@"分期服务合同",@"结清证明"];
//    }else{
//        popVC.listsArr = @[@"分期服务合同"];
//    }
//
//    popVC.delegate = self;
//    [self presentViewController:popVC animated:YES completion:nil];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    CCXRootWebViewController *rootVC = [[CCXRootWebViewController alloc]init];
    if (index == 0) {
        rootVC.title = @"分期服务合同";
        rootVC.url = [NSString stringWithFormat:@"%@&type=3",self.detailDict[@"jkurl"]];
    }else if(index == 1){
        rootVC.title = @"结清证明";
        rootVC.url = self.detailDict[@"jqzmurl"];
    }
    [self.navigationController pushViewController:rootVC animated:YES];
}

#pragma mark popover代理方法

-(void)popViewController:(CCXPopViewController *)con didSelectAtIndex:(int)index{
    CCXRootWebViewController *rootVC = [[CCXRootWebViewController alloc]init];
    if (index == 0) {
        rootVC.title = @"分期服务合同";
        rootVC.url = [NSString stringWithFormat:@"%@&type=3",self.detailDict[@"jkurl"]];
    }else if(index == 1){
        rootVC.title = @"结清证明";
        rootVC.url = self.detailDict[@"jqzmurl"];
    }
    [self.navigationController pushViewController:rootVC animated:YES];
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
