//
//  CCXSettingViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXSettingViewController.h"
#import "CCXWaveProgressView.h"
#import "CCXRootWebViewController.h"
#import "GJJUserInfoTableViewCell.h"
#import "WQAboutRRHViewC.h"
#import "WQSuggestionViewController.h"
#import "WQResetViewController.h"
#import "WQLogViewController.h"

typedef NS_ENUM(NSInteger,WQResetUpdateRequest){
    WQModifyPwdGetValiCodeFromPhone,
    WQConformModifyPwdRequst,
    WQUpdateRequest,
    WQLogInRequest,
};

@interface CCXSettingViewController ()

@property(nonatomic,strong)CCXWaveProgressView *waveView;
@property(nonatomic,strong)NSMutableDictionary *headerDic;

@end


@implementation CCXSettingViewController


#pragma mark -视图控制器方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setClearNavigationBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackNavigationBarItem];
    [self setData];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.bounces = NO;
    [self setHeader];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    if (self.requestCount == WQModifyPwdGetValiCodeFromPhone){
        self.cmd = WQGetValiCodeFromPhone;
        self.dict = @{@"phone":user.phone,
                      @"userId":@""};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == WQModifyPwdGetValiCodeFromPhone) {
        [self setHudWithName:@"获取成功" Time:1 andType:0];
    }
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
}



/*返回按钮的点击事件*/
-(void)BarbuttonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];;
}

#pragma mark -自定义UI
-(CCXWaveProgressView *)waveView{
    if (!_waveView) {
        _waveView = [[CCXWaveProgressView alloc]initWithFrame:CCXRectMake(578, 172, 130, 130)];
        _waveView.waveViewMargin = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _waveView.backgroundImageView.image = [UIImage imageNamed:@"完成度"];
        _waveView.numberLabel.text = [NSString stringWithFormat:@"%@％",self.detailDict[@"count"]];
        _waveView.numberLabel.adjustsFontSizeToFitWidth = YES;
        _waveView.numberLabel.font = [UIFont boldSystemFontOfSize:42*CCXSCREENSCALE];
        _waveView.numberLabel.textColor = [UIColor whiteColor];
//        _waveView.unitLabel.text = @"%@";
        _waveView.unitLabel.font = [UIFont boldSystemFontOfSize:14*CCXSCREENSCALE];
//        _waveView.unitLabel.textColor = [UIColor whiteColor];
        _waveView.explainLabel.text = @"完成度";
        _waveView.explainLabel.font = [UIFont systemFontOfSize:20];
        _waveView.explainLabel.adjustsFontSizeToFitWidth = YES;
        _waveView.explainLabel.textColor = [UIColor whiteColor];
        _waveView.percent = [self.detailDict[@"count"] floatValue]/100.0;
        [_waveView startWave];
    }
    return _waveView;
}

/*设置UI数据*/
-(void)setData{
    NSArray *titleArr = @[@"关于我们",@"意见反馈",@"修改密码"];
    NSArray *imgNameArr = @[@"实名认证_完成",@"建议意见_select",@"学籍_完成",];
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = @{@"title":obj,
                               @"imageName":imgNameArr[idx]};
        [self.dataSourceArr addObject:dict];
    }];
}

/*设置tableView的头*/
-(void)setHeader{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 400)];
    imageV.image = [UIImage imageNamed:@"背景.png"];

//    [imageV addSubview:self.waveView];
    self.tableV.tableHeaderView = imageV;
}

#pragma mark -tableView代理协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"userInfoCellId";
    GJJUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GJJUserInfoTableViewCell class]) owner:self options:nil]lastObject];
    }
    if (self.dataSourceArr.count) {
        NSDictionary *dic = self.dataSourceArr[indexPath.row];
        cell.userInfoImageView.image = [UIImage imageNamed:[dic objectForKey:@"imageName"]];
        [cell.userInfoImageView sizeToFit];
        cell.userInfoLabel.text = [dic objectForKey:@"title"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130*CCXSCREENSCALE;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCXUser *user = [self getSeccsion];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{//关于我们
            CCXRootWebViewController *rooVC = [CCXRootWebViewController new];
            rooVC.title = @"关于我们";
            rooVC.url = CCXABOUT;
            rooVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rooVC animated:YES];
            break;}
        case 1:{//建议意见
            if ([user.userId intValue] == -100) {
                [self pushToLoin];
                return;
            }
            WQSuggestionViewController *suggestionVC = [[WQSuggestionViewController alloc]init];
            suggestionVC.hidesBottomBarWhenPushed = YES;
            suggestionVC.title = @"意见反馈";
            [self.navigationController pushViewController:suggestionVC animated:YES];
            break;}
        case 2:{//修改密码
            if ([user.userId intValue] == -100) {
                [self pushToLoin];
                return;
            }
            [self prepareDataWithCount:WQModifyPwdGetValiCodeFromPhone];
            CCXUser *user = [self getSeccsion];
            WQResetViewController *resetPasswordVC = [[WQResetViewController alloc]init];
            resetPasswordVC.hidesBottomBarWhenPushed = YES;
            resetPasswordVC.title = @"修改密码";
            [self.navigationController pushViewController:resetPasswordVC animated:YES];
            resetPasswordVC.phoneString = user.phone;
            break;}
    }
}

- (void)pushToLoin
{
    WQLogViewController *loginVC = [WQLogViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.title = @"登录";
    loginVC.popViewController = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 300*CCXSCREENSCALE;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [UIView new];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CCXRectMake(40, 100, 670, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"安全退出" forState:UIControlStateNormal];
    [btn setTitle:@"去登录" forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[self getSeccsion] userId] intValue]<=0) {
        btn.selected = YES;
        //R:250 G:84 B:8
        btn.backgroundColor = [UIColor colorWithRed:250/255.0 green:84/255.0 blue:8/255.0 alpha:1];
    }
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20*CCXSCREENSCALE;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    [footerView addSubview:btn];
    return footerView;
}

-(void)onBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.backgroundColor = [UIColor colorWithRed:250/255.0 green:84/255.0 blue:8/255.0 alpha:1];
        WQLogViewController *loginVC = [WQLogViewController new];
        loginVC.title = @"登录";
        loginVC.hidesBottomBarWhenPushed = YES;
        loginVC.popViewController = self.navigationController.viewControllers[0];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        btn.backgroundColor = [UIColor redColor];
        CCXUser *user = [self getSeccsion];
        user.userId = @"-100";
        [self saveSeccionWithUser:user];
        [self.tableV reloadData];
    }
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
