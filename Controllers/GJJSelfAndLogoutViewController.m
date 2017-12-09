//
//  GJJSelfAndLogoutViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/1/3.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJSelfAndLogoutViewController.h"
#import "GJJPersonalInformationModel.h"

typedef NS_ENUM(NSInteger, GJJSelfAndLogoutRequest) {
    GJJSelfAndLogoutRequestPersonalInfo,
};

@interface GJJSelfAndLogoutViewController ()

@end

@implementation GJJSelfAndLogoutViewController
{
    GJJPersonalInformationModel *_infoModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self setupView];
//    [self prepareDataWithCount:GJJSelfAndLogoutRequestPersonalInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    [self prepareDataWithCount:GJJSelfAndLogoutRequestPersonalInfo];

}

//-(void)headerRefresh{
//    [self prepareDataWithCount:GJJSelfAndLogoutRequestPersonalInfo];
//}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setRequestParams
{
    if (self.requestCount == GJJSelfAndLogoutRequestPersonalInfo) {
        self.cmd = GJJSelectPersonalInfo;
        self.dict = @{@"userId": [self getSeccsion].userId};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJSelfAndLogoutRequestPersonalInfo) {
        _infoModel = [GJJPersonalInformationModel yy_modelWithDictionary:dict];
        CCXUser *user = [self getSeccsion];
        user.identityCard = _infoModel.identityNo;
        user.customName = _infoModel.name;
        user.orgId = _infoModel.orgId;
        [self saveSeccionWithUser:user];
        [self.tableV reloadData];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJSelfAndLogoutRequestPersonalInfo) {
        NSDictionary *detailDict = dict[@"detail"];
        _infoModel = [GJJPersonalInformationModel yy_modelWithDictionary:detailDict];
        [self.tableV reloadData];
    }
}

- (void)setupView
{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.bounces = NO;
    self.tableV.backgroundColor = CCXColorWithHex(@"f2f2f2");
    [self setupTableViewFooterView];
}

- (void)setupTableViewFooterView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CCXSIZE_W, 108)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(25, 58, CCXSIZE_W - 50, 50);
    logoutButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    logoutButton.layer.cornerRadius = 4;
    logoutButton.layer.masksToBounds = YES;
    [logoutButton addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logoutButton];
    
    self.tableV.tableFooterView = footView;
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = CCXColorWithHex(@"666666");
    cell.detailTextLabel.textColor = CCXColorWithHex(@"666666");
    cell.textLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名";
            if (_infoModel.name) {
                cell.detailTextLabel.text = _infoModel.name;
            }else{
                cell.detailTextLabel.text = @"未填写";
            }
           
        }else {
            cell.textLabel.text = @"性别";
            
            if (_infoModel.sex) {
                if ([_infoModel.sex isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = @"男";
                }else if ([_infoModel.sex isEqualToString:@"1"]){
                    cell.detailTextLabel.text = @"女";
                }else{
                    cell.detailTextLabel.text = _infoModel.sex;
                }
            }else{
                cell.detailTextLabel.text = @"未填写";
            }
        }
    }else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"个人身份";
//            if ([_infoModel.orgId integerValue] == 0) {
//                cell.detailTextLabel.text = @"在校";
//            }else {
//                cell.detailTextLabel.text = @"在职";
//            }
//            
//        }else {
            cell.textLabel.text = @"身份证号";
        if (_infoModel.identityNo) {
            cell.detailTextLabel.text = _infoModel.identityNo;
;
        }else{
            cell.detailTextLabel.text = @"未填写";
        }
//        }
    }
    
    return cell;
}

#pragma mark - button click
- (void)logoutClick
{
    CCXUser *user = [self getSeccsion];
    user.userId = @"-100";
    user.uuid = @"";
    user.token = @"";
    user.customName = APPDEFAULTNAME;
    user.password = @"";
    [self saveSeccionWithUser:user];
//    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
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
