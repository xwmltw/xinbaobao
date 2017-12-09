//
//  STMessageCenterController.m
//  XianJinDaiSystem
//
//  Created by 孙涛 on 2017/9/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STMessageCenterController.h"
#import "STMessageCenterCell.h"
#import "WQInteractionMessage.h"
#import "SDAutoLayout.h"
#import "GJJQueryServiceUrlModel.h"
#import "WQMessageDetailViewController.h"
#import "WQInteractionDetailViewController.h"
typedef NS_ENUM(NSInteger,STToQueryAnnounceRequest){
    STQueryAnnounceRequest
};
@interface STMessageCenterController ()

@end

@implementation STMessageCenterController{
    NSMutableArray       *_dataArr;
    NSMutableArray       *_systemArr;
    NSMutableArray       *_activityArr;
    UIView               *_headView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setClearNavigationBar];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self prepareDataWithCount:STQueryAnnounceRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    [self isNeedShowGuide];
    [self setupData];
//    [self prepareDataWithCount:0];
    [self setupView];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)setupData{
    _dataArr = [[NSMutableArray alloc]init];
    _systemArr = [[NSMutableArray alloc]init];
    _activityArr = [[NSMutableArray alloc]init];
}

-(void)setupView{
//    [self setNavigationBar];
//    [self createTableViewWithFrame:CGRectZero];
    [self setupTableView];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);

    }];

    self.tableV.estimatedRowHeight = 0;
    self.tableV.estimatedSectionFooterHeight = 0;
    self.tableV.estimatedSectionHeaderHeight = 0;
    self.tableV.backgroundColor = CCXColorWithHex(@"#FFFFFF");
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)setupTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = CCXBackColor;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    tableView.mj_footer.hidden = YES;
    
    [self.view addSubview:tableView];
    self.tableV = tableView;
}

-(void)headerRefresh{
    [self prepareDataWithCount:STQueryAnnounceRequest];

}

-(void)setNavigationBar{
    
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:18];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor] ;  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"公告中心";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar setBackgroundImage:[GJJAppUtils createImageWithColor:[UIColor colorWithHexString:STNaviBarColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationHeight(147);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptationWidth(145);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headView = [[UIView alloc]init];
    _headView.frame = XWMRectMake(0, 0, 375, 145);
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"公告中心";
    [lab setFont:[UIFont systemFontOfSize:AdaptationWidth(32)]];
    [lab setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [_headView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView).offset(AdaptationWidth(60));
        make.left.mas_equalTo(_headView).offset(AdaptationWidth(24));
    }];
    
    return _headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    STMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[STMessageCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_dataArr.count > 0 && _dataArr) {
        cell.messageModel = _dataArr[indexPath.row];
    }

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WQInteractionMessage *model = _dataArr[indexPath.row];
    
    if ([model.type isEqualToString:@"0"]) {
        WQMessageDetailViewController *controller = [[WQMessageDetailViewController alloc]init];
        controller.title = @"系统消息";
        controller.messageId = model.messageId;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }else{
        
        if (model.h5Url.length > 0) {
            WQInteractionDetailViewController *controller = [[WQInteractionDetailViewController alloc] init];
            controller.title = model.title;
            controller.url = model.h5Url;
            controller.mesId = model.messageId;
            controller.model = model;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }

    
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    self.cmd = WQQueryAnnounce;
    NSString *uuidStr = nil;
    uuidStr = [self getUUID];
    self.dict = @{@"userId" :[user.userId integerValue] == -100 ? @"" : user.userId,
                  @"phoneId":uuidStr};
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
//    MyLog(@"%@",dict);
    self.tableV.tableFooterView = nil;
    [_dataArr removeAllObjects];
    [_systemArr removeAllObjects];
    for (NSDictionary *systemDic in dict[@"systemAnnounce"]) {
        WQInteractionMessage *messageModel = [WQInteractionMessage yy_modelWithDictionary:systemDic];
        messageModel.type = @"0";
        [_dataArr addObject:messageModel];
    }
    
    [_activityArr removeAllObjects];
    CCXUser *user = [self getSeccsion];
//    NSString *interactionAppendingh5Url = nil;
    for (NSDictionary *interactionDic in dict[@"activAnnounce"]) {
        WQInteractionMessage *interactionModel = [WQInteractionMessage yy_modelWithDictionary:interactionDic];

        interactionModel.type = @"1";
        [_dataArr addObject:interactionModel];
    }
    
    NSInteger OnOff = [GJJQueryServiceUrlModel sharedInstance].switch_on_off_2.integerValue;
    if (!OnOff) {
        [_dataArr removeAllObjects];
    }
    if (_dataArr.count == 0) {
        [self setSystemFooter];
    }


    [self.tableV reloadData];
}


/**
 网络请求失败之后的结果
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
    //    [_tableView_Interaction.mj_header endRefreshing];
    //    [_tablelView_System.mj_header endRefreshing];
    [self setSystemFooter];

}


-(void)setSystemFooter{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, AdaptationWidth(147), self.tableV.frame.size.width, self.tableV.frame.size.height-AdaptationWidth(147))];

    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"activity_nodata"]];
    [footerView addSubview:imageV];
    
//    imageV.sd_layout.spaceToSuperView(UIEdgeInsetsZero)
    imageV.sd_layout
    .centerXEqualToView(footerView)
    .centerYEqualToView(footerView)
    .widthIs(AdaptationWidth(150))
    .heightIs(AdaptationWidth(150));
    
    if (_dataArr.count == 0) {

        self.tableV.tableFooterView = footerView;
    }else {
        self.tableV.tableFooterView = nil;
    }
}

@end
