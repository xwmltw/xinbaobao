//
//  WQQuickRepayViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2017/2/4.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "WQQuickRepayViewController.h"
#import "Masonry.h"
#import "WQQuickRepayModel.h"
#import "WQQuickRepayCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WQDashLineView.h"

typedef NS_ENUM(NSInteger,WQQuickPaymentRequest){
    WQQuickPayRequest,
    WQAlipayRequest
};

@interface WQQuickRepayViewController ()<
UITableViewDataSource,
UITableViewDelegate>{
    NSString       *_totalAmtStr;
    UILabel        *_repayFundTitle;
    UILabel        *_explanationTitle;
    UILabel        *_separateLine;
    UILabel        *_totalAmt;
    UIButton       *_bottomBtn;
    UIView         *_shadowView;
    UILabel        *_repayDetailLabel;
    UIView         *_headerView;
    NSMutableArray *_repayList;
    NSMutableArray *_repayIDArr;
    UIView         *_customerHeaderView_Left;
    UIView         *_customerHeaderView_Right;
    int            ob;
}

@property (nonatomic, strong) UIView *customerHeaderView;
@property (nonatomic, strong) UITableView *repayTableView;

@end

@implementation WQQuickRepayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCXBackColor;
    self.repayTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.repayTableView];
    _repayList  = [NSMutableArray new];
    _repayIDArr = [NSMutableArray new];
    self.repayTableView.dataSource = self;
    self.repayTableView.delegate = self;
    self.repayTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //Set the CustomerHeaderView as the tables header view
    self.repayTableView.tableHeaderView = self.customerHeaderView;
    [self createBottomBtn];
    [self setUpLayout];
   
    // Do any additional setup after loading the view.
}

/**tableView位置从0开始*/
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareDataWithCount:WQQuickPayRequest];
}

/**下拉刷新*/
-(void)headerRefresh{
    [self prepareDataWithCount:WQQuickPayRequest];
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    if (self.requestCount == WQQuickPayRequest) {
        self.cmd  = WQFastRepayment;
        self.dict = @{@"userId" :user.userId};
    }else if (self.requestCount == WQAlipayRequest){
        self.cmd  = CCXPayZfb;
        self.dict = @{@"repayIds": _repayIDArr};
    }
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (self.requestCount == WQQuickPayRequest) {
        MyLog(@"+++++++++++++++++%@",dict);
        [self setHudWithName:@"获取成功" Time:0.5 andType:0];
        [_repayList removeAllObjects];
        [_repayIDArr removeAllObjects];
        _totalAmtStr      = dict[@"totalAmt"];
        NSArray *dataList = dict[@"dataList"];
        for (NSDictionary *dic in dataList) {
            WQQuickRepayModel *model = [WQQuickRepayModel yy_modelWithDictionary:dic];
            [_repayList addObject:model];
            //入参是个字典/键值对
            NSDictionary *dic = @{@"repayId":model.repayDetailId};
            [_repayIDArr addObject:dic];
        }
        [self.repayTableView reloadData];
        [self setupRefreshUI];
        [self setFooter];
    }else if (self.requestCount == WQAlipayRequest){
        MyLog(@"---------------%@",dict);
        NSString *appScheme = ZFBSCHEME;
        [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"orderInfo"]fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                NSString *allString=resultDic[@"result"];
                NSString * FirstSeparateString=@"\"&";
                NSString *  SecondSeparateString=@"=\"";
                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                if ([dic[@"success"]isEqualToString:@"true"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
                }
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:returnStr=@"订单正在处理中";break;
                    case 4000:returnStr=@"订单支付失败";break;
                    case 6001:returnStr=@"订单取消";break;
                    case 6002:returnStr=@"网络连接出错";break;
                    default:break;}
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
            }
        }];
    }
}

/**刷新UI*/
-(void)setupRefreshUI{
     _totalAmt.text = [NSString stringWithFormat:@"￥%@",_totalAmtStr];
}

/**
 网络请求失败
 
 @param dict 网络请求失败提示
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [self requestFaildWithDictionary:dict];
}

/*headerView的lazy loading*/
- (UIView *) customerHeaderView{
    if (!_customerHeaderView) {
        /*注意headerView和footerView不能使用mansory 使用约束时还没有父视图*/
        self.customerHeaderView     = [[UIView alloc] initWithFrame:CCXRectMake(0, 0, CCXSIZE_W, 200)];
        self.customerHeaderView.backgroundColor = [UIColor whiteColor];
        
        _customerHeaderView_Left    = [[UIView alloc] initWithFrame:CGRectZero];
        [self.customerHeaderView addSubview:_customerHeaderView_Left];
        
        _customerHeaderView_Right   = [[UIView alloc] initWithFrame:CGRectZero];
        [self.customerHeaderView addSubview:_customerHeaderView_Right];
        
        _repayFundTitle             = [[UILabel alloc] initWithFrame:CGRectZero];
        _repayFundTitle.text        = @"还款金额:";
        _repayFundTitle.textAlignment = NSTextAlignmentCenter;
        _repayFundTitle.textColor   = CCXColorWithHex(@"#666666");
        _repayFundTitle.font        = [UIFont systemFontOfSize:32*CCXSCREENSCALE weight:20];
        [_customerHeaderView_Left addSubview:_repayFundTitle];
        
        _explanationTitle           = [[UILabel alloc] initWithFrame:CGRectZero];
        _explanationTitle.text      = @"注：同一笔借款订单，不可跨期还款";
        _explanationTitle.textColor = CCXColorWithHex(@"#999999");
        _explanationTitle.textAlignment = NSTextAlignmentCenter;
        _explanationTitle.font      = [UIFont systemFontOfSize:20*CCXSCREENSCALE weight:15];
        [_customerHeaderView_Left addSubview:_explanationTitle];
        
        _separateLine               = [[UILabel alloc] initWithFrame:CGRectZero];
        _separateLine.backgroundColor = CCXColorWithHex(@"#999999");
        [_customerHeaderView_Left addSubview:_separateLine];
        
        _totalAmt                   = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalAmt.text              = @"0";
        _totalAmt.textAlignment     = NSTextAlignmentCenter;
        _totalAmt.textColor         = CCXColorWithHex(@"#ee3131");
        _totalAmt.font              = [UIFont systemFontOfSize:36*CCXSCREENSCALE weight:20];
        [_customerHeaderView_Right addSubview:_totalAmt];
    }
    return _customerHeaderView;
}

/**底部立即还款按钮*/
-(void)createBottomBtn{
    _bottomBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.frame           = CGRectZero;
    _bottomBtn.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:36*CCXSCREENSCALE];
    [_bottomBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

/**
 适配
 */
- (void)setUpLayout{
    [self.repayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];

    [_customerHeaderView_Left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.equalTo(self.customerHeaderView);
        make.width.equalTo(self.customerHeaderView).multipliedBy(2.0/3);
    }];

    [_customerHeaderView_Right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.height.equalTo(self.customerHeaderView);
        make.width.equalTo(self.customerHeaderView).multipliedBy(1.0/3);
    }];

    [_separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(_customerHeaderView_Left);
        make.width.equalTo(1*CCXSCREENSCALE);
        make.height.equalTo(140*CCXSCREENSCALE);
    }];

    [_repayFundTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_customerHeaderView_Left).offset(50*CCXSCREENSCALE);
        make.height.equalTo(60*CCXSCREENSCALE);
        make.centerX.width.equalTo(_customerHeaderView_Left);
    }];

    [_explanationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_repayFundTitle.bottom).offset(18*CCXSCREENSCALE);
        make.width.centerX.equalTo(_customerHeaderView_Left);
        make.height.equalTo(50*CCXSCREENSCALE);
    }];

    [_totalAmt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(_customerHeaderView_Right);
        make.height.equalTo(40*CCXSCREENSCALE);
        make.centerY.equalTo(_customerHeaderView_Right);
    }];

    [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.height.equalTo(49);
    }];
}


#pragma tableView-delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _repayList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180*CCXSCREENSCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    WQQuickRepayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[WQQuickRepayCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
       if (_repayList.count) {
        WQQuickRepayModel *model = _repayList[indexPath.row];
        cell.model = model;
        cell.cellRow = indexPath.row;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100*CCXSCREENSCALE;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headerView                     = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.backgroundColor     = [UIColor whiteColor];

    _shadowView                 = [[UIView alloc] initWithFrame:CGRectZero];
    _shadowView.backgroundColor = CCXColorWithHex(@"#f2f2f2");
    [_headerView addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(_headerView);
        make.height.equalTo(20*CCXSCREENSCALE);
    }];
    
    UILabel *shadowLine         = [[UILabel alloc] initWithFrame:CGRectZero];
    shadowLine.backgroundColor  = CCXColorWithHex(@"#cccccc");
    shadowLine.layer.opacity    = 1;
    [_shadowView addSubview:shadowLine];
    [shadowLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(_shadowView);
        make.height.equalTo(2*CCXSCREENSCALE);
    }];
    
    _repayDetailLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
    _repayDetailLabel.text      = @"还款明细";
    _repayDetailLabel.font      = [UIFont systemFontOfSize:30*CCXSCREENSCALE weight:20];
    _repayDetailLabel.textColor = CCXColorWithHex(@"#666666");
    [_headerView addSubview:_repayDetailLabel];
    [_repayDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headerView).offset(10*CCXSCREENSCALE);
        make.height.equalTo(60*CCXSCREENSCALE);
        make.left.equalTo(30*CCXSCREENSCALE);
        make.width.equalTo(_headerView).multipliedBy(1.0/2);
    }];
    
    UILabel *line               = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor        = [UIColor lightGrayColor];
    [_headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerView).offset(60*CCXSCREENSCALE);
        make.right.bottom.equalTo(_headerView);
        make.height.equalTo(1*CCXSCREENSCALE);
    }];
    return _headerView;
}

-(void)setFooter{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 920)];
    imageV.image = [UIImage imageNamed:@"mybill_nomessage"];
    if (!_repayList.count) {
        self.repayTableView.tableFooterView = imageV;
    }
}

-(void)btnClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"-选择支付方式-" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (!ob) {
            [self addobserver];
            ob++;
        }
        [self prepareDataWithCount:WQAlipayRequest];
    }];
    [alertController addAction:moreAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



#pragma mark - 自定义方法

/**
 *  支付宝返回字段解析
 *
 *  @param AllString            字段
 *  @param FirstSeparateString  第一个分离字段的词
 *  @param SecondSeparateString 第二个分离字段的词
 *
 *  @return 返回字典
 */
-(NSMutableDictionary *)setComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
    }
    return dic;
}

/**
 添加观察者
 */
-(void)addobserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucesss:) name:@"AliPaySucceed" object:nil];
}

/**
 支付宝支付成功回调
 
 @param notificion 支付宝支付成功
 */
-(void)paySucesss:(NSNotification *)notificion{
    if ([notificion.userInfo[@"success"] isEqualToString:@"支付成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self setHudWithName:notificion.userInfo[@"success"] Time:1 andType:2];
    }
}



/**
 移除观察者
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
