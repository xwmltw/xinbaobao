//
//  STAdultCreditCardListCell.m
//  RenRenhua2.0
//
//  Created by 孙涛 on 2017/9/19.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STAdultCreditCardListCell.h"

@implementation STAdultCreditCardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    _infoImageView = [[UIImageView alloc]init];
    [self addSubview:_infoImageView];
    
    _infoLabel = [[UILabel alloc]init];
    _infoLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_infoLabel];
    
    _authenticationLabel = [[UILabel alloc]init];
    _authenticationLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_authenticationLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    [self addSubview:_arrowImageView];
    
    
    [self setupView];
    
    return self;
}

- (void)setupView
{
    [_infoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(@(AdaptationWidth(20)));
        make.size.equalTo(CGSizeMake(AdaptationWidth(30), AdaptationHeight(30)));
    }];
    
    _infoLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_infoImageView.right).offset(@(AdaptationWidth(15)));
    }];
    
    [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(@(AdaptationWidth(-32)));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(AdaptationWidth(8), AdaptationHeight(14)));
    }];
    
    
//    _authenticationLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    [_authenticationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImageView.left).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(self);
    }];
    
    _separatorLabel = [[UILabel alloc]init];
    [self addSubview:_separatorLabel];
    _separatorLabel.backgroundColor = [UIColor lightGrayColor];
    [_separatorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoLabel.left);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
    
    
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
