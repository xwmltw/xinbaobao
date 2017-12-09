
//
//  WQInteractionMessageDetailViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQInteractionMessageDetailViewController.h"

@interface WQInteractionMessageDetailViewController ()

@end

@implementation WQInteractionMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
}

-(void)setRequestParams{
    self.cmd = WQQueryOneMessageByMesId;
    self.dict = @{@"userId": [[self getSeccsion] userId],
                  @"mesId": self.messageId};
}

-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    [self.tableV removeFromSuperview];
    [self createTableViewWithFrame:CGRectMake(0, 64, CCXSIZE_W, CCXSIZE_H-64)];
    [self setFooter];
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [self.tableV removeFromSuperview];
    [self setHudWithName:@"加载失败" Time:0.5 andType:1];
    [self createTableViewWithFrame:CGRectMake(0, 64, CCXSIZE_W, CCXSIZE_H-64)];
    [self setFooter];
}


-(void)setFooter{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 750, 3375)];
    [imageV setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:[UIImage imageNamed:@"活动默认图"]];
        self.tableV.tableFooterView = imageV;
}

-(void)headerRefresh{
    [self prepareDataWithCount:0];
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
