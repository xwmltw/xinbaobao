//
//  GJJAdultUserLinkManViewController.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/9.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJAdultUserLinkManViewController.h"
#import "GJJChoosePickerView.h"
#import "GJJChooseCityView.h"
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBook/AddressBook.h>
#import "GJJAdultSelfInfomationViewController.h"
#import "GJJLinkManDropView.h"
#import "GJJContactModel.h"

typedef NS_ENUM(NSInteger, GJJAdultUserLinkManRequest) {
    GJJAdultUserLinkManRequestData,
    GJJAdultUserLinkManRequestSaveLinkMan,
};

@interface GJJAdultUserLinkManViewController ()
<GJJChoosePickerViewDelegate,
GJJChooseCityViewDelegate,
CNContactPickerDelegate,
ABPeoplePickerNavigationControllerDelegate>

//获取到的数据
@property (nonatomic, strong) NSMutableArray *contactArray;

//从通讯录拿到的数据
@property (nonatomic, strong) NSMutableArray *allContactArray;

@end

@implementation GJJAdultUserLinkManViewController
{
    UITextField *_parentNameText;
    UILabel *_parentPhoneLabel;
    UILabel *_parentAddressLabel;
    UITextField *_familyAddressText;
    UITextField *_friendNameText;
    UILabel *_friendPhoneLabel;
    UILabel *_parentRelationshipLabel;
    UIImageView *_parentRelationshipImageView;
    UILabel *_friendRelationshipLabel;
    UIImageView *_friendRelationshipImageView;
    GJJChooseCityView *_chooseCityView;
    NSString *_province;
    NSString *_city;
    NSString *_town;
    NSString *_parentNamePlaceHolder;
    NSString *_parentPhonePlaceHolder;
    NSString *_parentAddressPlaceHolder;
    NSString *_parentDetailAddressPlaceHolder;
    NSString *_friendNamePlaceHolder;
    NSString *_friendPhonePlaceHolder;
    GJJChoosePickerView *_chooseFriendRelationshipPicker;
    GJJLinkManDropView *_dropRelationshipView;
    
    NSString *_parentPhoneStr;
    NSString *_parentAddressStr;
    NSString *_parentDetailAddressStr;
    NSString *_friendPhoneStr;
    
    //判断是否是选择直系亲属的
    BOOL _needToChangeName;
    NSString *_whichPhone;
    
    UILabel *_scheduleProgressLabel;
    UIProgressView *_scheduleProgressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self prepareDataWithCount:GJJAdultUserLinkManRequestData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getAllContactsAuthorization];
}

- (void)setupData
{
    _needToChangeName = NO;
    _contactArray = [NSMutableArray arrayWithCapacity:0];
    _allContactArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupView
{
    GJJContactModel *father;
    GJJContactModel *roommate;
    if (_contactArray.count) {
        father = _contactArray[0];
        roommate = _contactArray[1];
    }
    
    UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
    UIColor *borderColor = CCXColorWithHex(@"e7e7e7");
    
    UIView *parentNameView = [[UIView alloc]init];
    [self.view addSubview:parentNameView];
    parentNameView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    parentNameView.layer.cornerRadius = AdaptationWidth(5);
    parentNameView.layer.masksToBounds = YES;
    parentNameView.layer.borderWidth = 0.5;
    parentNameView.layer.borderColor = borderColor.CGColor;
    [parentNameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(@(AdaptationHeight(22)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.width.equalTo(@(AdaptationWidth(200)));
        make.height.equalTo(self.view.height).multipliedBy(1.0/14);
    }];
    
    CGFloat parentNameLabelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont boldSystemFontOfSize:AdaptationWidth(14)] givenText:@"姓名" givenHeight:20]);
    
    UILabel *parentNameLabel = [[UILabel alloc]init];
    [parentNameView addSubview:parentNameLabel];
    parentNameLabel.text = @"姓名";
    parentNameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    parentNameLabel.textColor = CCXColorWithHex(@"888888");
    [parentNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentNameView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(parentNameView.centerY);
        make.width.equalTo(parentNameLabelWidth);
    }];
    
    UIButton *chooseParentNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [parentNameView addSubview:chooseParentNameButton];
    [chooseParentNameButton setImage:[UIImage imageNamed:@"联系人选择"] forState:UIControlStateNormal];
    [chooseParentNameButton addTarget:self action:@selector(chooseParentNameAndPhone) forControlEvents:UIControlEventTouchUpInside];
    [chooseParentNameButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(parentNameView);
        make.right.equalTo(parentNameView).offset(@(AdaptationWidth(-10)));
        make.width.equalTo(@(AdaptationWidth(20)));
        make.height.equalTo(parentNameView.height);
    }];
    
    _parentNamePlaceHolder = @"请选择您配偶的姓名";
    _parentNameText = [[UITextField alloc]init];
    [parentNameView addSubview:_parentNameText];
    if (father.contactName.length != 0) {
        _parentNameText.text = father.contactName;
    }
    _parentNameText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _parentNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请选择其姓名" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _parentNameText.textColor = CCXColorWithHex(@"888888");
    _parentNameText.adjustsFontSizeToFitWidth = YES;
    [_parentNameText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentNameLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.centerY.equalTo(parentNameView);
        make.right.equalTo(chooseParentNameButton.left).offset(@(AdaptationWidth(-5)));
    }];
    
    UIView *parentRelationshipView = [[UIView alloc]init];
    [self.view addSubview:parentRelationshipView];
    parentRelationshipView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    parentRelationshipView.layer.cornerRadius = AdaptationWidth(5);
    parentRelationshipView.layer.masksToBounds = YES;
    parentRelationshipView.layer.borderWidth = 0.5;
    parentRelationshipView.layer.borderColor = borderColor.CGColor;
    UITapGestureRecognizer *chooseParentRelationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseParentRelation)];
    [parentRelationshipView addGestureRecognizer:chooseParentRelationTap];
    [parentRelationshipView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentNameView);
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-20)));
        make.width.equalTo(@(AdaptationWidth(132)));
        make.height.equalTo(parentNameView);
    }];
    
    CGFloat parentRelationLabelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont systemFontOfSize:AdaptationWidth(14)] givenText:@"关 系:" givenHeight:20]);
    
    UILabel *parentRelationLabel = [[UILabel alloc]init];
    [parentRelationshipView addSubview:parentRelationLabel];
    parentRelationLabel.text = @"关 系:";
    parentRelationLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    parentRelationLabel.textColor = CCXColorWithHex(@"888888");
    parentRelationLabel.adjustsFontSizeToFitWidth = YES;
    [parentRelationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentRelationshipView).offset(@(AdaptationWidth(5)));
        make.centerY.equalTo(parentRelationshipView);
        make.width.equalTo(parentRelationLabelWidth);
    }];
    
    _parentRelationshipImageView = [[UIImageView alloc]init];
    [parentRelationshipView addSubview:_parentRelationshipImageView];
    _parentRelationshipImageView.image = [UIImage imageNamed:@"联系人收起"];
    [_parentRelationshipImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(parentRelationshipView).offset(@(AdaptationWidth(-3)));
        make.centerY.equalTo(parentRelationshipView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(13), AdaptationWidth(13)));
    }];
    
    _parentRelationshipLabel = [[UILabel alloc]init];
    [parentRelationshipView addSubview:_parentRelationshipLabel];
    if (father.relationship.length != 0) {
        _parentRelationshipLabel.text = father.relationship;
    }else {
        _parentRelationshipLabel.text = @"配偶";
    }
    _parentRelationshipLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _parentRelationshipLabel.textColor = CCXColorWithHex(@"888888");
    [_parentRelationshipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentRelationLabel.right).offset(@(AdaptationWidth(5)));
        make.centerY.equalTo(parentRelationshipView);
        make.right.equalTo(_parentRelationshipImageView.left);
    }];
    
    UIView *parentPhoneView = [[UIView alloc]init];
    [self.view addSubview:parentPhoneView];
    parentPhoneView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    parentPhoneView.layer.cornerRadius = AdaptationWidth(5);
    parentPhoneView.layer.masksToBounds = YES;
    parentPhoneView.layer.borderWidth = 0.5;
    parentPhoneView.layer.borderColor = borderColor.CGColor;
    UITapGestureRecognizer *chooseParentPhoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseParentPhone)];
    [parentPhoneView addGestureRecognizer:chooseParentPhoneTap];
    [parentPhoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentNameView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(parentNameView);
    }];
    
    CGFloat parentPhoneLabelWidth = ceil([GJJAppUtils calculateTextWidth:[UIFont boldSystemFontOfSize:AdaptationWidth(14)] givenText:@"电话号码" givenHeight:20]);
    
    UILabel *parentPhoneLabel = [[UILabel alloc]init];
    [parentPhoneView addSubview:parentPhoneLabel];
    parentPhoneLabel.text = @"电话号码";
    parentPhoneLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    parentPhoneLabel.textColor = CCXColorWithHex(@"888888");
    [parentPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentPhoneView.left).offset(AdaptationWidth(10));
        make.centerY.equalTo(parentPhoneView.centerY);
        make.width.equalTo(parentPhoneLabelWidth);
    }];
    
    UIImageView *chooseParentPhoneImageView = [[UIImageView alloc]init];
    [parentPhoneView addSubview:chooseParentPhoneImageView];
    chooseParentPhoneImageView.image = [UIImage imageNamed:@"联系人选择"];
    [chooseParentPhoneImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(parentPhoneView).offset(AdaptationWidth(-10));
        make.centerY.equalTo(parentPhoneView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(13), AdaptationWidth(13)));
    }];
    
    if (father.relationship.length != 0) {
        _parentPhonePlaceHolder = [NSString stringWithFormat:@"请选择您%@的电话号码", father.relationship];
    }else {
        _parentPhonePlaceHolder = @"请选择您配偶的电话号码";
    }
    
    _parentPhoneLabel = [[UILabel alloc]init];
    [parentPhoneView addSubview:_parentPhoneLabel];
    if (father.contactPhone.length != 0) {
        _parentPhoneLabel.text = father.contactPhone;
        _parentPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _parentPhoneStr = father.contactPhone;
    }else {
        _parentPhoneLabel.text = _parentPhonePlaceHolder;
        _parentPhoneLabel.textColor = placeholderColor;
    }
    _parentPhoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _parentPhoneLabel.adjustsFontSizeToFitWidth = YES;
    [_parentPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parentPhoneLabel.right).offset(@(AdaptationWidth(10)));
        make.right.equalTo(chooseParentPhoneImageView.left).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(parentPhoneView);
    }];
    
    UIView *placeView = [[UIView alloc]init];
    [self.view addSubview:placeView];
    placeView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeView.layer.cornerRadius = 5;
    placeView.layer.masksToBounds = YES;
    [placeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentPhoneView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(parentNameView.height);
    }];
    
    UILabel *placeLabel = [[UILabel alloc]init];
    [placeView addSubview:placeLabel];
    placeLabel.text = @"家庭住址";
    placeLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    placeLabel.textColor = CCXColorWithHex(@"888888");
    [placeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeView.left).offset(AdaptationWidth(10));
        make.centerY.equalTo(placeView.centerY);
        make.width.equalTo(parentPhoneLabelWidth);
    }];
    
    if (father.relationship.length != 0) {
        _parentAddressPlaceHolder = [NSString stringWithFormat:@"请选择您%@所在的省市区", father.relationship];
    }else {
        _parentAddressPlaceHolder = @"请选择您配偶所在的省市区";
    }
    
    _parentAddressLabel = [[UILabel alloc]init];
    [placeView addSubview:_parentAddressLabel];
    _parentAddressLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    if (father.familyAdress.length != 0) {
        _parentAddressLabel.text = father.familyAdress;
        _parentAddressLabel.textColor = CCXColorWithHex(@"888888");
        _parentAddressStr = father.familyAdress;
    }else {
        _parentAddressLabel.text = _parentAddressPlaceHolder;
        _parentAddressLabel.textColor = placeholderColor;
    }
    _parentAddressLabel.adjustsFontSizeToFitWidth = YES;
    _parentAddressLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFamilyPlace)];
    [_parentAddressLabel addGestureRecognizer:tap];
    [_parentAddressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeLabel.right).offset(@(AdaptationWidth(10)));
        make.top.right.bottom.equalTo(placeView);
    }];
    
    UIView *placeDetailView = [[UIView alloc]init];
    [self.view addSubview:placeDetailView];
    placeDetailView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    placeDetailView.layer.cornerRadius = 5;
    placeDetailView.layer.masksToBounds = YES;
    [placeDetailView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationHeight(20)));
        make.right.equalTo(self.view.right).offset(@(AdaptationHeight(-20)));
        make.height.equalTo(parentNameView.height);
    }];
    
    UILabel *placeDetailLabel = [[UILabel alloc]init];
    [placeDetailView addSubview:placeDetailLabel];
    placeDetailLabel.text = @"详细住址";
    placeDetailLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    placeDetailLabel.textColor = CCXColorWithHex(@"888888");
    [placeDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeDetailView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(placeDetailView.centerY);
        make.width.equalTo(parentPhoneLabelWidth);
    }];
    
    if (father.relationship.length != 0) {
        _parentDetailAddressPlaceHolder = [NSString stringWithFormat:@"请选择您%@所在的具体家庭住址", father.relationship];
    }else {
        _parentDetailAddressPlaceHolder = @"请输入您配偶的具体家庭住址";
    }
    
    _familyAddressText = [[UITextField alloc]init];
    [placeDetailView addSubview:_familyAddressText];
    _familyAddressText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    if (father.contactAdress.length != 0) {
        _familyAddressText.text = father.contactAdress;
        _parentDetailAddressStr = father.contactAdress;
    }
    _familyAddressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_parentDetailAddressPlaceHolder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _familyAddressText.textColor = CCXColorWithHex(@"888888");
    _familyAddressText.adjustsFontSizeToFitWidth = YES;
    [_familyAddressText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(placeDetailLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.right.equalTo(placeDetailView);
    }];
    
    UIView *friendNameView = [[UIView alloc]init];
    [self.view addSubview:friendNameView];
    friendNameView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    friendNameView.layer.cornerRadius = AdaptationWidth(5);
    friendNameView.layer.masksToBounds = YES;
    friendNameView.layer.borderWidth = 0.5;
    friendNameView.layer.borderColor = borderColor.CGColor;
    [friendNameView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeDetailView.bottom).offset(@(AdaptationHeight(20)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.width.equalTo(parentNameView);
        make.height.equalTo(parentNameView);
    }];
    
    UILabel *friendNameLabel = [[UILabel alloc]init];
    [friendNameView addSubview:friendNameLabel];
    friendNameLabel.text = @"姓名";
    friendNameLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    friendNameLabel.textColor = CCXColorWithHex(@"888888");
    [friendNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendNameView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(friendNameView.centerY);
        make.width.equalTo(parentNameLabelWidth);
    }];
    
    UIButton *choosefriendNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendNameView addSubview:choosefriendNameButton];
    [choosefriendNameButton setImage:[UIImage imageNamed:@"联系人选择"] forState:UIControlStateNormal];
    [choosefriendNameButton addTarget:self action:@selector(chooseFriendNameAndPhone) forControlEvents:UIControlEventTouchUpInside];
    [choosefriendNameButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(friendNameView);
        make.right.equalTo(friendNameView).offset(@(AdaptationWidth(-10)));
        make.width.equalTo(@(AdaptationWidth(20)));
        make.height.equalTo(parentNameView.height);
    }];
    
    _friendNamePlaceHolder = @"请选择其姓名";
    
    _friendNameText = [[UITextField alloc]init];
    [friendNameView addSubview:_friendNameText];
    if (roommate.contactName.length != 0) {
        _friendNameText.text = roommate.contactName;
    }
    _friendNameText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _friendNameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_friendNamePlaceHolder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    _friendNameText.textColor = CCXColorWithHex(@"888888");
    _friendNameText.adjustsFontSizeToFitWidth = YES;
    [_friendNameText makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendNameLabel.right).offset(@(AdaptationWidth(10)));
        make.top.bottom.centerY.equalTo(friendNameView);
        make.right.equalTo(choosefriendNameButton.left).offset(@(AdaptationWidth(-10)));
    }];
    
    UIView *friendRelationshipView = [[UIView alloc]init];
    [self.view addSubview:friendRelationshipView];
    friendRelationshipView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    friendRelationshipView.layer.cornerRadius = AdaptationWidth(5);
    friendRelationshipView.layer.masksToBounds = YES;
    friendRelationshipView.layer.borderWidth = 0.5;
    friendRelationshipView.layer.borderColor = borderColor.CGColor;
    UITapGestureRecognizer *chooseRelationTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFriendRelation)];
    [friendRelationshipView addGestureRecognizer:chooseRelationTap];
    [friendRelationshipView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(friendNameView);
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-20)));
        make.width.equalTo(parentRelationshipView);
        make.height.equalTo(parentNameView);
    }];
    
    UILabel *friendRelationLabel = [[UILabel alloc]init];
    [friendRelationshipView addSubview:friendRelationLabel];
    friendRelationLabel.text = @"关 系:";
    friendRelationLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    friendRelationLabel.textColor = CCXColorWithHex(@"888888");
    friendRelationLabel.adjustsFontSizeToFitWidth = YES;
    [friendRelationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendRelationshipView).offset(@(AdaptationWidth(5)));
        make.centerY.equalTo(friendRelationshipView);
        make.width.equalTo(parentRelationLabelWidth);
    }];
    
    _friendRelationshipImageView = [[UIImageView alloc]init];
    [friendRelationshipView addSubview:_friendRelationshipImageView];
    _friendRelationshipImageView.image = [UIImage imageNamed:@"联系人收起"];
    [_friendRelationshipImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(friendRelationshipView).offset(@(AdaptationWidth(-3)));
        make.centerY.equalTo(friendRelationshipView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(13), AdaptationWidth(13)));
    }];
    
    _friendRelationshipLabel = [[UILabel alloc]init];
    [friendRelationshipView addSubview:_friendRelationshipLabel];
    if (roommate.relationship.length != 0) {
        _friendRelationshipLabel.text = roommate.relationship;
    }else {
        _friendRelationshipLabel.text = @"朋友";
    }
    _friendRelationshipLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _friendRelationshipLabel.textColor = CCXColorWithHex(@"888888");
    _friendRelationshipLabel.adjustsFontSizeToFitWidth = YES;
    [_friendRelationshipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendRelationLabel.right).offset(@(AdaptationWidth(5)));
        make.centerY.equalTo(friendRelationshipView);
        make.right.equalTo(_friendRelationshipImageView.left).offset(@(AdaptationWidth(-5)));
    }];
    
    UIView *friendPhoneView = [[UIView alloc]init];
    [self.view addSubview:friendPhoneView];
    friendPhoneView.backgroundColor = CCXColorWithHex(@"f7f7f8");
    friendPhoneView.layer.cornerRadius = AdaptationWidth(5);
    friendPhoneView.layer.masksToBounds = YES;
    friendPhoneView.layer.borderWidth = 0.5;
    friendPhoneView.layer.borderColor = borderColor.CGColor;
    UITapGestureRecognizer *chooseFriendPhoneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFriendPhone)];
    [friendPhoneView addGestureRecognizer:chooseFriendPhoneTap];
    [friendPhoneView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(friendRelationshipView.bottom).offset(@(AdaptationHeight(10)));
        make.left.equalTo(self.view.left).offset(@(AdaptationWidth(20)));
        make.right.equalTo(self.view).offset(@(AdaptationWidth(-20)));
        make.height.equalTo(parentNameView);
    }];
    
    UILabel *friendPhoneLabel = [[UILabel alloc]init];
    [friendPhoneView addSubview:friendPhoneLabel];
    friendPhoneLabel.text = @"电话号码";
    friendPhoneLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    friendPhoneLabel.textColor = CCXColorWithHex(@"888888");
    [friendPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendPhoneView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(friendPhoneView.centerY);
        make.width.equalTo(parentPhoneLabelWidth);
    }];
    
    UIImageView *chooseFriendPhoneImageView = [[UIImageView alloc]init];
    [friendPhoneView addSubview:chooseFriendPhoneImageView];
    chooseFriendPhoneImageView.image = [UIImage imageNamed:@"联系人选择"];
    [chooseFriendPhoneImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(friendPhoneView).offset(AdaptationWidth(-10));
        make.centerY.equalTo(friendPhoneView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(13), AdaptationWidth(13)));
    }];
    
    if (roommate.relationship.length != 0) {
        _friendPhonePlaceHolder = [NSString stringWithFormat:@"请选择您%@的电话号码", roommate.relationship];
    }else {
        _friendPhonePlaceHolder = @"请选择您朋友的电话号码";
    }
    
    _friendPhoneLabel = [[UILabel alloc]init];
    [friendPhoneView addSubview:_friendPhoneLabel];
    if (roommate.contactPhone.length != 0) {
        _friendPhoneLabel.text = roommate.contactPhone;
        _friendPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _friendPhoneStr = roommate.contactPhone;
    }else {
        _friendPhoneLabel.text = _friendPhonePlaceHolder;
        _friendPhoneLabel.textColor = placeholderColor;
    }
    _friendPhoneLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    _friendPhoneLabel.adjustsFontSizeToFitWidth = YES;
    [_friendPhoneLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(friendPhoneLabel.right).offset(@(AdaptationWidth(10)));
        make.right.equalTo(chooseFriendPhoneImageView.left).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(friendPhoneView);
    }];
    
    UIButton *certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:certificationButton];
    certificationButton.backgroundColor = CCXColorWithRGB(78, 142, 220);
    [certificationButton setTitle:@"提交" forState:UIControlStateNormal];
    [certificationButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    certificationButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
    certificationButton.layer.cornerRadius = 5;
    certificationButton.layer.masksToBounds = YES;
    [certificationButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(friendPhoneView.bottom).offset(@(AdaptationHeight(30)));
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
//        _scheduleProgressView.progress = 0.625;
//        _scheduleProgressLabel.text = @"62.5%";
//    }
}

#pragma mark - UITapGestureRecognizer
- (void)chooseParentNameAndPhone
{
    _needToChangeName = YES;
    _whichPhone = @"parent";
    [self getContactPermission];
}

- (void)chooseParentPhone
{
    _whichPhone = @"parent";
    _needToChangeName = NO;
    [self getContactPermission];
}

- (void)chooseFamilyPlace
{
    _chooseCityView = [[GJJChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseCityView.delegate = self;
    [_chooseCityView showView];
}

- (void)chooseFriendNameAndPhone
{
    _needToChangeName = YES;
    _whichPhone = @"friend";
    [self getContactPermission];
}

- (void)chooseParentRelation
{
    _parentRelationshipImageView.image = [UIImage imageNamed:@"联系人展开"];
    if (_dropRelationshipView) {
        [_dropRelationshipView removeFromSuperview];
        _dropRelationshipView = nil;
    }else {
        _dropRelationshipView = [[GJJLinkManDropView alloc]init];
        [self.view addSubview:_dropRelationshipView];
        _dropRelationshipView.isNeedSeparator = YES;
        _dropRelationshipView.cornerRadius = AdaptationWidth(3);
        _dropRelationshipView.bankArray = [NSMutableArray arrayWithArray:@[@"配偶", @"父/母"]];
        [_dropRelationshipView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_parentRelationshipLabel.bottom).offset(@(AdaptationHeight(5)));
            make.height.equalTo(@(44*2));
            make.left.equalTo(_parentRelationshipLabel.left);
            make.right.equalTo(_parentRelationshipImageView.right);
        }];
        
        __weak typeof (self)weak = self;
        _dropRelationshipView.returnBank = ^(NSString *chooseThing) {
            __strong typeof(weak) weakself = weak;
            weakself->_parentRelationshipLabel.text = chooseThing;
            _dropRelationshipView = nil;
            weakself->_parentRelationshipImageView.image = [UIImage imageNamed:@"联系人收起"];
            weakself->_parentRelationshipLabel.text = chooseThing;
            weakself->_parentNamePlaceHolder = [NSString stringWithFormat:@"请选择您%@的姓名", chooseThing];
            weakself->_parentPhonePlaceHolder = [NSString stringWithFormat:@"请选择您%@的电话号码", chooseThing];
            weakself->_parentAddressPlaceHolder = [NSString stringWithFormat:@"请选择您%@所在的省市区", chooseThing];
            weakself->_parentDetailAddressPlaceHolder = [NSString stringWithFormat:@"请选择您%@的具体家庭地址", chooseThing];
            if (!weakself->_parentPhoneStr) {
                weakself->_parentPhoneLabel.text = weakself->_parentPhonePlaceHolder;
            }
            if (!weakself->_parentAddressStr) {
                weakself->_parentAddressLabel.text = weakself->_parentAddressPlaceHolder;
            }
            UIColor *placeholderColor = CCXColorWithHex(@"c2c2c2");
            weakself->_familyAddressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:weakself->_parentDetailAddressPlaceHolder attributes:@{NSForegroundColorAttributeName: placeholderColor}];
        };
    }
}

- (void)chooseFriendRelation
{
    _friendRelationshipImageView.image = [UIImage imageNamed:@"联系人展开"];
    if (!_chooseFriendRelationshipPicker) {
        _chooseFriendRelationshipPicker = [[GJJChoosePickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _chooseFriendRelationshipPicker.delegate = self;
        _chooseFriendRelationshipPicker.chooseThings = @[@"父/母", @"配偶", @"同事", @"朋友", @"其他"];
    }
    [_chooseFriendRelationshipPicker showView];
}

- (void)chooseFriendPhone
{
    _needToChangeName = NO;
    _whichPhone = @"friend";
    [self getContactPermission];
}

- (void)getContactPermission
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
                ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
                nav.peoplePickerDelegate = self;
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        
                    }
                }
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self presentContactController];
            }];
        }else {
            [self presentContactController];
        }
    }
}

- (void)presentContactController
{
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        CNContactPickerViewController *contactPickerVc = [CNContactPickerViewController new];
        
        contactPickerVc.delegate = self;
        
        [self presentViewController:contactPickerVc animated:YES completion:^{
            [self getAllContactsAuthorization];
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusDenied) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录%@按钮",APPDEFAULTNAME] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)getAllContactsAuthorization
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self getAllContacts];
            }];
        }else {
            [self getAllContacts];
        }
    }
}

- (void)getAllContacts
{
    if (_allContactArray.count > 0) {
        return;
    }
    [_allContactArray removeAllObjects];
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        //如果被授权访问通讯录,进行访问相关操作
        CNContactStore *contactStore = [CNContactStore new];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]];
        
        NSError *error = nil;
        
        BOOL result = [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *phoneName = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
            phoneName = [phoneName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]];
            NSString *phone = @"";
            int i = 0;
            for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                ++i;
                if (i<contact.phoneNumbers.count) {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }else {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }
            }
            NSDictionary *contactDict = @{@"phoneName":phoneName, @"phone":phone};
            [_allContactArray addObject:contactDict];
        }];
        
        if (!result) {
            NSLog(@"读取失败,error:%@",error);
            return;
        }
        NSLog(@"读取成功");
    }
}

#pragma mark - 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    CNContact *contact = contactProperty.contact;
    
    if ([contactProperty.value isKindOfClass:[NSString class]]) {
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
    
    if ([_whichPhone isEqualToString:@"parent"]) {
        if (_needToChangeName) {
            _parentNameText.text = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
        }
        _parentPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        _parentPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _parentPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
    }else if ([_whichPhone isEqualToString:@"friend"]) {
        if (_needToChangeName) {
            _friendNameText.text = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
        }
        _friendPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        _friendPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _friendPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
    }
}

- (NSString *)phoneStringWithNoSpaceAndDash:(NSString *)string
{
    NSString *temp = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return temp;
}

#pragma mark - 支持iOS9以下获取通讯录
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    if ([_whichPhone isEqualToString:@"parent"]) {
        if (_needToChangeName) {
            _parentNameText.text = [NSString stringWithFormat:@"%@", phoneName];
        }
        _parentPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
        _parentPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _parentPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNO];
    }else if ([_whichPhone isEqualToString:@"friend"]) {
        if (_needToChangeName) {
            _friendNameText.text = [NSString stringWithFormat:@"%@", phoneName];
        }
        _friendPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
        _friendPhoneLabel.textColor = CCXColorWithHex(@"888888");
        _friendPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNO];
    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    [_allContactArray removeAllObjects];
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneString = @"";
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if (k < ABMultiValueGetCount(phone)-1) {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }else {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }
            
        }
        NSDictionary *contactDict = @{@"phoneName":phoneName, @"phone":phoneString};
        [_allContactArray addObject:contactDict];
    }
}

#pragma mark - GJJChoosePickerViewDelegate
- (void)chooseThing:(NSString *)thing pickView:(GJJChoosePickerView *)pickView row:(NSInteger)row
{
    _friendRelationshipLabel.text = thing;
    _friendNamePlaceHolder = [NSString stringWithFormat:@"请选择您%@的姓名", thing];
    _friendPhonePlaceHolder = [NSString stringWithFormat:@"请选择您%@的电话号码", thing];
    if (!_friendPhoneStr) {
        _friendPhoneLabel.text = _friendPhonePlaceHolder;
    }
    _friendRelationshipImageView.image = [UIImage imageNamed:@"联系人收起"];
}

- (void)userCancelPick:(GJJChoosePickerView *)pickView
{
    _friendRelationshipImageView.image = [UIImage imageNamed:@"联系人收起"];
}

#pragma mark - GJJChooseCityViewDelegate
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(GJJChooseCityView *)chooseView
{
    _province = province;
    _city = city;
    _town = town;
    
    _parentAddressStr = [NSString stringWithFormat:@"%@ %@ %@", _province, _city, _town];
    _parentAddressLabel.text = _parentAddressStr;
    _parentAddressLabel.textColor = CCXColorWithHex(@"888888");
    _parentAddressLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - button click
- (void)certificationClick:(UIButton *)sender
{
    if (_parentNameText.text.length == 0) {
        [self setHudWithName:_parentNamePlaceHolder Time:1 andType:1];
        return;
    }
    
    if (![self isInputRuleOnlyChineseString:_parentNameText.text]) {
        [self setHudWithName:@"联系人需为1-20位中文" Time:1 andType:1];
        return;
    }
    
    if (![self isInputRulePhoneNumber:_parentPhoneLabel.text]) {
        [self setHudWithName:@"联系人号码必须为11位数字" Time:1 andType:1];
        return;
    }
    
    if ([_parentAddressLabel.text isEqualToString:_parentAddressPlaceHolder]) {
        [self setHudWithName:_parentAddressPlaceHolder Time:1 andType:1];
        return;
    }
    
    if (_familyAddressText.text.length == 0) {
        [self setHudWithName:_parentDetailAddressPlaceHolder Time:1 andType:1];
        return;
    }
    
    if (_friendNameText.text.length == 0) {
        [self setHudWithName:_friendNamePlaceHolder Time:1 andType:1];
        return;
    }
    
    if (![self isInputRuleOnlyChineseString:_friendNameText.text]) {
        [self setHudWithName:@"联系人需为1-20位中文" Time:1 andType:1];
        return;
    }
    
    if (![self isInputRulePhoneNumber:_friendPhoneLabel.text]) {
        [self setHudWithName:@"联系人号码必须为11位数字" Time:1 andType:1];
        return;
    }
    
    [self prepareDataWithCount:GJJAdultUserLinkManRequestSaveLinkMan];
}

- (void)setRequestParams
{
    if (self.requestCount == GJJAdultUserLinkManRequestData) {
        self.cmd = GJJQueryMyCertId;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"qryType":@"5"};
    }else if (self.requestCount == GJJAdultUserLinkManRequestSaveLinkMan) {
        
        NSDictionary *fatherDict = @{@"contactType":@"0", @"contactName":_parentNameText.text, @"contactPhone":_parentPhoneLabel.text, @"familyAdress":_parentAddressLabel.text, @"contactAdress":_familyAddressText.text, @"relationship":_parentRelationshipLabel.text};
        NSDictionary *roommateDict = @{@"contactType":@"1", @"contactName":_friendNameText.text, @"contactPhone":_friendPhoneLabel.text, @"contactAdress":@"", @"relationship":_friendRelationshipLabel.text};
        NSMutableArray *contacts = [NSMutableArray array];
        [contacts addObject:fatherDict];
        [contacts addObject:roommateDict];
        
        self.cmd = GJJSaveContacts;
        self.dict = @{@"userId":[self getSeccsion].userId,
                      @"contacts":contacts,
                      @"phoneNameList":_allContactArray
                      };
    }
}

- (void)requestSuccessWithDictionary:(NSDictionary *)dict
{
    if (self.requestCount == GJJAdultUserLinkManRequestData) {
        NSArray *detaList = dict[@"detaList"];
        for (NSDictionary *dict in detaList) {
            GJJContactModel *model = [GJJContactModel yy_modelWithDictionary:dict];
            [_contactArray addObject:model];
        }
        
        [self setupView];
    }else if (self.requestCount == GJJAdultUserLinkManRequestSaveLinkMan) {
        if (_schedule == 8) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            GJJAdultSelfInfomationViewController *controller = [[GJJAdultSelfInfomationViewController alloc]init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.title = @"在职信息";
            controller.popViewController = self.popViewController;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)requestFaildWithDictionary:(NSDictionary *)dict
{
    [super requestFaildWithDictionary:dict];
    if (self.requestCount == GJJAdultUserLinkManRequestData) {
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

#pragma mark - regular

- (BOOL)isInputRuleOnlyChineseString:(NSString *)str {
    NSString *pattern = @"^[\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

- (BOOL)isInputRulePhoneNumber:(NSString *)phoneNumber
{
    NSString *pattern = @"^\\d{11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
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
