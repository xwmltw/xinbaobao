//
//  GJJUserToSignViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/3/30.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJUserToSignViewController.h"
#import "GJJSignContactsModel.h"
#import "GJJSignAContractWebViewController.h"
#import "GJJAdultChangeBingCardViewController.h"
typedef NS_ENUM(NSInteger, GJJUserToSignRequest) {
    GJJUserToSignRequestSignContacts,
};

@interface GJJUserToSignViewController ()

@end

@implementation GJJUserToSignViewController
{
    GJJSignContactsModel *_singContactsModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *advanceLabel = [[UILabel alloc]init];
    [self.view addSubview:advanceLabel];
    advanceLabel.text = @"前进 ！钱近 ！钱进 ！";
    advanceLabel.textAlignment = NSTextAlignmentCenter;
    advanceLabel.textColor = CCXColorWithHex(@"666666");
    advanceLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
    [advanceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@(AdaptationHeight(80)));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(AdaptationHeight(20)));
    }];
    
    UIImageView *signImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"去签约图片"]];
    [self.view addSubview:signImageView];
    [signImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(advanceLabel.bottom).offset(@(AdaptationHeight(20)));
        make.width.height.equalTo(@(AdaptationHeight(150)));
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [self.view addSubview:hintLabel];
    hintLabel.text = [NSString stringWithFormat:@"为了保障您资金的安全，需要\n您认证君子签协议，完成后将尽快为您打款"];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = CCXColorWithHex(@"666666");
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
    hintLabel.numberOfLines = 0;
    hintLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signImageView.bottom).offset(@(AdaptationHeight(25)));
        make.left.right.equalTo(self.view);
    }];
    
    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:signButton];
    signButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [signButton setTitle:@"去签订" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    signButton.layer.cornerRadius = 4;
    signButton.layer.masksToBounds = YES;
    [signButton addTarget:self action:@selector(clickSignButton:) forControlEvents:UIControlEventTouchUpInside];
    [signButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel.bottom).offset(@(AdaptationHeight(30)));
        make.left.equalTo(self.view).offset(@(AdaptationWidth(18)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-18)));
        make.height.equalTo(@(AdaptationHeight(44)));
    }];
}

- (void)clickSignButton:(UIButton *)sender
{
    [self prepareDataWithCount:GJJUserToSignRequestSignContacts];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJUserToSignRequestSignContacts) {
        self.cmd = GJJSignContacts;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"withDrawId": self.withDrawId};
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJUserToSignRequestSignContacts) {
        _singContactsModel = [GJJSignContactsModel yy_modelWithDictionary:dict];
        GJJSignAContractWebViewController *rooVC = [GJJSignAContractWebViewController new];
        rooVC.title = @"签订合同";
        rooVC.url = [NSString stringWithFormat:@"%@&type=3",_singContactsModel.link];
        rooVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rooVC animated:YES];
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    if ([dict[@"detail"][@"status"] integerValue] == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:dict[@"resultNote"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去绑卡" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
                GJJAdultChangeBingCardViewController *controller = [[GJJAdultChangeBingCardViewController alloc]init];
                controller.title = @"银行卡认证";
                controller.hidesBottomBarWhenPushed = YES;
                controller.withDrawId = self.withDrawId;
                [self.navigationController pushViewController:controller animated:YES];
            
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        [super requestFaildWithDictionary:dict];
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
