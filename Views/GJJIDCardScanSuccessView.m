//
//  GJJIDCardScanSuccessView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/14.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJIDCardScanSuccessView.h"
#import "GJJIDCardScanSuccessTableViewCell.h"

@interface GJJIDCardScanSuccessView ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
GJJIDCardScanSuccessTableViewCellDelegate>

@end

@implementation GJJIDCardScanSuccessView
{
    UITableView *_infoTableView;
    TCARD_TYPE _iCardType;
}

- (instancetype)initWithType:(TCARD_TYPE)iCardType image:(UIImage *)cardImage
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _iCardType = iCardType;
    [self setupViewWithType:iCardType image:cardImage];
    
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:infoDict];
    tempDict[@"name"] = [tempDict[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@""];;
    _infoDict = tempDict;
    [_infoTableView reloadData];
}

/**
 身份证全图
 @param iCardType 20:反面 17：正面
 @param cardImage 图片
 */
- (void)setupViewWithType:(TCARD_TYPE)iCardType image:(UIImage *)cardImage
{
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    UIView *IDCardView = [[UIView alloc]init];
    [self addSubview:IDCardView];
    IDCardView.backgroundColor = [UIColor whiteColor];
    IDCardView.layer.cornerRadius = AdaptationWidth(10);
    IDCardView.layer.masksToBounds = YES;
    [IDCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(@(AdaptationWidth(25)));
        make.right.equalTo(self).offset(@(AdaptationWidth(-25)));
        make.height.equalTo(self).multipliedBy(0.3);
    }];
    
    UIImageView *IDCardImageView = [[UIImageView alloc]init];
    [IDCardView addSubview:IDCardImageView];
//    IDCardImageView.contentMode = UIViewContentModeScaleAspectFit;
    IDCardImageView.image = cardImage;
    [IDCardImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(IDCardView).insets(UIEdgeInsetsMake(AdaptationHeight(15), AdaptationWidth(25), AdaptationHeight(15), AdaptationWidth(25)));
    }];
    
    UIView *hintView = [[UIView alloc]init];
    [self addSubview:hintView];
    hintView.backgroundColor = [UIColor clearColor];
    [hintView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDCardView.bottom);
        make.left.right.equalTo(IDCardView);
        make.height.equalTo(@(AdaptationHeight(32)));
    }];
    
    UIImageView *hintImageView = [[UIImageView alloc]init];
    [hintView addSubview:hintImageView];
    hintImageView.image = [UIImage imageNamed:@"身份认证提示"];
    [hintImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView);
        make.left.equalTo(hintView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(12), AdaptationWidth(12)));
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [hintView addSubview:hintLabel];
    if (iCardType == 17) {
        hintLabel.text = @"核对以下信息并确认，如若有误，请及时修改或重新扫描";
    }else if (iCardType == 20) {
        hintLabel.text = @"请核对签发机关和有效期限信息，确认无误";
    }
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    hintLabel.textColor = [UIColor colorWithHexString:@"f69a58"];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintImageView.right).offset(@(AdaptationWidth(5)));
        make.right.equalTo(hintView);
        make.top.bottom.equalTo(hintView);
    }];
    
    UIView *infoView = [[UIView alloc]init];
    [self addSubview:infoView];
    infoView.backgroundColor = [UIColor whiteColor];
    [infoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintView.bottom);
        make.left.right.equalTo(self);
        if (iCardType == 17) {
            make.height.equalTo(@(AdaptationHeight(135)));
        }else if (iCardType == 20) {
            make.height.equalTo(@(AdaptationHeight(100)));
        }
    }];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [infoView addSubview:_infoTableView];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.bounces = NO;
    _infoTableView.scrollEnabled = NO;
    [_infoTableView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoView);
        if (iCardType == 17) {
            make.height.equalTo(@(AdaptationHeight(36 * 3)));
        }else if (iCardType == 20) {
             make.height.equalTo(@(AdaptationHeight(36 * 2)));
        }
        make.left.equalTo(infoView).offset(@(AdaptationWidth(35)));
        make.right.equalTo(infoView).offset(@(AdaptationWidth(-35)));
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureButton];
    sureButton.backgroundColor = [UIColor colorWithHexString:GJJMainColorString];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(18)];
    [sureButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = AdaptationWidth(4);
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.bottom).offset(@(AdaptationHeight(60)));
        make.left.equalTo(self).offset(@(AdaptationWidth(17)));
        make.right.equalTo(self).offset(@(AdaptationWidth(-17)));
        make.height.equalTo(@(AdaptationHeight(50)));
    }];
    
    UIButton *rescanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rescanButton];
    rescanButton.backgroundColor = [UIColor clearColor];
    [rescanButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    rescanButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [rescanButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
    [rescanButton addTarget:self action:@selector(rescanClick) forControlEvents:UIControlEventTouchUpInside];
    [rescanButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureButton.bottom).offset(@(AdaptationHeight(25)));
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(AdaptationWidth(100), AdaptationHeight(40)));
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_iCardType == 17) {
        return 3;
    }else if (_iCardType == 20) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptationHeight(35);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    
    GJJIDCardScanSuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[GJJIDCardScanSuccessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID indexPath:indexPath iCardType:_iCardType];
    }
    cell.infoDict = _infoDict;
    cell.delegate = self;
    return cell;
}

#pragma mark - GJJIDCardScanSuccessTableViewCellDelegate
- (void)userNeedEditInfoWithCell:(GJJIDCardScanSuccessTableViewCell *)cell textField:(UITextField *)textField iCardType:(TCARD_TYPE)iCardType
{
    NSIndexPath *indexPath = [_infoTableView indexPathForCell:cell];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:_infoDict];
    if (iCardType == 17) {
        if (indexPath.row == 0) {
            tempDict[@"name"] = textField.text;
        }else if (indexPath.row == 1) {
            tempDict[@"sex"] = textField.text;
        }else if (indexPath.row == 2) {
            tempDict[@"num"] = textField.text;
        }
    }else if (iCardType == 20) {
        if (indexPath.row == 0) {
            tempDict[@"issue"] = textField.text;
        }else if (indexPath.row == 1) {
            tempDict[@"period"] = textField.text;
        }
    }
    _infoDict = tempDict;
}

#pragma mark - button click
- (void)sureClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(IDCardScanSureInfoWithInfo:)]) {
        if (_iCardType == 17) {
            if (_delegate && [_delegate respondsToSelector:@selector(sureAgainInfo:infoView:)]) {
                [_delegate sureAgainInfo:_infoDict infoView:self];
            }
        }else {
            if (_delegate && [_delegate respondsToSelector:@selector(IDCardScanSureInfoWithInfo:)]) {
                [self removeFromSuperview];
                [_delegate IDCardScanSureInfoWithInfo:_infoDict];
            }
        }
    }
}

- (void)rescanClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(IDCardRescan)]) {
        [self removeFromSuperview];
        [_delegate IDCardRescan];
    }
}

@end
