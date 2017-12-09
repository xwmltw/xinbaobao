//
//  GJJMyInfomationTableViewCell.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJMyInfomationTableViewCell.h"

@implementation GJJMyInfomationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView
{
    UIImageView *backgroundImageView = [[UIImageView alloc]init];
    [self addSubview:backgroundImageView];
    backgroundImageView.image = [UIImage imageNamed:@"ziliao_line"];
    UIEdgeInsets backgroundImageViewPadding = UIEdgeInsetsMake(AdaptationHeight(5), AdaptationWidth(13), AdaptationHeight(5), AdaptationWidth(10));
    [backgroundImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(backgroundImageViewPadding);
    }];
    
    UIImageView *circleImageView = [[UIImageView alloc]init];
    [self addSubview:circleImageView];
    circleImageView.image = [UIImage imageNamed:@"ziliao_dot"];
    [circleImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundImageView.left).offset(@(AdaptationWidth(10)));
        make.centerY.equalTo(backgroundImageView.centerY);
    }];
    
    _infoLabel = [[UILabel alloc]init];
    [self addSubview:_infoLabel];
    
    _infoDetailLabel = [[UILabel alloc]init];
    [self addSubview:_infoDetailLabel];
    
    _authenticationLabel = [[UILabel alloc]init];
    [self addSubview:_authenticationLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    [self addSubview:_arrowImageView];
    
    _infoLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    _infoLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [_infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(circleImageView.right).offset(@(AdaptationWidth(15)));
        make.centerY.equalTo(backgroundImageView.centerY);
    }];
    
    _infoDetailLabel.font = [UIFont systemFontOfSize:AdaptationWidth(12)];
    [_infoDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_infoLabel.right);
        make.centerY.equalTo(backgroundImageView.centerY);
    }];
    
    [_arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundImageView.right).offset(@(AdaptationWidth(-22)));
        make.centerY.equalTo(backgroundImageView.centerY);
        make.size.equalTo(CGSizeMake(AdaptationWidth(10), AdaptationHeight(18)));
    }];
    
    _authenticationLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    [_authenticationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImageView.left).offset(@(AdaptationWidth(-10)));
        make.centerY.equalTo(backgroundImageView.centerY);
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
