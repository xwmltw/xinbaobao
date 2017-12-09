//
//  STBankInfoCell.m
//  RenRenhua2.0
//
//  Created by 孙涛 on 2017/7/31.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STBankInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface STBankInfoCell ()
@property (nonatomic,strong)UIView *whiteView;
@end

@implementation STBankInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    [self.contentView addSubview:self.backgroundImageV];
    
    [self.backgroundImageV addSubview:self.whiteView];
    
    [self.whiteView addSubview:self.bankIcon];
    
    [self.backgroundImageV addSubview:self.bankName];
    
    [self.backgroundImageV addSubview:self.bankType];
    
    [self.backgroundImageV addSubview:self.bankNumber];
    
    
    //布局
    _backgroundImageV.sd_layout
    .leftSpaceToView(self.contentView,AdaptationWidth(20))
    .rightSpaceToView(self.contentView,AdaptationWidth(20))
    .bottomSpaceToView(self.contentView,AdaptationWidth(20))
    .topSpaceToView(self.contentView, AdaptationWidth(20));
    
    _whiteView.sd_layout
    .widthIs(45)
    .heightIs(45)
    .topSpaceToView(self.backgroundImageV,20)
    .leftSpaceToView(self.backgroundImageV,10);
    
    _bankIcon.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _bankName.sd_layout
    .heightIs(20)
    .topSpaceToView(self.backgroundImageV,15)
    .leftSpaceToView(self.bankIcon,12)
    .rightSpaceToView(self.backgroundImageV, 10);
    
    _bankType.sd_layout
    .heightIs(20)
    .topSpaceToView(self.bankName,2)
    .leftSpaceToView(self.bankIcon,12)
    .rightSpaceToView(self.backgroundImageV, 10);
    
    _bankNumber.sd_layout
    .heightIs(30)
    .topSpaceToView(self.bankType,5)
    .leftEqualToView(self.bankType)
    .rightSpaceToView(self.backgroundImageV, 10);
    

}

//银行卡
-(void)setModel:(GJJGetBankModel *)model{
    if (model) {
        _model = model;
        
        [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:_model.bankLogUrl] placeholderImage:[UIImage imageNamed:@"load"]];
        NSString *securityStr = [_model.bankCard stringByReplacingCharactersInRange:NSMakeRange((_model.bankCard.length - 8) / 2, 8) withString:@" **** **** "];
        self.bankName.text = _model.bankName;
        self.bankType.text = @"储蓄卡";
        self.bankNumber.text = securityStr;

        
    }
}

//信用卡
-(void)setCreditCardNumberModel:(GJJAdultCreditCardNumberModel *)creditCardNumberModel{

    if (creditCardNumberModel) {
        _creditCardNumberModel = creditCardNumberModel;
        
        [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:_creditCardNumberModel.bankLogUrl] placeholderImage:[UIImage imageNamed:@"load"]];
        NSString *securityStr = [_creditCardNumberModel.xykzh stringByReplacingCharactersInRange:NSMakeRange((_creditCardNumberModel.xykzh.length - 8) / 2, 8) withString:@" **** **** "];
        self.bankName.text = _creditCardNumberModel.bankName;
        self.bankType.text = @"信用卡";
        self.bankNumber.text = securityStr;
        
        
    }
}



-(UIImageView *)backgroundImageV{
    if (!_backgroundImageV) {
        _backgroundImageV = [[UIImageView alloc]init];
//        _backgroundImageV.layer.cornerRadius = 20;
        _backgroundImageV.contentMode = UIViewContentModeScaleAspectFit;
        _backgroundImageV.image = [UIImage imageNamed:@"card_bg"];
//        _backgroundImageV.clipsToBounds = YES;
    }
    return _backgroundImageV;
}

-(UIImageView *)bankIcon{
    if (!_bankIcon) {
        _bankIcon = [[UIImageView alloc]init];
         _bankIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bankIcon.layer.cornerRadius = 22.5;
        _bankIcon.clipsToBounds = YES;
    }
    return _bankIcon;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [UIImageView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 22.5;
        _whiteView.clipsToBounds = YES;
    }
    return _whiteView;
}

-(UILabel *)bankType{
    if (!_bankType) {
        _bankType = [[UILabel alloc]init];
        _bankType.textAlignment = NSTextAlignmentLeft;
        _bankType.textColor = [UIColor whiteColor];
        _bankType.font = [UIFont systemFontOfSize:12];
    }
    return _bankType;
}

-(UILabel *)bankName{
    if (!_bankName) {
        _bankName = [[UILabel alloc]init];
        _bankName.font = [UIFont systemFontOfSize:14];
        _bankName.textColor = [UIColor whiteColor];
        _bankName.textAlignment = NSTextAlignmentLeft;
    }
    return _bankName;
}

-(UILabel *)bankNumber{
    if (!_bankNumber) {
        _bankNumber = [[UILabel alloc]init];
        _bankNumber.textAlignment = NSTextAlignmentLeft;
        _bankNumber.textColor = [UIColor whiteColor];
//        _bankNumber.numberOfLines = 2;
//        _bankNumber.lineBreakMode = NSLineBreakByTruncatingTail;
        _bankNumber.font = [UIFont fontWithName:@"PingFang-HK-Regular" size:AdaptationWidth(20)];
    }
    return _bankNumber;
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
