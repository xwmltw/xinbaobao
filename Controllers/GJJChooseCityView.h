//
//  GJJChooseCityView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/1.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJChooseCityView;

@protocol GJJChooseCityViewDelegate <NSObject>

- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(GJJChooseCityView *)chooseView;

@end

@interface GJJChooseCityView : UIView

@property (nonatomic, weak) id <GJJChooseCityViewDelegate> delegate;
- (void)showView;

@end
