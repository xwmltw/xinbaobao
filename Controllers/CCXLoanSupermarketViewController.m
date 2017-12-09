//
//  LoanSupermarketViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXLoanSupermarketViewController.h"
#import "WQLoanSuperMarketModel.h"
#import "WQLoanSuperMarketCell.h"
#import "WQLoanDetailViewController.h"

@interface CCXLoanSupermarketViewController (){
    NSArray *_dataList;
}

@end

@implementation CCXLoanSupermarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)viewWillAppear:(BOOL)animated{
    [self setClearNavigationBar];
}

-(void)setRequestParams{
    self.cmd = WQQueryLoanOrg;
    self.dict = @{};
}

-(void)headerRefresh{
    [self prepareDataWithCount:0];
}

-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    _dataList = dict[@"dataList"];
    self.dataSourceArr = [NSMutableArray new];
    for (NSDictionary *productionDict in _dataList) {
        WQLoanSuperMarketModel *model = [WQLoanSuperMarketModel new];
        [model setValuesForKeysWithDictionary:productionDict];
        [self.dataSourceArr addObject:model];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 587*CCXSCREENSCALE;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    WQLoanSuperMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WQLoanSuperMarketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = CCXColorWithHex(@"#ededed");
        cell.layer.shadowOffset = CCXSizeMake(0, 1);
        cell.layer.shadowColor = [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
        cell.layer.shadowRadius = 1;
        cell.layer.shadowOpacity = .5f;
        CGRect shadowFrame = cell.layer.bounds;
        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
        cell.layer.shadowPath = shadowPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSourceArr.count) {
        WQLoanSuperMarketModel *model = self.dataSourceArr[indexPath.row];
        cell.model = model;
    }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    WQLoanDetailViewController *loanDetailVC = [[WQLoanDetailViewController alloc]init];
//    loanDetailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:loanDetailVC animated:YES];
//    loanDetailVC.hidesBottomBarWhenPushed = NO;
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
