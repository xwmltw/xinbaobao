//
//  CCXBillViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillViewController.h"
#import "CCXBillTableViewCell.h"
#import "CCXBillListViewController.h"
#import "CCXBillModel.h"

@interface CCXBillViewController ()

@property(nonatomic,copy)NSString *useAmt;

@end

@implementation CCXBillViewController

#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"我的账单"];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.backgroundColor = [UIColor whiteColor];
    [self setHeader];
    // Do any additional setup after loading the view.
   
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeAll;
}
#endif

-(void)viewWillAppear:(BOOL)animated{
    [self setClearNavigationBar];
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
    self.cmd = CCXMyBill;
    self.dict = @{@"userId":seccsion.userId};
}

/**
 网络请求成功设置网络结果

 @param dict detail的详细参数
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    self.useAmt = dict[@"useAmt"];
    NSArray *Arr = dict[@"detaList"];
    self.dataSourceArr = [NSMutableArray new];
    [Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCXBillModel *model = [[CCXBillModel alloc]initWithDict:obj];
        [self.dataSourceArr addObject:model];
    }];
    [self.tableV reloadData];
    [self setHeader];
}

/**
 下拉刷新后执行
 */
-(void)headerRefresh{
    [self prepareDataWithCount:0];
}

#pragma mark - tableView代理协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130*CCXSCREENSCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    CCXBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CCXBillTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSourceArr.count) {
        if (indexPath.row == 0) {
            CCXBillModel *model = self.dataSourceArr[0];
            cell.model = model;
        }else if (indexPath.row == 1) {
            CCXBillModel *model = self.dataSourceArr[4];
            cell.model = model;
        }else if (indexPath.row == 2) {
            CCXBillModel *model = self.dataSourceArr[1];
            cell.model = model;
        }else if (indexPath.row == 3) {
            CCXBillModel *model = self.dataSourceArr[2];
            cell.model = model;
        }else {
            CCXBillModel *model = self.dataSourceArr[3];
            cell.model = model;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCXBillModel *model = nil;
    switch (indexPath.row) {
        case 0:
        {
            model = self.dataSourceArr[0];
        }
            break;
        case 1:
        {
            model = self.dataSourceArr[4];
        }
            break;
        case 2:
        {
            model = self.dataSourceArr[1];
        }
            break;
        case 3:
        {
            model = self.dataSourceArr[2];
        }
            break;
        case 4:
        {
            model = self.dataSourceArr[3];
        }
            break;
        default:
            break;
    }
    NSArray *arr = @[@"还款中",@"待签字",@"审核中",@"已结清",@"已驳回"];
    CCXBillListViewController *billList = [CCXBillListViewController new];
    billList.title = arr[indexPath.row];
    billList.type = model.type;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", [model.type integerValue]] forKey:CCXBillType];
    [self.navigationController pushViewController:billList animated:YES];
}


#pragma mark - 自定义方法
-(void)setHeader{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 400)];
    imageV.image = [UIImage imageNamed:@"mine_bg_header"];
    imageV.userInteractionEnabled = YES;
    
    UIImageView *grayV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 320, 750, 80)];
    grayV.image = [UIImage imageNamed:@"mine_bg_useamt"];
    [imageV addSubview:grayV];
    UIImageView *atmImageV = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 16, 51, 47)];
    atmImageV.image = [UIImage imageNamed:@"mine_icon_available"];
    [grayV addSubview:atmImageV];
    UILabel *atmLabel = [[UILabel alloc]initWithFrame:CCXRectMake(120, 0, 200, 80)];
    atmLabel.text = @"可用额度（元）";
    atmLabel.textColor = CCXColorWithHex(@"#ffffff");
    atmLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    atmLabel.adjustsFontSizeToFitWidth = YES;
    [grayV addSubview:atmLabel];
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CCXRectMake(380, 0, 330, 80)];
    moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.useAmt floatValue]];
    moneyLabel.textColor = CCXColorWithHex(@"#ffffff");
    moneyLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [grayV addSubview:moneyLabel];
    self.tableV.tableHeaderView = imageV;
}

@end
