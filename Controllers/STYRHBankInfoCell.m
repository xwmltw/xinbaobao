//
//  STYRHBankInfoCell.m
//  RenRenhua2.0
//
//  Created by 孙涛 on 2017/9/11.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STYRHBankInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface STYRHBankInfoCell()
@property (nonatomic,strong)UIView *whiteView;
@end


@implementation STYRHBankInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
        self.backgroundColor = CCXBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    [self.contentView addSubview:self.whiteView];
    
    [self.whiteView addSubview:self.bankIcon];
    
    [self.whiteView addSubview:self.bankName];
    
    [self.whiteView addSubview:self.bankNumber];
    
    
    //布局
    _whiteView.sd_layout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .bottomSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView, AdaptationWidth(10));
    
    _bankIcon.sd_layout
    .widthIs(50)
    .heightIs(50)
    .topSpaceToView(self.whiteView,15)
    .leftSpaceToView(self.whiteView,15);
    
    
    _bankName.sd_layout
    .heightIs(20)
    .topSpaceToView(self.whiteView,15)
    .leftSpaceToView(self.bankIcon,12)
    .rightSpaceToView(self.whiteView, 10);
    
    _bankNumber.sd_layout
    .heightIs(30)
    .topSpaceToView(self.bankName,5)
    .leftEqualToView(self.bankName)
    .rightSpaceToView(self.whiteView, 10);
    
    
}

//银行卡
-(void)setModel:(GJJGetBankModel *)model{
    if (model) {
        _model = model;
        
        [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:_model.bankLogUrl] placeholderImage:[UIImage imageNamed:@"mine_top_logo"]];
//        NSString *securityStr = [_model.bankCard stringByReplacingCharactersInRange:NSMakeRange((_model.bankCard.length - 8) / 2, 8) withString:@" **** **** "];
        NSString *securityStr = [_model.bankCard stringByReplacingCharactersInRange:NSMakeRange(4, _model.bankCard.length - 8) withString:@" **** **** "];
        self.bankName.text = _model.bankName;
        self.bankNumber.text = securityStr;
        
        
    }
}

//信用卡
-(void)setCreditCardNumberModel:(GJJAdultCreditCardNumberModel *)creditCardNumberModel{
    
    if (creditCardNumberModel) {
        _creditCardNumberModel = creditCardNumberModel;
        
        [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:_creditCardNumberModel.bankLogUrl] placeholderImage:[UIImage imageNamed:@"mine_top_logo"]];
//        NSString *securityStr = [_creditCardNumberModel.xykzh stringByReplacingCharactersInRange:NSMakeRange((_creditCardNumberModel.xykzh.length - 8) / 2, 8) withString:@" **** **** "];
        NSString *securityStr = [_creditCardNumberModel.xykzh stringByReplacingCharactersInRange:NSMakeRange(4, _creditCardNumberModel.xykzh.length - 8) withString:@" **** **** "];
        self.bankName.text = _creditCardNumberModel.bankName;
        self.bankNumber.text = securityStr;
        

    }
}



-(UIImageView *)bankIcon{
    if (!_bankIcon) {
        _bankIcon = [[UIImageView alloc]init];
        _bankIcon.contentMode = UIViewContentModeScaleAspectFit;
        _bankIcon.layer.cornerRadius = 5;
        _bankIcon.clipsToBounds = YES;
    }
    return _bankIcon;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [UIImageView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}


-(UILabel *)bankName{
    if (!_bankName) {
        _bankName = [[UILabel alloc]init];
        _bankName.font = [UIFont systemFontOfSize:16];
        _bankName.textColor = [UIColor blackColor];
        _bankName.textAlignment = NSTextAlignmentLeft;
    }
    return _bankName;
}

-(UILabel *)bankNumber{
    if (!_bankNumber) {
        _bankNumber = [[UILabel alloc]init];
        _bankNumber.textAlignment = NSTextAlignmentLeft;
        _bankNumber.textColor = [UIColor lightGrayColor];
        //        _bankNumber.numberOfLines = 2;
        //        _bankNumber.lineBreakMode = NSLineBreakByTruncatingTail;
        _bankNumber.font = [UIFont fontWithName:@"PingFang-HK-Regular" size:AdaptationWidth(18)];
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
