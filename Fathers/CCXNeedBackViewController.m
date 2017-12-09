//
//  CCXNeedBackViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/10/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@interface CCXNeedBackViewController ()

@end

@implementation CCXNeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self setBackNavigationBarItem];
    [self.navigationController.navigationBar setBackgroundImage:[GJJAppUtils createImageWithColor:CCXColorWithRGB(78, 142, 220)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

-(void)BarbuttonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
