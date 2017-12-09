//
//  GJJOnlineShopCreditViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/3.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJOnlineShopCreditViewController.h"
#import "GJJBasicInfoModel.h"
#import "GJJTaoBaoCreditViewController.h"
#import "GJJJindDongCreditViewController.h"

typedef NS_ENUM(NSInteger, GJJOnlineShopCreditRequest) {
    GJJOnlineShopCreditRequestData,
};

@interface GJJOnlineShopCreditViewController ()
<MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *onlineShopArray;

@end

@implementation GJJOnlineShopCreditViewController
{
    NSArray *_imageArray;
    NSArray *_titleArray;
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
    [self prepareDataWithCount:GJJOnlineShopCreditRequestData];
}

- (void)setupData
{
    _imageArray = @[@"mine_info_taobao", @"mine_info_jingdong"];
    _titleArray = @[@"淘宝账号认证", @"京东账号认证"];
    _onlineShopArray = [NSMutableArray array];
}

- (void)setupView
{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)headerRefresh
{
    [self prepareDataWithCount:GJJOnlineShopCreditRequestData];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJOnlineShopCreditRequestData) {
        self.cmd = GJJQueryTbAndJdStutus;
        self.dict = @{@"userId":[self getSeccsion].userId
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJOnlineShopCreditRequestData) {
        [_onlineShopArray removeAllObjects];
        NSArray *dataList = dict[@"dataList"];
        for (NSDictionary *infoDict in dataList) {
            GJJBasicInfoModel *model = [GJJBasicInfoModel yy_modelWithDictionary:infoDict];
            [_onlineShopArray addObject:model];
        }
        [self.tableV.mj_header endRefreshing];
        [self.tableV reloadData];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJOnlineShopCreditRequestData) {
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (_onlineShopArray.count) {
        GJJBasicInfoModel *model = _onlineShopArray[indexPath.row];
        
        if ([model.authenStatus isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"未填写";
            cell.detailTextLabel.textColor = CCXColorWithHex(@"cacaca");
        }else if ([model.authenStatus isEqualToString:@"1"]) {
            cell.detailTextLabel.text = @"已填写";
            cell.detailTextLabel.textColor = CCXMainColor;
        }else if ([model.authenStatus isEqualToString:@"2"]) {
            cell.detailTextLabel.text = @"已认证";
            cell.detailTextLabel.textColor = CCXMainColor;
        } else {
            cell.detailTextLabel.text = @"未填写";
            cell.detailTextLabel.textColor = CCXColorWithHex(@"cacaca");
        }
        
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_onlineShopArray.count) {
        GJJBasicInfoModel *model = _onlineShopArray[indexPath.row];
        if (indexPath.row == 0) {
            GJJTaoBaoCreditViewController *controller = [[GJJTaoBaoCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.model = model;
            controller.title = _titleArray[indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            GJJJindDongCreditViewController *controller = [[GJJJindDongCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = _titleArray[indexPath.row];
            controller.model = model;
            [self.navigationController pushViewController:controller animated:YES];
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
