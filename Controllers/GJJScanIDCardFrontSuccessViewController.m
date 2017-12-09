//
//  GJJScanIDCardFrontSuccessViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/27.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJScanIDCardFrontSuccessViewController.h"

typedef NS_ENUM(NSInteger, GJJScanIDCardFrontSuccessRequest) {
    GJJScanIDCardFrontSuccessRequestSendIDCardFrontImage,
};

@interface GJJScanIDCardFrontSuccessViewController ()

@end

@implementation GJJScanIDCardFrontSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    UIImageView *idcardFrontImage = [[UIImageView alloc]init];
    idcardFrontImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:idcardFrontImage];
    [idcardFrontImage makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *idcardImageView = [[UIImageView alloc]init];
    idcardImageView.image = _idcardFrontImage;
    [self.view addSubview:idcardImageView];
    [idcardImageView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.88);
        make.width.equalTo(self.view).multipliedBy(0.7);
    }];
    
    UIView *maskingView = [[UIView alloc]init];
    [self.view addSubview:maskingView];
    maskingView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3];
    [maskingView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *infoView = [[UIView alloc]init];
    [maskingView addSubview:infoView];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.layer.cornerRadius = 5;
    infoView.layer.masksToBounds = YES;
    [infoView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(maskingView);
        make.height.equalTo(maskingView).multipliedBy(0.61);
        make.width.equalTo(maskingView).multipliedBy(0.64);
    }];
    
    UIImageView *hintImageView = [[UIImageView alloc]init];
    [infoView addSubview:hintImageView];
    hintImageView.image = [UIImage imageNamed:@"身份认证提示"];
    [hintImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(@(AdaptationHeight(24)));
        make.left.equalTo(infoView).offset(@(AdaptationWidth(50)));
        make.size.equalTo(CGSizeMake(AdaptationWidth(12), AdaptationWidth(12)));
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [infoView addSubview:hintLabel];
    hintLabel.text = @"请核对姓名、性别和身份证号信息，确认无误";
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    hintLabel.textColor = [UIColor colorWithHexString:@"999999"];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintImageView.right).offset(@(AdaptationWidth(3)));
        make.right.equalTo(infoView);
        make.centerY.equalTo(hintImageView);
        make.height.equalTo(@(AdaptationHeight(30)));
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [infoView addSubview:nameLabel];
    nameLabel.text = [NSString stringWithFormat:@"姓       名：%@", _infoDict[@"name"]];
    nameLabel.textColor = CCXColorWithHex(@"666666");
    nameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(16)];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintLabel.bottom).offset(@(AdaptationHeight(17)));
        make.left.equalTo(hintImageView.left);
        make.height.equalTo(@(AdaptationHeight(25)));
        make.width.equalTo(infoView).multipliedBy(0.41);
    }];
    
    UILabel *sexLabel = [[UILabel alloc]init];
    [infoView addSubview:sexLabel];
    sexLabel.text = [NSString stringWithFormat:@"性       别：%@", _infoDict[@"sex"]];
    sexLabel.textColor = CCXColorWithHex(@"666666");
    sexLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(16)];
    sexLabel.adjustsFontSizeToFitWidth = YES;
    [sexLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel);
        make.left.equalTo(nameLabel.right).offset(@(AdaptationWidth(25)));
        make.height.equalTo(nameLabel);
        make.width.equalTo(nameLabel);
    }];
    
    UILabel *idcardLabel = [[UILabel alloc]init];
    [infoView addSubview:idcardLabel];
    idcardLabel.text = [NSString stringWithFormat:@"身份证号：%@", _infoDict[@"num"]];
    idcardLabel.textColor = CCXColorWithHex(@"666666");
    idcardLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(16)];
    idcardLabel.adjustsFontSizeToFitWidth = YES;
    [idcardLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(nameLabel);
        make.height.equalTo(nameLabel);
        make.right.equalTo(infoView).offset(@(AdaptationWidth(-50)));
    }];
    
    UIButton *rescanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoView addSubview:rescanButton];
    [rescanButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    UIColor *rescanButtonColor = CCXMainColor;
    [rescanButton setTitleColor:rescanButtonColor forState:UIControlStateNormal];
    rescanButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    [rescanButton addTarget:self action:@selector(userRescanIDCardFrontClick) forControlEvents:UIControlEventTouchUpInside];
    [rescanButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idcardLabel.bottom).offset(@(AdaptationHeight(35)));
        make.left.equalTo(hintImageView);
        make.height.equalTo(@(AdaptationHeight(45)));
        make.width.equalTo(@(AdaptationWidth(82)));
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoView addSubview:sureButton];
    sureButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    sureButton.layer.cornerRadius = AdaptationHeight(45) / 2.0;
    sureButton.layer.masksToBounds = YES;
    [sureButton setTitle:@"确认，去扫描反面" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    [sureButton addTarget:self action:@selector(userSureIDCardFrontClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rescanButton);
        make.height.equalTo(rescanButton);
        make.left.equalTo(rescanButton.right).offset(@(AdaptationWidth(50)));
        make.right.equalTo(infoView).offset(@(AdaptationWidth(-50)));
    }];
}

- (void)userRescanIDCardFrontClick
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(userRescanIDCardFront)]) {
            [_delegate userRescanIDCardFront];
        }
    }];
}

- (void)userSureIDCardFrontClick
{
    [self prepareDataWithCount:GJJScanIDCardFrontSuccessRequestSendIDCardFrontImage];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJScanIDCardFrontSuccessRequestSendIDCardFrontImage) {
        self.cmd = WQUpLoadPicture;
        NSData *imageData = UIImageJPEGRepresentation(_idcardFrontImage, 1);
        NSString *imgIoString = [[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"picType":@"0",
                      @"userName":_infoDict[@"name"],
                      @"certId":_infoDict[@"num"],
                      @"imgIo":imgIoString
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJScanIDCardFrontSuccessRequestSendIDCardFrontImage) {
        if (_delegate && [_delegate respondsToSelector:@selector(userSureIDCardFront)]) {
            [self dismissViewControllerAnimated:NO completion:nil];
            [_delegate userSureIDCardFront];
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    
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
