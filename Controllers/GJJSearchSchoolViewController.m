//
//  GJJSearchSchoolViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJSearchSchoolViewController.h"
#import "GJJSearchSchoolModel.h"

@interface GJJSearchSchoolViewController ()
<UISearchBarDelegate,
MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *schoolArray;

@end

@implementation GJJSearchSchoolViewController
{
    UISearchBar *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self createSearchBar];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

#pragma mark - setup and get data
- (void)setupData
{
    _schoolArray = [NSMutableArray array];
}

- (void)getSchoolData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabel.text = @"加载中...";
    hud.delegate = self;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[self getSeccsion].userId forKey:@"userId"];
    [params setObject:_searchBar.text forKey:@"keyValue"];
    [params setObject:@"SCHOOL_NAME" forKey:@"dataType"];
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:GJJQuerySchool forKey:@"cmd"];
    [allParams setObject:CCXVersion forKey:@"version"];
    [allParams setObject:@"" forKey:@"token"];
    [allParams setObject:params forKey:@"params"];
    
    [HYBNetworking postWithUrl:[NSString stringWithFormat:@"%@%@", CCXSERVR, GJJQuerySchool] refreshCache:YES params:allParams success:^(id response) {
        MyLog(@"%@", response);
        
        [hud hideAnimated:YES];
        
        NSString *resultNote = response[@"resultNote"];
        NSString *result = [NSString stringWithFormat:@"%@", response[@"result"]];
        
        if ([result isEqualToString:@"0"]) {
            
        }else if ([result isEqualToString:@"1"]) {
            [MBProgressHUD showCustomStr:resultNote icon:@"fork" toView:self.navigationController.view];
            return;
        }else if ([result isEqualToString:@"2"]) {
            [MBProgressHUD showCustomStr:resultNote icon:@"warning" toView:self.navigationController.view];
            return;
        }else {
            [MBProgressHUD showCustomStr:resultNote icon:@"warning" toView:self.navigationController.view];
            return;
        }
        
        [_schoolArray removeAllObjects];
        NSDictionary *detail = response[@"detail"];
        NSArray *dataList = detail[@"dataList"];
        for (NSDictionary *dict in dataList) {
            GJJSearchSchoolModel *model = [GJJSearchSchoolModel yy_modelWithDictionary:dict];
            [_schoolArray addObject:model];
        }
        [self.tableV reloadData];
        
    } fail:^(NSError *error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showCustomStr:@"认证失败请重试" icon:@"fork" toView:self.navigationController.view];
        return;
    }];
}

#pragma mark -- searchBarDelegate
-(void)createSearchBar{
    _searchBar = [UISearchBar new];
    [_searchBar sizeToFit];
    self.tableV.tableHeaderView = _searchBar;
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
    _searchBar.placeholder = [NSString stringWithFormat:@"请输入学校名称"];
    _searchBar.showsScopeBar = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:GJJMainColorString] forState:UIControlStateNormal];
        }
    }
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    return YES;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self getSchoolData];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _schoolArray.count;
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
    return AdaptationHeight(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
    }
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    if (self.schoolArray.count) {
        GJJSearchSchoolModel *model = self.schoolArray[indexPath.row];
        cell.detailTextLabel.text = model.schoolName;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJJSearchSchoolModel *schoolModel = self.schoolArray[indexPath.row];
    if (self.returnTextBlock) {
        self.returnTextBlock(schoolModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
