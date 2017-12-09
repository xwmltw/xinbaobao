//
//  CCXBillListViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillListViewController.h"
#import "CCXBillListModel.h"
#import "CCXBillListTableViewCell.h"
#import "CCXBillPayViewController.h"
#import "CCXBillDetailViewController.h"

@interface CCXBillListViewController ()

@end

@implementation CCXBillListViewController

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.backgroundColor = CCXColorWithHex(@"#F2F2F2");
//    [self setHeader];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)viewWillAppear:(BOOL)animated{
    [self prepareDataWithCount:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 父类方法

/**
 设置网络请求参数
 */
-(void)setRequestParams{
    CCXUser *seccsion = [self getSeccsion];
    self.cmd = CCXQueryPostDetail;
    self.dict = @{@"userId":seccsion.userId,@"type":self.type};
}

/**
 网络请求成功之后

 @param dict 请求的detail信息
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    NSArray *arr = dict[@"DataList"];
    self.dataSourceArr = [NSMutableArray new];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCXBillListModel *model = [CCXBillListModel yy_modelWithDictionary:obj];
        [self.dataSourceArr addObject:model];
    }];
    [self.tableV reloadData];
    if (!self.dataSourceArr.count) {
        [self setFooter];
    }else {
        self.tableV.tableFooterView = nil;
    }
}

/**
 下拉刷新执行
 */
-(void)headerRefresh{
    [self prepareDataWithCount:0];
}

#pragma mark - tableView代理协议方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60*CCXSCREENSCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134*CCXSCREENSCALE;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CCXBillListModel *model = self.dataSourceArr[section];
    return [NSString stringWithFormat:@"借款合同号:%@",model.contractNo];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    CCXBillListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CCXBillListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSourceArr.count) {
        CCXBillListModel *model = self.dataSourceArr[indexPath.section];
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCXBillListModel *model = self.dataSourceArr[indexPath.section];
    if (0 == [self.type intValue]) {//还款记录 0.还款中
        CCXBillPayViewController *payVC = [CCXBillPayViewController new];
        payVC.title = @"还款记录";
        payVC.billId = model.withDrawId;
        payVC.status = @"0";
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    }else{//1.审核 2.结清 3.驳回 4.签字
        CCXBillDetailViewController *billVC = [CCXBillDetailViewController new];
        billVC.billId = model.withDrawId;
        billVC.mesId = @"";
        billVC.isJump = @"no";
        billVC.title = @"订单详情";
        billVC.type = self.type;
        billVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:billVC animated:YES];
    }
}

#pragma mark - 自定义方法

/**
 设置tableView的头
 */
//-(void)setHeader{
//    UIView *view = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 60)];
//    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 20, 20, 20)];
//    imageV.image = [UIImage imageNamed:@"注明"];
//    [view addSubview:imageV];
//    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(80, 20, 570, 20)];
//    label.textColor = CCXColorWithHex(@"#999999");
//    label.font = [UIFont systemFontOfSize:20*CCXSCREENSCALE];
//    if (0 == [self.type intValue]) {
//        label.text = @"客官，记得按时还款喔";
//    }else if (1 == [self.type intValue]){
//        label.text = @"客官，不要急嘛,去洗个泡泡，我们就审核了喔";
//    }else if (2 == [self.type intValue]){
//        label.text = @"客官，结清的账单都在这里了，快去看看结清证明吧";
//    }else if (3 == [self.type intValue]){
//        label.text = @"客官，你要申请被驳回了，赶紧联系客服重新提交吧";
//    }else {
//        label.text = @"客官，审核已经通过，快来签字吧";
//    }
//    [view addSubview:label];
//    self.tableV.tableHeaderView = view;
//}

-(void)setFooter{
    UIView *footerView = [[UIView alloc]initWithFrame:self.view.bounds];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"mybill_icon_nodata"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [footerView addSubview:imageV];
    [imageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(footerView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(150), AdaptationWidth(150)));
    }];
    self.tableV.tableFooterView = footerView;
}


@end
