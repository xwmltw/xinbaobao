//
//  WQLoanDetailViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/28.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQLoanDetailViewController.h"

@interface WQLoanDetailViewController ()

@end

@implementation WQLoanDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showTabBar];
}

-(void)setView{
    UILabel *displayLabel = [[UILabel alloc]init];
    displayLabel.frame = CCXRectMake(0, 100+64, 750, 100);
    displayLabel.text = @"正在开通中,敬请期待";
    displayLabel.textAlignment = NSTextAlignmentCenter;
    displayLabel.font = [UIFont fontWithName:@"Zapf Dingbats" size:30];
    NSLog(@"%@",[UIFont familyNames]);
    [self.view addSubview:displayLabel];
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
