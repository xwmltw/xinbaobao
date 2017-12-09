//
//  GJJShowNoticeGuideView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/3/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJShowNoticeGuideView.h"

@implementation GJJShowNoticeGuideView
{
    UIImageView *_noticeImageView;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setupView];
    
    return self;
}

- (void)setupView
{
    _noticeImageView = [[UIImageView alloc]init];
    [self addSubview:_noticeImageView];
    _noticeImageView.userInteractionEnabled = YES;
    _noticeImageView.image = [UIImage imageNamed:@"首页蒙版"];
    [_noticeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UITapGestureRecognizer *closeImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeImage:)];
    [_noticeImageView addGestureRecognizer:closeImageTap];
    
    UIButton *noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:noticeButton];
    [noticeButton addTarget:self action:@selector(clickNoticeButton:) forControlEvents:UIControlEventTouchUpInside];
    [noticeButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
        make.width.equalTo(@(50));
        make.height.equalTo(@49);
    }];
}

- (void)clickNoticeButton:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(jumpToNoticeTabbarAndCloseGuideView:)]) {
        [_delegate jumpToNoticeTabbarAndCloseGuideView:self];
    }
}

#pragma mark - UITapGestureRecognizer
- (void)closeImage:(UITapGestureRecognizer *)sender
{
    [self removeFromSuperview];
}


@end
