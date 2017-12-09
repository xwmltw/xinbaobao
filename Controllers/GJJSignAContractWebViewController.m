//
//  GJJSignAContractWebViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJSignAContractWebViewController.h"
#import "CCXBillDetailViewController.h"

@interface GJJSignAContractWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@end

@implementation GJJSignAContractWebViewController
{
    NSMutableArray *_URLArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _URLArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    [_URLArray addObject:URL];
    NSString *scheme = [URL scheme];
    
    if ([scheme isEqualToString:@"haleyaction"]) {
        NSURL *successURL = _URLArray[_URLArray.count - 2];
        NSArray *paramsArray = [self getParamsWithURLString:successURL.absoluteString];
        decisionHandler(WKNavigationActionPolicyCancel);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:GJJSIGNCONTRACTSUCCESS object:paramsArray];
        
        [self popToBillDetail];

        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (NSArray *)getParamsWithURLString:(NSString *)urlString
{
    //用来作为函数的返回值，数组里里面可以存放每个url转换的字典
    NSMutableArray *arrayData = [NSMutableArray arrayWithCapacity:4];
    
    //获取问号的位置，问号后是参数列表
    NSRange range = [urlString rangeOfString:@"?"];
    
    //获取参数列表
    NSString *propertys = [urlString substringFromIndex:(int)(range.location+1)];
    
    //进行字符串的拆分，通过&来拆分，把每个参数分开
    NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
    
    //把subArray转换为字典
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        //给字典加入元素
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    
    [arrayData addObject:tempDic];
    
    return arrayData;
}

- (void)BarbuttonClick:(UIButton *)button
{
    [self popToBillDetail];
}

- (void)popToBillDetail
{
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[CCXBillDetailViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
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
