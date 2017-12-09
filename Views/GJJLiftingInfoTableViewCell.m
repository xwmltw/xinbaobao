//
//  GJJLiftingInfoTableViewCell.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/6.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJLiftingInfoTableViewCell.h"

@implementation GJJLiftingInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    _infoImageView = [[UIImageView alloc]init];
    [self addSubview:_infoImageView];
    
    _infoLabel = [[UILabel alloc]init];
    [self addSubview:_infoLabel];
    
    _authenticationLabel = [[UILabel alloc]init];
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
        make.size.equalTo(CGSizeMake(AdaptationWidth(22), AdaptationHeight(20)));
    }];
    
    _infoLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_infoImageView.right).offset(@(AdaptationWidth(15)));
    }];
    
    [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(@(AdaptationWidth(-32)));
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(AdaptationWidth(10), AdaptationHeight(18)));
    }];
    

    _authenticationLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    [_authenticationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImageView.left).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(self);
    }];
    
    UILabel *separatorLabel = [[UILabel alloc]init];
    [self addSubview:separatorLabel];
    separatorLabel.backgroundColor = [UIColor whiteColor];
    [separatorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(@(AdaptationWidth(5)));
        make.right.equalTo(self).offset(@(AdaptationWidth(-5)));
        make.height.equalTo(@2);
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
