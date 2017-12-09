//
//  GJJShowNoticeGuideView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/3/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJShowNoticeGuideView;

@protocol GJJShowNoticeGuideViewDelegate <NSObject>

- (void)jumpToNoticeTabbarAndCloseGuideView:(GJJShowNoticeGuideView *)guideView;

@end

@interface GJJShowNoticeGuideView : UIView

@property (nonatomic, weak) id <GJJShowNoticeGuideViewDelegate> delegate;

@end
