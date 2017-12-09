//
//  CCXRootWebViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXRootWebViewController.h"

@interface CCXRootWebViewController ()<
WKUIDelegate,
WKNavigationDelegate
>

@end

@implementation CCXRootWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"常见问题"];
    
    self.view.backgroundColor = CCXColorWithHex(@"#ffffff");
    [self createWebViewWithURL:self.url];
    // Do any additional setup after loading the view.
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

-(void)createWebViewWithURL:(NSString *)url{
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = CCXColorWithRGB(78, 142, 220);
    [self.view addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(2*CCXSCREENSCALE));
    }];
    
    WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize =10;
    config.preferences.javaScriptEnabled =YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically =NO;
    
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

    /**网页*/
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [self.webView.configuration.userContentController addUserScript:noneSelectScript];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

//kvo观察者方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]&&object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if (_webView.estimatedProgress == 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView updateConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(self.view);
                    make.height.equalTo(@(0));
                }];
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//移除观察者
-(void)dealloc{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
