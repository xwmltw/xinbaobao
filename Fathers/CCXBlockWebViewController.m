//
//  CCXBlockWebViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/25.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBlockWebViewController.h"

@interface CCXBlockWebViewController ()

@end

@implementation CCXBlockWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame = CGRectMake(0,66, CCXSIZE_W, CCXSIZE_H-66*(self.buttonTitle.length?1:0)-115*CCXSCREENSCALE);
    [self createButtonWithTitle:self.buttonTitle];
}

-(void)createButtonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CCXSIZE_H-115*CCXSCREENSCALE, CCXSIZE_W, 115*CCXSCREENSCALE);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:42*CCXSCREENSCALE];
    button.tag = -1000;
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.buttonTitle.length) {
        [self.view addSubview:button];
    }
}

-(void)onButtonClick:(UIButton *)button{
    if (self.returnTextBlock) {
        self.returnTextBlock(@"1");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnTextBlock:(ReturnTextValue)block{
    self.returnTextBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
