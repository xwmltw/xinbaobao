//
//  CCXRootWebViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"
#import <WebKit/WebKit.h>

@interface CCXRootWebViewController : CCXNeedBackViewController
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,copy)NSString *url;


/**
 void

 @param url 网址
 */
-(void)createWebViewWithURL:(NSString *)url;

@end
