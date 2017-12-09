//
//  GJJInfoSuccessHintViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/27.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJInfoSuccessHintViewController.h"
#import "GJJUserInfomationViewController.h"
#import "GJJAdultUserInfomationViewController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "GJJQueryServiceUrlModel.h"

@interface GJJInfoSuccessHintViewController ()

@end

@implementation GJJInfoSuccessHintViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //talkingdata
    [TalkingData trackEvent:@"资源完成"];
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
//    UIView *whiteView= [UIView new];
//    whiteView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    [self.view addSubview:whiteView];
//    [whiteView makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.equalTo(@(AdaptationHeight(203)));
//    }];
    
    UIImageView *infoDoneImageView = [[UIImageView alloc]init];
    [self.view addSubview:infoDoneImageView];
    infoDoneImageView.image = [UIImage imageNamed:@"picOfDone"];
    [infoDoneImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(-AdaptationWidth(30));
        make.height.mas_equalTo(AdaptationWidth(161));
        make.width.mas_equalTo(AdaptationWidth(327));
    }];
    
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [self.view addSubview:hintLabel];
    hintLabel.text = @"一切准备就绪";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(32)];
    hintLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.8);
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.bottom.mas_equalTo(infoDoneImageView.mas_top).offset(-AdaptationWidth(24));
    }];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:applyButton];
    applyButton.backgroundColor = CCXColorWithRGB(255, 97, 142);
    [applyButton setTitle:@"去借款" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    applyButton.layer.cornerRadius = 4;
    applyButton.layer.masksToBounds = YES;
    [applyButton addTarget:self action:@selector(applyForClick) forControlEvents:UIControlEventTouchUpInside];
    [applyButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(infoDoneImageView.mas_bottom).offset(AdaptationWidth(37));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    UIButton *liftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:liftButton];
    liftButton.backgroundColor = [UIColor clearColor];
    [liftButton setTitle:@"去提额" forState:UIControlStateNormal];
    [liftButton setTitleColor:CCXColorWithRGB(255, 97, 142) forState:UIControlStateNormal];
    liftButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    
    [liftButton addTarget:self action:@selector(liftClick) forControlEvents:UIControlEventTouchUpInside];
    [liftButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(applyButton.mas_bottom).offset(AdaptationWidth(16));
        make.left.right.height.mas_equalTo(applyButton);
    }];

    


}

#pragma mark - button click
- (void)liftClick
{
    //talkingdata
    [TalkingData trackEvent:@"提额按钮"];
    
    if ([GJJQueryServiceUrlModel sharedInstance].switch_on_off_3.integerValue == 1 ) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更多贷款产品" message:@"是否进入全网贷超市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[GJJQueryServiceUrlModel sharedInstance].switch_on_off_3_url]];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToViewController:self.popViewController animated:YES];
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:NO completion:nil];
    }
    
    if ([[self getSeccsion].orgId isEqualToString:@"0"]) {
        GJJUserInfomationViewController *controller = [[GJJUserInfomationViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"我的资料";
        controller.popViewController = self.popViewController;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        GJJAdultUserInfomationViewController *controller = [[GJJAdultUserInfomationViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.title = @"我的资料";
        controller.popViewController = self.popViewController;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)applyForClick
{
    //talkingdata
    [TalkingData trackEvent:@"立即申请借款按钮"];
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)BarbuttonClick:(UIButton *)button
{
    [self popToCenterController];
}

- (void)popToCenterController
{
    [self.navigationController popToViewController:self.popViewController animated:YES];
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
