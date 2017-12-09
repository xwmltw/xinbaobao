#import "WQToInteractionViewController.h"
#import "WQModifyPasswordViewController.h"
#import "WQRedrawTextfield.h"
#import "WQLogViewController.h"
#import <Masonry/Masonry.h>

#import "WQInteractionMessage.h"
#import "WQInteractionMessageCell.h"
#import "WQInteractionMessageDetailViewController.h"

#import "WQSystemMessage.h"
#import "WQSystemMessageCell.h"
#import "WQMessageDetailViewController.h"

#import "WQPicAnnounce.h"
#import "WQRollingPictureViewController.h"

#import "WQInteractionDetailViewController.h"

typedef NS_ENUM(NSInteger,WQToQueryAnnounceRequest){
    WQQueryAnnounceRequest
};

@interface WQToInteractionViewController ()<UITextFieldDelegate,UIScrollViewDelegate,WQSystemMessageCellDelegate,WQInteractionMessageCellDelegate,UITableViewDataSource,UITableViewDelegate
>

@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *orangeView;

@property (nonatomic, strong) UIView *headView;

/**底部按钮视图中间的分割线*/
@property (nonatomic, strong) UIView *centerView;

/**底部按钮视图中间的下划线*/
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *pageTimer;

@property (nonatomic, strong) UIButton *buttonA;
@property (nonatomic, strong) UIButton *buttonB;

@property (nonatomic, strong) UITableView *tableView_Interaction;
@property (nonatomic, strong) UITableView *tablelView_System;

@property (nonatomic, strong) NSString    *fromNextControllerId;

@end

@implementation WQToInteractionViewController{
    WQRedrawTextfield    *_phoneTextAccount;
    WQRedrawTextfield    *_pwdTextAccount;
    WQRedrawTextfield    *_phoneTextQuick;
    WQRedrawTextfield    *_verificationTextQuick;
    UIButton             *_vericationRightBtn;
    NSInteger             _timer;
    NSTimer              *_timerCode;
    NSTimer              *_timerClose;
    NSDictionary         *_dict;
    UIImageView          *_interactionNewImageV;
    UIImageView          *_systemNewImageV;
    NSMutableArray       *_rollingPics;
    UIScrollView         *_headScrollView;
    UIPageControl        *_pageControl;
    NSMutableArray       *_interactionArr;
    NSMutableArray       *_systemArr;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self prepareDataWithCount:WQQueryAnnounceRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _systemArr      = [NSMutableArray new];
    _interactionArr = [NSMutableArray new];
    _rollingPics    = [NSMutableArray new];
    [self setup_UI];
}



#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    self.cmd = WQQueryAnnounce;
    NSString *uuidStr = nil;
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    if ([user.userId intValue] == -100) {
         uuidStr = [NSString stringWithFormat:@"%@",uuid];
        MyLog(@"%@",uuid);
    }else{
         uuidStr = @"";
    }
    self.dict = @{@"userId" :user.userId,
                  @"system":uuidStr};
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    [self setHudWithName:@"获取成功" Time:0.5 andType:0];
//    [_tableView_Interaction.mj_header endRefreshing];
//    [_tablelView_System.mj_header endRefreshing];
    [_systemArr removeAllObjects];
    for (NSDictionary *systemDic in dict[@"systemAnnounce"]) {
        WQSystemMessage *systemModel = [WQSystemMessage yy_modelWithDictionary:systemDic];
        [_systemArr addObject:systemModel];
    }

    [_interactionArr removeAllObjects];
    for (NSDictionary *interactionDic in dict[@"activAnnounce"]) {
        WQInteractionMessage *interactionModel = [WQInteractionMessage yy_modelWithDictionary:interactionDic];
        [_interactionArr addObject:interactionModel];
    }
    
    [_rollingPics removeAllObjects];
    for (NSDictionary *rollingPicsDic in dict[@"picAnnounce"]) {
        WQPicAnnounce *picAnnounceModel = [WQPicAnnounce yy_modelWithDictionary:rollingPicsDic];
        [_rollingPics addObject:picAnnounceModel];
    }
    [self setRefreshUI];
    [self.tablelView_System reloadData];
    [self.tableView_Interaction reloadData];
}


/**
 网络请求失败之后的结果
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
//    [_tableView_Interaction.mj_header endRefreshing];
//    [_tablelView_System.mj_header endRefreshing];
    [self setSystemFooter];
    [self setInteractionFooter];
}

/**
 headScrollerView的懒加载
 @return headScrollerView
 */
-(UIScrollView *)headScrollView{
    if (!_headScrollView) {
        _headScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _headScrollView.pagingEnabled = YES;
        _headScrollView.delegate = self;
        _headScrollView.contentOffset = CGPointMake(CCXSIZE_W, 0);
        _headScrollView.bounces = NO;
        _headScrollView.showsVerticalScrollIndicator = NO;
        _headScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _headScrollView;
}

#pragma mark --pageControl
/**
 pageControl的懒加载
 @return pageControl
 */
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}


//初始化控件，添加到控件到视图上并设置控件属性。
- (void)setup_UI {
    //headerView
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor colorWithHexString:@"#1ec3ab"];
    [self.view addSubview:self.headView];
    
    //配置scrollView的属性
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:@"#f0eff5"]];
    [self.scrollView setContentSize:CGSizeMake(CCXSIZE_W * 2, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    
    //新建按钮
    self.buttonView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.buttonA = [[UIButton alloc] init];
    self.buttonB = [[UIButton alloc] init];
    self.greenView  = [[UIView alloc] init];
    self.orangeView = [[UIView alloc] init];
    self.greenView.backgroundColor = [UIColor colorWithHexString:@"#f0eff5"];
    self.orangeView.backgroundColor = [UIColor colorWithHexString:@"#f0eff5"];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.greenView];
    [self.scrollView addSubview:self.orangeView];
    
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.buttonA];
    [self.buttonView addSubview:self.buttonB];
    
    [self.buttonView addSubview:self.bottomView];
    [self.bottomView setBackgroundColor:[UIColor colorWithHexString:@"#1ec3ab"]];
    
    [self.buttonA setTitle:@"活动公告" forState:UIControlStateNormal];
    [self.buttonB setTitle:@"系统公告" forState:UIControlStateNormal];
    [self.buttonA setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.buttonA setBackgroundColor:[UIColor whiteColor]];
    [self.buttonB setBackgroundColor:[UIColor whiteColor]];
    [self.buttonA setTitle:@"活动公告" forState:UIControlStateSelected];
    [self.buttonB setTitle:@"系统公告" forState:UIControlStateSelected];
    [self.buttonA setTitleColor:[UIColor colorWithHexString:@"#1ec3ab"] forState:UIControlStateSelected];
    [self.buttonB setTitleColor:[UIColor colorWithHexString:@"#1ec3ab"] forState:UIControlStateSelected];
    
    self.buttonA.titleLabel.font = [UIFont systemFontOfSize:18];
    self.buttonB.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.buttonA.selected = YES;
    
    [self.buttonA addTarget:self action:@selector(clickButtonA) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonB addTarget:self action:@selector(clickButtonB) forControlEvents:UIControlEventTouchUpInside];
    
    _interactionNewImageV = [[UIImageView alloc]init];
    _interactionNewImageV.image = [UIImage imageNamed:@"dot_2x"];
    [self.buttonA addSubview:_interactionNewImageV];
    
    _systemNewImageV = [[UIImageView alloc]init];
    _systemNewImageV.image = [UIImage imageNamed:@"dot_2x"];
    [self.buttonB addSubview:_systemNewImageV];
    
    //活动公告的tableView
    self.tableView_Interaction = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView_Interaction.backgroundColor = [UIColor colorWithHexString:@"#f0eff5"];
    [self.greenView addSubview:self.tableView_Interaction];
//    self.tableView_Interaction.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(WQHeaderRefresh)];
    self.tableView_Interaction.dataSource = self;
    self.tableView_Interaction.delegate = self;
    self.tableView_Interaction.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView_Interaction.separatorStyle = UITableViewCellSelectionStyleNone;
    [self prepareDataWithCount:WQQueryAnnounceRequest];
    
    //系统公告的tableView
    self.tablelView_System = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tablelView_System.backgroundColor = [UIColor colorWithHexString:@"#f0eff5"];
    [self.orangeView addSubview:self.tablelView_System];
//    self.tablelView_System.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(WQHeaderRefresh)];
    self.tablelView_System.dataSource = self;
    self.tablelView_System.delegate = self;
    self.tablelView_System.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tablelView_System.separatorStyle = UITableViewCellSelectionStyleNone;
    [self prepareDataWithCount:WQQueryAnnounceRequest];
    
    //页面控件的布局
    [self setup_Layout];
}

-(void)setRefreshUI{
    [self.headView addSubview:self.headScrollView];
    [_headScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.headView);
    }];
    _headScrollView.contentSize = CGSizeMake(CCXSIZE_W*_rollingPics.count, self.headView.frame.size.height);
    [_rollingPics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WQPicAnnounce *model = _rollingPics[idx];
        UIImageView *imageV = [self CCXImageViewWithImageName:@"" url:model.picUrl andFrame:CGRectMake(CCXSIZE_W*idx, 0, CCXSIZE_W, _headScrollView.frame.size.height) tag:(int)idx+101];
        [_headScrollView addSubview:imageV];
    }];
    
    [self.headView addSubview:self.pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headView);
        make.centerX.mas_equalTo(self.headView);
        make.width.mas_equalTo(@100);
    }];
    _pageControl.numberOfPages  = _rollingPics.count;
    [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    self.pageTimer.fireDate = [NSDate distantPast];
    
    for (WQInteractionMessage *interactionModel in _interactionArr) {
        if ([interactionModel.isRead intValue] == 0) {
            [_interactionNewImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.buttonA).offset(@15);
                make.left.mas_equalTo(self.buttonA.titleLabel.right);
                make.width.mas_equalTo(@5);
                make.height.mas_equalTo(@5);
            }];
        }else{
            [_systemNewImageV removeFromSuperview];
        }
    }
    
    for (WQSystemMessage *systemModel in _systemArr) {
        if ([systemModel.isRead intValue] == 0) {
            [_systemNewImageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.buttonB).offset(@15);
                make.left.mas_equalTo(self.buttonB.titleLabel.right);
                make.width.mas_equalTo(@5);
                make.height.mas_equalTo(@5);
            }];
        }else{
            [_interactionNewImageV removeFromSuperview]; 
        }
    }
}

#pragma mark - 约束设置
- (void)setup_Layout {
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(150);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.bottom);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(50);
    }];
    
    [self.buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 2);
        make.left.mas_equalTo(self.buttonView);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    [self.buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 2);
        make.right.mas_equalTo(self.buttonView);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(CCXSIZE_W / 2 - 20);
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(10);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.bottom);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(CCXSIZE_H-200-49);
    }];
    
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(self.scrollView.left);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(self.scrollView.height);
    }];
    
    [self.orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(self.greenView.right);
        make.width.mas_equalTo(CCXSIZE_W);
        make.height.mas_equalTo(self.scrollView.height);
    }];
    
    [self.tableView_Interaction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(self.greenView);
        make.bottom.mas_equalTo(self.greenView).offset(-10);
    }];
    
    [self.tablelView_System mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.mas_equalTo(self.orangeView);
        make.bottom.mas_equalTo(self.orangeView).offset(-10);
    }];
}


//按钮的点击方法，当按钮被点击时，移动到相应的位置，显示相应的view。
#pragma mark - 按钮的点击事件
- (void)clickButtonA {
    self.buttonB.selected = NO;
    self.buttonA.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
}

- (void)clickButtonB {
    self.buttonA.selected = NO;
    self.buttonB.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(CCXSIZE_W, 0) animated:NO];
    }];
}

#pragma mark -- 定时器
/**
 定时器的懒加载
 @return 定时器
 */
-(NSTimer *)pageTimer{
    if (!_pageTimer) {
        _pageTimer = [NSTimer scheduledTimerWithTimeInterval:CCXBannerTimer target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
        _pageTimer.fireDate = [NSDate distantFuture];
    }
    return _pageTimer;
}


/**
 定时器执行时的事件
 @param timer baner的定时器
 */
-(void)timeRun:(NSTimer *)timer{
    static int i=0;
    [_headScrollView scrollRectToVisible:CGRectMake(CCXSIZE_W*(i++%_rollingPics.count), 0, CCXSIZE_W, _headView.frame.size.height) animated:YES];
}

/**
 pageControl的点击事件
 @param pageControl 被点击的pageControl
 */
-(void)pageChanged:(UIPageControl *)pageControl{
    [_headScrollView scrollRectToVisible:CGRectMake(CCXSIZE_W*_pageControl.currentPage, 0, CCXSIZE_W, _headView.frame.size.width) animated:YES];
}

/*图片点击事件*/
-(void)CCXImageClick:(UIButton *)button{
    WQPicAnnounce *model = _rollingPics[button.tag - 101];
        WQRollingPictureViewController *controller = [WQRollingPictureViewController new];
        controller.url = model.h5Url;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
}

//ScrollView代理方法的代理方法，通过此方法获取当前拖动时的contentOffset.x来判断当前的位置，然后选中相应的按钮，执行相应的动画效果。

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        //    NSLog(@"%s",__func__);
        //判断当前滚动的水平距离时候超过一半
        if (scrollView.contentOffset.x > CCXSIZE_W / 2) {
            //更新约束动画
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10 + CCXSIZE_W / 2);
            }];
            //修改button按钮的状态
            [UIView animateWithDuration:0.3 animations:^{
                //强制刷新页面布局，不执行此方法，约束动画是没有用的！！！！！
                [self.buttonView layoutIfNeeded];
                self.buttonA.selected = NO;
                self.buttonB.selected = YES;
                self.buttonB.titleLabel.font = [UIFont systemFontOfSize:18];
                self.buttonA.titleLabel.font = [UIFont systemFontOfSize:15];
            }];
        } else {
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
            }];
            [UIView animateWithDuration:0.3 animations:^{
                [self.buttonView layoutIfNeeded];
                self.buttonB.selected = NO;
                self.buttonA.selected = YES;
                self.buttonB.titleLabel.font = [UIFont systemFontOfSize:15];
                self.buttonA.titleLabel.font = [UIFont systemFontOfSize:18];
            }];
        }
    }else if (scrollView == _headScrollView) {
        _pageControl.currentPage = scrollView.contentOffset.x/CCXSIZE_W;
    }
}

//-(void)WQHeaderRefresh{
//    [self prepareDataWithCount:WQQueryAnnounceRequest];
//}


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView_Interaction) {
        return _interactionArr.count;
    }
    return _systemArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView_Interaction) {
        return 306*CCXSCREENSCALE;
    }
    return 306*CCXSCREENSCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView_Interaction) {
        static NSString *cellID = @"cellId";
        WQInteractionMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WQInteractionMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = CCXBackColor;
            cell.delegate = self;
        }
        if (_interactionArr.count) {
            WQInteractionMessage *model = _interactionArr[indexPath.row];
            cell.model = model;
            cell.btn.tag = indexPath.row+1;
            cell.cellRow = indexPath.row;
        }
        return cell;
    }
    static NSString *cellID = @"cellId";
    WQSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WQSystemMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = CCXBackColor;
        cell.delegate = self;
    }
    if (_systemArr.count) {
        WQSystemMessage *model = _systemArr[indexPath.row];
        cell.model = model;
        cell.btn.tag = indexPath.row+1;
        cell.cellRow = indexPath.row;
    }
    return cell;
}

-(void)WQSystemCustomBtnClicked:(UIButton *)button{
    CCXUser *user = [self getSeccsion];
    WQSystemMessage *model = _systemArr[button.tag-1];
    if ([user.userId intValue] == -100) {
        [self setHudWithName:@"查看详情,请登录" Time:1 andType:3];
        [self pushToLogin];
    }else{
        WQMessageDetailViewController *controller = [[WQMessageDetailViewController alloc]init];
        controller.title = @"系统消息";
        controller.messageId = model.messageId;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)WQInteractionCustomBtnClicked:(UIButton *)button{
    CCXUser *user = [self getSeccsion];
    WQInteractionMessage *model = _interactionArr[button.tag-1];
    if ([user.userId intValue] == -100) {
        [self setHudWithName:@"查看详情,请登录" Time:1 andType:3];
        [self pushToLogin];
    }else{
        WQInteractionDetailViewController *controller = [[WQInteractionDetailViewController alloc] init];
        controller.title = @"活动消息";
        controller.url = model.h5Url;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)setSystemFooter{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 920)];
    imageV.image = [UIImage imageNamed:@"无消息"];
    if (!_systemArr.count) {
        self.tablelView_System.tableFooterView = imageV;
    }
}

-(void)setInteractionFooter{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 920)];
    imageV.image = [UIImage imageNamed:@"无消息"];
    if (!_interactionArr.count) {
        self.tableView_Interaction.tableFooterView = imageV;
    }
}

- (void)pushToLogin{
    WQLogViewController *loginVC = [WQLogViewController new];
    loginVC.hidesBottomBarWhenPushed = YES;
    loginVC.title = @"登录";
    loginVC.popViewController = self;
    [self.navigationController pushViewController:loginVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
