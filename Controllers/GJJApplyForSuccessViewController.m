//
//  GJJApplyForSuccessViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/27.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJApplyForSuccessViewController.h"
#import "CCXBillViewController.h"
#import "CCXBillDetailViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

@interface GJJApplyForSuccessViewController ()

@end

@implementation GJJApplyForSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    backView.backgroundColor = CCXColorWithHex(@"f2f2f2");
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@(AdaptationHeight(15)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(12)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-12)));
        make.height.equalTo(self.view).multipliedBy(0.46);
    }];
    
    UIImageView *receiveImageView = [[UIImageView alloc]init];
    [backView addSubview:receiveImageView];
    receiveImageView.image = [UIImage imageNamed:@"shoudao"];
    [receiveImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.top.equalTo(backView).offset(@(AdaptationHeight(30)));
        make.width.equalTo(@(AdaptationWidth(42)));
        make.height.equalTo(@(AdaptationHeight(46)));
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [backView addSubview:hintLabel];
    hintLabel.text = @"您的提现申请已收到，我们会尽快完成审核。";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    hintLabel.textColor = CCXColorWithHex(@"666666");
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(receiveImageView.bottom).offset(@(AdaptationHeight(30)));
        make.left.right.equalTo(backView);
        make.height.equalTo(@(AdaptationWidth(20)));
    }];

    
//    NSURL *gifUrl = [[NSBundle mainBundle] URLForResource:@"动画2" withExtension:@"gif"];
//    NSData *gifData = [NSData dataWithContentsOfURL:gifUrl];
//    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc]init];
//    [backView addSubview:gifImageView];
//    gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
//    [gifImageView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(hintLabel.bottom).offset(@(AdaptationHeight(17)));
//        make.left.equalTo(backView.left).offset(@(AdaptationWidth(10)));
//        make.right.equalTo(backView.right).offset(@(AdaptationWidth(-10)));
//        make.height.equalTo(@(AdaptationHeight(20)));
//    }];
    
    UIButton *progressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:progressButton];
    progressButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [progressButton setTitle:@"查看进度" forState:UIControlStateNormal];
    [progressButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    progressButton.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(17)];
    progressButton.layer.cornerRadius = 4;
    progressButton.layer.masksToBounds = YES;
    [progressButton addTarget:self action:@selector(watchProgressClick) forControlEvents:UIControlEventTouchUpInside];
    [progressButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel.bottom).offset(@(AdaptationHeight(77)));
        make.centerX.equalTo(backView);
        make.width.equalTo(backView).multipliedBy(0.8);
        make.height.equalTo(backView).multipliedBy(0.16);
    }];
}

#pragma mark - button click
- (void)watchProgressClick
{
    CCXBillDetailViewController *billVC = [CCXBillDetailViewController new];
    billVC.billId = _withDrawId;
    billVC.mesId = @"";
    billVC.isJump = @"no";
    billVC.title = @"订单详情";
    billVC.isNeedPopToRootController = YES;
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)BarbuttonClick:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
