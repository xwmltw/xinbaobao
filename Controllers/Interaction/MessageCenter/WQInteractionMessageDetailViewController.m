
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

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)setRequestParams{
    self.cmd = WQQueryOneMessageByMesId;
    self.dict = @{@"messageId": self.messageId};
}

-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    [self.tableV removeFromSuperview];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self setFooter];
}

-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [self.tableV removeFromSuperview];
    [self setHudWithName:@"加载失败" Time:0.5 andType:1];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
