//
//  GJJContractWaitView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/20.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJContractWaitView.h"

@implementation GJJContractWaitView
{
    NSString *_title;
    NSString *_waitImageNamed;
    NSString *_content;
}

- (instancetype)initWithTitle:(NSString *)title waitImageNamed:(NSString *)waitImageNamed content:(NSString *)content
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _title = title;
    _waitImageNamed = waitImageNamed;
    _content = content;
    
    [self setupView];
    
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.frame = [UIScreen mainScreen].bounds;
    
    UIView *hintView = [[UIView alloc]init];
    [self addSubview:hintView];
    hintView.backgroundColor = [UIColor whiteColor];
    hintView.layer.cornerRadius = 5;
    hintView.layer.masksToBounds = YES;
    [hintView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(AdaptationWidth(256)));
        make.height.equalTo(@(AdaptationHeight(164)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [hintView addSubview:titleLabel];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(hintView);
        make.top.equalTo(hintView).offset(@(AdaptationHeight(20)));
        make.height.equalTo(@(AdaptationHeight(25)));
    }];
    
    UIImageView *waitImageView = [[UIImageView alloc]init];
    [hintView addSubview:waitImageView];
    waitImageView.image = [UIImage imageNamed:_waitImageNamed];
    [waitImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hintView);
        make.top.equalTo(titleLabel.bottom).offset(@(AdaptationHeight(15)));
        make.width.equalTo(@(AdaptationWidth(39)));
        make.height.equalTo(@(AdaptationHeight(37)));
    }];
    
    //添加旋转动画
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = NSIntegerMax;
    [waitImageView.layer addAnimation:animation forKey:nil];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    [hintView addSubview:contentLabel];
    contentLabel.text = _content;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(waitImageView.bottom).offset(@(AdaptationHeight(10)));
        make.left.right.equalTo(hintView);
        make.height.equalTo(@(AdaptationHeight(25)));
    }];
    
}

- (void)showContractWaitView
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
}

- (void)closeContractWaitView
{
    [self removeFromSuperview];
}

@end
