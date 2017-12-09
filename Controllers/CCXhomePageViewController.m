//
//  CCXhomePageViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXhomePageViewController.h"
#import "CCXLoanViewController.h"
#define CCXICONImage @"首页banner-加载页"

@interface CCXhomePageViewController ()<
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollerV;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,copy)NSArray *imageArr;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation CCXhomePageViewController

#pragma mark -- 控制器方法

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self setClearNavigationBar];
    [self prepareDataWithCount:0];
    [self showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 网络请求

/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    self.cmd = CCXQueryAdvrByModule;
    self.dict = @{@"module": @"1"};
}

/**
 网络请求成功之后的结果

 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    self.imageArr = dict[@"dataList"];
    [self.view addSubview:self.scrollerV];
    [self setFooter];
}

#pragma mark -- 自定义方法

/**
 定时器的懒加载

 @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:CCXBannerTimer target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate date];
    }
    return _timer;
}

/**
 pageControl的懒加载

 @return pageControl
 */
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CCXRectMake(0,20,750.0,20)];
        _pageControl.numberOfPages  = self.imageArr.count;
        [_pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
        self.timer.fireDate = [NSDate date];
    }
    return _pageControl;
}

/**
 scrollerView的懒加载

 @return scrollerView
 */
-(UIScrollView *)scrollerV{
    if (!_scrollerV) {
        _scrollerV = [[UIScrollView alloc]initWithFrame:CCXRectMake(0.0f, 0.0f, 750.0f, 1037.0f)];
        _scrollerV.contentSize = CCXSizeMake(750.0f*self.imageArr.count, 1037.f);
        [self.imageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *image = [self CCXImageViewWithImageName:CCXICONImage url:obj[@"url"] andFrame:CCXRectMake(750.0f*idx, 0, 750.f, 1037.f) tag:(int)idx+1];
            [self.scrollerV addSubview:image];
        }];
        self.scrollerV.pagingEnabled = YES;
        self.scrollerV.delegate = self;
        self.scrollerV.bounces = NO;
        self.scrollerV.showsVerticalScrollIndicator = NO;
        self.scrollerV.showsHorizontalScrollIndicator = NO;
    }
    return _scrollerV;
}

/**
 创建首页非scrollerView部分
 */
-(void)setFooter{
    UIImageView *imageV = [self CCXImageViewWithImageName:@"footerBg" url:nil andFrame:CGRectMake(0, CCXSIZE_H-49-339*CCXSCREENSCALE, CCXSIZE_W, 339*CCXSCREENSCALE) tag:10];
    [self.view addSubview:imageV];
    UILabel *label = [[UILabel alloc]initWithFrame:CCXRectMake(85.0f, 205.0f, 580.0f, 88.0f)];
    label.text = @"立即提现";
    label.backgroundColor = [UIColor whiteColor];
    label.layer.cornerRadius = 8*CCXSCREENSCALE;
    label.clipsToBounds = YES;
    label.textColor = CCXColorWithHex(@"#01aaef");
    label.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:label];
    [imageV addSubview:self.pageControl];
}

#pragma mark - UI事件

/**
 定时器执行时的事件

 @param timer baner的定时器
 */
-(void)timeRun:(NSTimer *)timer{
    static int i=0;
     [self.scrollerV scrollRectToVisible:CCXRectMake(750.0f*(i++%self.imageArr.count), 0, 750.0, 1037.0f) animated:YES];
}

/**
 *  图片按钮的点击事件
 */
-(void)CCXImageClick:(UIButton *)button{
    if (button.tag == 104) {//引导页最后一页的点击事件
    }else if (button.tag == 10){//立即提现按钮的点击事件
        CCXLoanViewController *loanVC = [CCXLoanViewController new];
        loanVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loanVC animated:YES];
    }
}

/**
 pageControl的点击事件

 @param pageControl 被点击的pageControl
 */
-(void)pageChanged:(UIPageControl *)pageControl{
     [self.scrollerV scrollRectToVisible:CCXRectMake(750.0f*pageControl.currentPage, 0, 750.0, 1037.0f) animated:YES];
}

#pragma mark - scrollerView的代理方法

/**
 scrollerView滑动之后的执行
 @param scrollView 被滑动的点击事件
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollerV) {
       _pageControl.currentPage = scrollView.contentOffset.x/CCXSIZE.width;
    }
}

@end
