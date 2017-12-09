//
//  GJJAdultCreditCardListViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultCreditCardListViewController.h"
#import "GJJBasicInfoModel.h"
#import "GJJAdultCreditCardNumberViewController.h"
#import "GJJAdultCreditCardMailViewController.h"
#import "STAdultCreditCardListCell.h"
typedef NS_ENUM(NSInteger, GJJAdultCreditCardListRequest) {
    GJJAdultCreditCardListRequestData,
};

@interface GJJAdultCreditCardListViewController ()
<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *creditArray;

@end

@implementation GJJAdultCreditCardListViewController
{
    NSArray *_titleArray;
    NSArray *_imageArray;
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
    [self prepareDataWithCount:GJJAdultCreditCardListRequestData];
}

- (void)setupView
{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupData
{
    _titleArray = @[@"信用卡账号信息", @"账单邮箱信息"];
    _imageArray = @[@"info_icon_creditbig", @"info_icon_mail"];
    _creditArray = [NSMutableArray array];
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJAdultCreditCardListRequestData];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultCreditCardListRequestData) {
        self.cmd = GJJQueryXykAndYx;
        self.dict = @{@"userId":[self getSeccsion].userId
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultCreditCardListRequestData) {
        [_creditArray removeAllObjects];
        NSArray *dataList = dict[@"dataList"];
        for (NSDictionary *dict in dataList) {
            GJJBasicInfoModel *model = [GJJBasicInfoModel yy_modelWithDictionary:dict];
            MyLog(@"%@", model.authenStatus);
            [_creditArray addObject:model];
        }
        
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];

    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultCreditCardListRequestData) {
        [self.tableV.mj_header endRefreshing];
    }
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    return AdaptationHeight(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//    
//    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
//    cell.textLabel.text = _titleArray[indexPath.row];
////    cell.textLabel.font = [UIFont systemFontOfSize:16];
//    
//    if (_creditArray.count) {
//        GJJBasicInfoModel *model = _creditArray[indexPath.row];
//        
//        if ([model.authenStatus isEqualToString:@"0"]) {
//            cell.detailTextLabel.text = @"未填写";
//            cell.detailTextLabel.textColor = CCXColorWithHex(@"cacaca");
//        }else if ([model.authenStatus isEqualToString:@"1"]) {
//            cell.detailTextLabel.text = @"已填写";
//            cell.detailTextLabel.textColor = [UIColor colorWithHexString:STMainColorString];
//        }else if ([model.authenStatus isEqualToString:@"2"]) {
//            cell.detailTextLabel.text = @"已认证";
//            cell.detailTextLabel.textColor = [UIColor colorWithHexString:STMainColorString];
//        } else {
//            cell.detailTextLabel.text = @"未填写";
//            cell.detailTextLabel.textColor = CCXColorWithHex(@"cacaca");
//        }
//        
//    }
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    static NSString *cellId = @"myLiftingCell";
    
    STAdultCreditCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[STAdultCreditCardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.infoLabel.text = _titleArray[indexPath.row];
    
    if (_creditArray.count) {
        GJJBasicInfoModel *model = _creditArray[indexPath.row];

        if ([model.authenStatus isEqualToString:@"0"]) {
            cell.authenticationLabel.text = @"未填写";
            cell.authenticationLabel.textColor = CCXColorWithHex(@"cacaca");
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
        }else if ([model.authenStatus isEqualToString:@"1"]) {
            cell.authenticationLabel.text = @"已填写";
            cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
        }else if ([model.authenStatus isEqualToString:@"2"]) {
            cell.authenticationLabel.text = @"已认证";
            cell.authenticationLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWSELECTED];
        } else {
            cell.authenticationLabel.text = @"未填写";
            cell.authenticationLabel.textColor = CCXColorWithHex(@"cacaca");
            cell.arrowImageView.image = [UIImage imageNamed:MYINFOARROWDEFAULT];
        }
        
        if (indexPath.row == _creditArray.count - 1) {
            cell.separatorLabel.hidden = YES;
        }else{
            cell.separatorLabel.hidden = NO;
        }

        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GJJBasicInfoModel *model = _creditArray[indexPath.row];
    if (indexPath.row == 0) {
        GJJAdultCreditCardNumberViewController *controller = [[GJJAdultCreditCardNumberViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"信用卡认证";
        [self.navigationController pushViewController:controller animated:YES];
        controller.model = model;
    }else {
        GJJAdultCreditCardMailViewController *controller = [[GJJAdultCreditCardMailViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"账单邮箱认证";
        [self.navigationController pushViewController:controller animated:YES];
        controller.model = model;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}

- (void)showHit:(NSString *)string
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = string;
    hud.delegate = self;
    [hud hideAnimated:YES afterDelay:1];
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
