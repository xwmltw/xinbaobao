//
//  GJJAdultSelfInfomationViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/9.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultSelfInfomationViewController.h"
#import "GJJLinkManDropView.h"
#import "GJJChooseCityView.h"
#import "GJJAdultUserOperatorsCreditViewController.h"
#import "GJJAdultSelfInfoModel.h"
#import "GJJCustomPaddingLabel.h"

typedef NS_ENUM(NSInteger, GJJAdultSelfInfomationRequest) {
    GJJAdultSelfInfomationRequestData,
    GJJAdultSelfInfomationRequestAuthentication,
};

@interface GJJAdultSelfInfomationViewController ()
<GJJChooseCityViewDelegate,
UITextFieldDelegate>

@end

@implementation GJJAdultSelfInfomationViewController
{
    GJJLinkManDropView *_dropMarriageView;
    GJJCustomPaddingLabel *_marriageChooseLabel;
    UIImageView *_marriageChooseImageView;
    UILabel *_familyAddressLabel;
    GJJChooseCityView *_chooseFamilyCityView;
    NSString *_familyProvince;
    NSString *_familyCity;
    NSString *_familyTown;
    UITextField *_familyDetailAddressText;
    GJJChooseCityView *_chooseCompanyCityView;
    NSString *_companyProvince;
    NSString *_companyCity;
    NSString *_companyTown;
    UITextField *_companyNameText;
    UILabel *_companyAddressLabel;
    UITextField *_companyDetailAddressText;
    UITextField *_companyPhoneText;
    UITextField *_companyPayDayText;
    
    GJJAdultSelfInfoModel *_selfInfoModel;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareDataWithCount:GJJAdultSelfInfomationRequestData];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"婚姻状况", @"家庭住址", @"详细住址", @"公司名称", @"公司地址", @"公司地址", @"发 薪 日"] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    
    UIView *marriageView = [[UIView alloc]init];
    [self.view addSubview:marriageView];
    marriageView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    marriageView.layer.cornerRadius = AdaptationWidth(5);
    marriageView.layer.masksToBounds = YES;
    marriageView.layer.borderWidth = 0.5;
    marriageView.layer.borderColor = borderColor.CGColor;
    [marriageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    UILabel *marrigaeLabel = [[UILabel alloc]init];
    [marriageView addSubview:marrigaeLabel];
    marrigaeLabel.text = @"婚姻状况";
    marrigaeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    marrigaeLabel.textColor = CCXColorWithHex(@"888888");
    [marrigaeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(marriageView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(marriageView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _marriageChooseLabel = [[GJJCustomPaddingLabel alloc]init];
    [marriageView addSubview:_marriageChooseLabel];
    _marriageChooseLabel.insetsPadding = UIEdgeInsetsMake(0, 5, 0, 0);
    _marriageChooseLabel.backgroundColor = [UIColor whiteColor];
    _marriageChooseLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _marriageChooseLabel.layer.cornerRadius = AdaptationWidth(5);
    _marriageChooseLabel.layer.masksToBounds = YES;
    _marriageChooseLabel.layer.borderWidth = 0.5;
    _marriageChooseLabel.layer.borderColor = borderColor.CGColor;
    _marriageChooseLabel.textAlignment = NSTextAlignmentLeft;
    if (_selfInfoModel.isMarry.length != 0) {
        _marriageChooseLabel.text = _selfInfoModel.isMarry;
        _marriageChooseLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _marriageChooseLabel.text = @"已婚/未婚";
        _marriageChooseLabel.textColor = placeholderColor;
    }
    _marriageChooseLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseMarriageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseMarriageStatus)];
    [_marriageChooseLabel addGestureRecognizer:chooseMarriageTap];
    [_marriageChooseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(marriageView);
        make.width.equalTo(AdaptationWidth(90));
        make.left.equalTo(marrigaeLabel.right).offset(@(AdaptationWidth(10)));
        make.height.equalTo(marriageView).multipliedBy(5.0/9);
    }];
    
    _marriageChooseImageView = [[UIImageView alloc]init];
    [_marriageChooseLabel addSubview:_marriageChooseImageView];
    _marriageChooseImageView.image = [UIImage imageNamed:@"婚姻状态收起"];
    [_marriageChooseImageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(AdaptationHeight(13), AdaptationHeight(13)));
        make.centerY.equalTo(_marriageChooseLabel);
        make.right.equalTo(_marriageChooseLabel).offset(@(AdaptationWidth(-5)));
    }];
    
    UIView *placeView = [[UIView alloc]init];
    [self.view addSubview:placeView];
    placeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeView.layer.cornerRadius = 5;
    placeView.layer.masksToBounds = YES;
    placeView.layer.borderWidth = 0.5;
    placeView.layer.borderColor = borderColor.CGColor;
    [placeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(marriageView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *placeLabel = [[UILabel alloc]init];
    [placeView addSubview:placeLabel];
    placeLabel.text = @"家庭住址";
    placeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    placeLabel.textColor = CCXColorWithHex(@"888888");
    [placeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeView.left).offset(AdaptationWidth(10));
        make.centerY.equalTo(placeView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _familyAddressLabel = [[UILabel alloc]init];
    [placeView addSubview:_familyAddressLabel];
    _familyAddressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    if (_selfInfoModel.province.length != 0) {
        _familyAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _selfInfoModel.province, _selfInfoModel.city, _selfInfoModel.town];
        _familyAddressLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _familyAddressLabel.text = @"请选择您所在的省市区";
        _familyAddressLabel.textColor = placeholderColor;
    }
    _familyAddressLabel.adjustsFontSizeToFitWidth = YES;
    _familyAddressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseFamilyPlaceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFamilyPlace)];
    [_familyAddressLabel addGestureRecognizer:chooseFamilyPlaceTap];
    [_familyAddressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(placeView);
    }];
    
    UIView *placeDetailView = [[UIView alloc]init];
    [self.view addSubview:placeDetailView];
    placeDetailView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeDetailView.layer.cornerRadius = 5;
    placeDetailView.layer.masksToBounds = YES;
    placeDetailView.layer.borderWidth = 0.5;
    placeDetailView.layer.borderColor = borderColor.CGColor;
    [placeDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *placeDetailLabel = [[UILabel alloc]init];
    [placeDetailView addSubview:placeDetailLabel];
    placeDetailLabel.text = @"家庭住址";
    placeDetailLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    placeDetailLabel.textColor = CCXColorWithHex(@"888888");
    [placeDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeDetailView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(placeDetailView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _familyDetailAddressText = [[UITextField alloc]init];
    [placeDetailView addSubview:_familyDetailAddressText];
    if (_selfInfoModel.bedRoomAddress.length != 0) {
        _familyDetailAddressText.text = _selfInfoModel.bedRoomAddress;
    }
    _familyDetailAddressText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _familyDetailAddressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您详细的家庭地址" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _familyDetailAddressText.textColor = CCXColorWithHex(@"888888");
    _familyDetailAddressText.adjustsFontSizeToFitWidth = YES;
    [_familyDetailAddressText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeDetailLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(placeDetailView);
    }];
    
    UIView *companyNameView = [[UIView alloc]init];
    [self.view addSubview:companyNameView];
    companyNameView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    companyNameView.layer.cornerRadius = 5;
    companyNameView.layer.masksToBounds = YES;
    companyNameView.layer.borderWidth = 0.5;
    companyNameView.layer.borderColor = borderColor.CGColor;
    [companyNameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeDetailView.bottom).offset(@(AdaptationHeight(20)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *companyNameLabel = [[UILabel alloc]init];
    [companyNameView addSubview:companyNameLabel];
    companyNameLabel.text = @"公司名称";
    companyNameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    companyNameLabel.textColor = CCXColorWithHex(@"888888");
    [companyNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyNameView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(companyNameView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _companyNameText = [[UITextField alloc]init];
    [companyNameView addSubview:_companyNameText];
    if (_selfInfoModel.companyName.length != 0) {
        _companyNameText.text = _selfInfoModel.companyName;
    }
    _companyNameText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _companyNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的公司名称" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _companyNameText.textColor = CCXColorWithHex(@"888888");
    _companyNameText.adjustsFontSizeToFitWidth = YES;
    [_companyNameText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyNameLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(companyNameView);
    }];
    
    UIView *companyPlaceView = [[UIView alloc]init];
    [self.view addSubview:companyPlaceView];
    companyPlaceView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    companyPlaceView.layer.cornerRadius = 5;
    companyPlaceView.layer.masksToBounds = YES;
    companyPlaceView.layer.borderWidth = 0.5;
    companyPlaceView.layer.borderColor = borderColor.CGColor;
    [companyPlaceView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyNameView.bottom).offset(@(AdaptationHeight(20)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *companyPlaceLabel = [[UILabel alloc]init];
    [companyPlaceView addSubview:companyPlaceLabel];
    companyPlaceLabel.text = @"公司地址";
    companyPlaceLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    companyPlaceLabel.textColor = CCXColorWithHex(@"888888");
    [companyPlaceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyPlaceView.left).offset(AdaptationWidth(10));
        make.centerY.equalTo(companyPlaceView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _companyAddressLabel = [[UILabel alloc]init];
    [companyPlaceView addSubview:_companyAddressLabel];
    _companyAddressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    if (_selfInfoModel.commProvince.length != 0) {
        _companyAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _selfInfoModel.commProvince, _selfInfoModel.commCity, _selfInfoModel.commTown];
        _companyAddressLabel.textColor = CCXColorWithHex(@"888888");
    }else {
        _companyAddressLabel.text = @"请选择您公司所在的省市区";
        _companyAddressLabel.textColor = placeholderColor;
    }
    _companyAddressLabel.adjustsFontSizeToFitWidth = YES;
    _companyAddressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *chooseCompanyPlacetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCompanyPlace)];
    [_companyAddressLabel addGestureRecognizer:chooseCompanyPlacetap];
    [_companyAddressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyPlaceLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(companyPlaceView);
    }];
    
    UIView *companyPlaceDetailView = [[UIView alloc]init];
    [self.view addSubview:companyPlaceDetailView];
    companyPlaceDetailView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    companyPlaceDetailView.layer.cornerRadius = 5;
    companyPlaceDetailView.layer.masksToBounds = YES;
    companyPlaceDetailView.layer.borderWidth = 0.5;
    companyPlaceDetailView.layer.borderColor = borderColor.CGColor;
    [companyPlaceDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyPlaceView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *companyPlaceDetailLabel = [[UILabel alloc]init];
    [companyPlaceDetailView addSubview:companyPlaceDetailLabel];
    companyPlaceDetailLabel.text = @"公司地址";
    companyPlaceDetailLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    companyPlaceDetailLabel.textColor = CCXColorWithHex(@"888888");
    [companyPlaceDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyPlaceDetailView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(companyPlaceDetailView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _companyDetailAddressText = [[UITextField alloc]init];
    [companyPlaceDetailView addSubview:_companyDetailAddressText];
    if (_selfInfoModel.companyAddress.length != 0) {
        _companyDetailAddressText.text = _selfInfoModel.companyAddress;
    }
    _companyDetailAddressText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _companyDetailAddressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您公司的详细地址" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _companyDetailAddressText.textColor = CCXColorWithHex(@"888888");
    _companyDetailAddressText.adjustsFontSizeToFitWidth = YES;
    [_companyDetailAddressText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeDetailLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(companyPlaceDetailView);
    }];
    
    UIView *companyPhoneView = [[UIView alloc]init];
    [self.view addSubview:companyPhoneView];
    companyPhoneView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    companyPhoneView.layer.cornerRadius = 5;
    companyPhoneView.layer.masksToBounds = YES;
    companyPhoneView.layer.borderWidth = 0.5;
    companyPhoneView.layer.borderColor = borderColor.CGColor;
    [companyPhoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyPlaceDetailView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(marriageView.height);
    }];
    
    UILabel *companyPhoneLabel = [[UILabel alloc]init];
    [companyPhoneView addSubview:companyPhoneLabel];
    companyPhoneLabel.text = @"公司电话";
    companyPhoneLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    companyPhoneLabel.textColor = CCXColorWithHex(@"888888");
    companyPhoneLabel.textAlignment = NSTextAlignmentCenter;
    [companyPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyPhoneView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(companyPhoneView.centerY);
        make.width.equalTo(maxLabelWidth);
    }];
    
    UILabel *companyPhoneHintLabel = [[UILabel alloc]init];
    [companyPhoneView addSubview:companyPhoneHintLabel];
    companyPhoneHintLabel.text = @"";
    companyPhoneHintLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    companyPhoneHintLabel.textColor = CCXColorWithHex(@"888888");
    [companyPhoneHintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(companyPhoneView).offset(@(AdaptationWidth(-15)));
        make.centerY.equalTo(companyPhoneView.centerY);
        make.width.equalTo(@(AdaptationWidth(30)));
    }];
    
    _companyPhoneText = [[UITextField alloc]init];
    [companyPhoneView addSubview:_companyPhoneText];
    _companyPhoneText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    if (_selfInfoModel.companyPhone.length > 0) {
        _companyPhoneText.text = _selfInfoModel.companyPhone;
    }
    _companyPhoneText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _companyPhoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"区号+电话号码+（分机号）" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _companyPhoneText.textColor = CCXColorWithHex(@"888888");
    _companyPhoneText.adjustsFontSizeToFitWidth = YES;
    [_companyPhoneText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyPhoneLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(companyPhoneView);
//        make.right.equalTo(companyPhoneHintLabel.left);
    }];
    
    UILabel *payDaylabel = [[UILabel alloc]init];
    [self.view addSubview:payDaylabel];
    payDaylabel.backgroundColor = CCXColorWithHex(@"f7f7f8");
    payDaylabel.layer.cornerRadius = 5;
    payDaylabel.layer.masksToBounds = YES;
    payDaylabel.layer.borderWidth = 0.5;
    payDaylabel.layer.borderColor = borderColor.CGColor;
    payDaylabel.text = @"发 薪 日";
    payDaylabel.textColor = CCXColorWithHex(@"888888");
    payDaylabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    payDaylabel.textAlignment = NSTextAlignmentCenter;
    [payDaylabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(companyPhoneView.bottom).equalTo(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.height.equalTo(marriageView.height);
        make.width.equalTo(maxLabelWidth + AdaptationWidth(30));
    }];
    
    _companyPayDayText = [[UITextField alloc]init];
    [self.view addSubview:_companyPayDayText];
    if (_selfInfoModel.comPayDay.length != 0) {
        _companyPayDayText.text = _selfInfoModel.comPayDay;
    }
    _companyPayDayText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _companyPayDayText.backgroundColor = CCXColorWithHex(@"f7f7f8");
    _companyPayDayText.layer.cornerRadius = 5;
    _companyPayDayText.layer.masksToBounds = YES;
    _companyPayDayText.layer.borderWidth = 0.5;
    _companyPayDayText.layer.borderColor = borderColor.CGColor;
    _companyPayDayText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"1-31" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _companyPayDayText.keyboardType = UIKeyboardTypeNumberPad;
    _companyPayDayText.textColor = CCXColorWithHex(@"888888");
    _companyPayDayText.textAlignment = NSTextAlignmentCenter;
    _companyPayDayText.delegate = self;
    [_companyPayDayText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payDaylabel.right).offset(@(AdaptationWidth(10)));
        make.height.top.equalTo(payDaylabel);
        make.width.equalTo(@(AdaptationWidth(60)));
    }];
    
    UILabel *dayLabel = [[UILabel alloc]init];
    [self.view addSubview:dayLabel];
    dayLabel.backgroundColor = CCXColorWithHex(@"f7f7f8");
    dayLabel.layer.cornerRadius = 5;
    dayLabel.layer.masksToBounds = YES;
    dayLabel.layer.borderWidth = 0.5;
    dayLabel.layer.borderColor = borderColor.CGColor;
    dayLabel.text = @"日";
    dayLabel.textColor = CCXColorWithHex(@"888888");
    dayLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [dayLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.top.equalTo(payDaylabel);
        make.width.equalTo(@(AdaptationWidth(32)));
    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    certificationButton.layer.masksToBounds = YES;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payDaylabel.bottom).offset(@(AdaptationHeight(50)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/13);
    }];
    
//    if (_schedule != 8) {
//        _scheduleProgressView = [[UIProgressView alloc]init];
//        [self.view addSubview:_scheduleProgressView];
//        _scheduleProgressView.progressImage = [GJJAppUtils imageWithColor:[UIColor colorWithHexString:GJJMainColorString] cornerRadius:AdaptationHeight(5)];
//        _scheduleProgressView.trackTintColor = [UIColor colorWithHexString:@"999897"];
//        [_scheduleProgressView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.height.equalTo(10);
//        }];
//        
//        _scheduleProgressLabel = [[UILabel alloc]init];
//        [self.view addSubview:_scheduleProgressLabel];
//        _scheduleProgressLabel.textColor = [UIColor colorWithHexString:@"414044"];
//        _scheduleProgressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
//        _scheduleProgressLabel.textAlignment = NSTextAlignmentCenter;
//        [_scheduleProgressLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.view);
//            make.height.equalTo(@(AdaptationHeight(20)));
//            make.bottom.equalTo(_scheduleProgressView.top).offset(@(-6));
//        }];
//        
//        _scheduleProgressView.progress = 0.75;
//        _scheduleProgressLabel.text = @"75%";
//    }
}

#pragma makr - UITapGestureRecognizer
- (void)chooseMarriageStatus
{
    if (_dropMarriageView) {
        [_dropMarriageView removeFromSuperview];
        _dropMarriageView = nil;
        _marriageChooseImageView.image = [UIImage imageNamed:@"婚姻状态收起"];
    }else {
        _dropMarriageView = [[GJJLinkManDropView alloc]init];
        [self.view addSubview:_dropMarriageView];
        _dropMarriageView.isNeedSeparator = YES;
        _dropMarriageView.cornerRadius = AdaptationWidth(3);
        _dropMarriageView.bankArray = [NSMutableArray arrayWithArray:@[@"已婚", @"未婚", @"其他"]];
        [_dropMarriageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_marriageChooseLabel.bottom).offset(@(AdaptationHeight(2)));
            make.height.equalTo(@(44*3));
            make.left.equalTo(_marriageChooseLabel.left);
            make.right.equalTo(_marriageChooseLabel.right);
        }];
        
        _marriageChooseImageView.image = [UIImage imageNamed:@"婚姻状态展开"];
        
        __weak typeof (self)weak = self;
        _dropMarriageView.returnBank = ^(NSString *chooseThing) {
            __strong typeof(weak) weakself = weak;
            _dropMarriageView = nil;
            weakself->_marriageChooseLabel.text = chooseThing;
            weakself->_marriageChooseLabel.textColor = CCXColorWithHex(@"888888");
            weakself->_marriageChooseImageView.image = [UIImage imageNamed:@"婚姻状态收起"];
        };
    }
}

- (void)chooseFamilyPlace
{
    _chooseFamilyCityView = [[GJJChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseFamilyCityView.delegate = self;
    [_chooseFamilyCityView showView];
}

- (void)chooseCompanyPlace
{
    _chooseCompanyCityView = [[GJJChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseCompanyCityView.delegate = self;
    [_chooseCompanyCityView showView];
}

#pragma mark - GJJChooseCityViewDelegate
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(GJJChooseCityView *)chooseView
{
    if (chooseView == _chooseFamilyCityView) {
        _familyProvince = province;
        _familyCity = city;
        _familyTown = town;
        
        _familyAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _familyProvince, _familyCity, _familyTown];
        _familyAddressLabel.textColor = CCXColorWithHex(@"888888");
        _familyAddressLabel.adjustsFontSizeToFitWidth = YES;
    }else if (chooseView == _chooseCompanyCityView) {
        _companyProvince = province;
        _companyCity = city;
        _companyTown = town;
        
        _companyAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", _companyProvince, _companyCity, _companyTown];
        _companyAddressLabel.textColor = CCXColorWithHex(@"888888");
        _companyAddressLabel.adjustsFontSizeToFitWidth = YES;
    }
}

#pragma mark - button click

//- (void)chooseMarriageStatesClick:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (_dropMarriageView) {
//        [_dropMarriageView removeFromSuperview];
//        _dropMarriageView = nil;
//    }else {
//        _dropMarriageView = [[GJJLinkManDropView alloc]init];
//        [self.view addSubview:_dropMarriageView];
//        _dropMarriageView.isNeedSeparator = YES;
//        _dropMarriageView.cornerRadius = AdaptationWidth(3);
//        _dropMarriageView.bankArray = [NSMutableArray arrayWithArray:@[@"已婚", @"未婚", @"其他"]];
//        [_dropMarriageView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(sender.bottom).offset(@(AdaptationHeight(2)));
//            make.height.equalTo(@(44*3));
//            make.left.equalTo(sender.left);
//            make.right.equalTo(sender.right);
//        }];
//        
//        _dropMarriageView.returnBank = ^(NSString *chooseThing) {
//            _dropMarriageView = nil;
//            [sender setTitle:chooseThing forState:UIControlStateNormal];
//            [sender setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
//        };
//    }
//}

- (void)certificationClick:(UIButton *)sender
{
    if ([_marriageChooseLabel.text isEqualToString:@"已婚/未婚"]) {
        [self setHudWithName:@"请选择婚姻状况" Time:1 andType:1];
        return;
    }
    
    if ([_familyAddressLabel.text isEqualToString:@"请选择您所在的省市区"]) {
        [self setHudWithName:@"请选择您所在的省市区" Time:1 andType:1];
        return;
    }
    
    if (_familyDetailAddressText.text.length == 0) {
        [self setHudWithName:@"请输入您详细的家庭地址" Time:1 andType:1];
        return;
    }
    
    if (_companyNameText.text.length == 0) {
        [self setHudWithName:@"请输入您的公司名称" Time:1 andType:1];
        return;
    }
    
    if ([_companyAddressLabel.text isEqualToString:@"请选择您公司所在的省市区"]) {
        [self setHudWithName:@"请选择您公司所在的省市区" Time:1 andType:1];
        return;
    }
    
    if (_companyDetailAddressText.text.length == 0) {
        [self setHudWithName:@"请输入您公司的详细地址" Time:1 andType:1];
        return;
    }
    
    if (_companyPhoneText.text.length == 0) {
        [self setHudWithName:@"请输入您公司的电话号码" Time:1 andType:1];
        return;
    }
    
    if (_companyPayDayText.text.length == 0) {
        [self setHudWithName:@"请输入您的发薪日" Time:1 andType:1];
        return;
    }
    
    if ([_companyPayDayText.text integerValue] > 31 || [_companyPayDayText.text integerValue] < 1) {
        [self setHudWithName:@"发薪日为1~31号" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJAdultSelfInfomationRequestAuthentication];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultSelfInfomationRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"2"};
    }else if (self.requestCount == GJJAdultSelfInfomationRequestAuthentication) {
        self.cmd = GJJAuthenticationFamily;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"isMarry":_marriageChooseLabel.text,
                      @"province":_familyProvince,
                      @"city":_familyCity,
                      @"town":_familyTown,
                      @"bedRoomAddress":_familyDetailAddressText.text,
                      @"companyName":_companyNameText.text,
                      @"companyProvince":_companyProvince,
                      @"companyCity":_companyCity,
                      @"companyTown":_companyTown,
                      @"companyAddress":_companyDetailAddressText.text,
                      @"companyPhone":_companyPhoneText.text,
                      @"comPayDay":_companyPayDayText.text
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultSelfInfomationRequestData) {
        _selfInfoModel = [GJJAdultSelfInfoModel yy_modelWithDictionary:dict];
        _familyProvince = _selfInfoModel.province;
        _familyCity = _selfInfoModel.city;
        _familyTown = _selfInfoModel.town;
        _companyProvince = _selfInfoModel.commProvince;
        _companyCity = _selfInfoModel.commCity;
        _companyTown = _selfInfoModel.commTown;
        [self setupView];
    }else if (self.requestCount == GJJAdultSelfInfomationRequestAuthentication) {
        if (_schedule == 8) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            GJJAdultUserOperatorsCreditViewController *controller = [[GJJAdultUserOperatorsCreditViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"运营商认证";
            controller.popViewController = self.popViewController;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultSelfInfomationRequestData) {
        [self setupView];
    }
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
