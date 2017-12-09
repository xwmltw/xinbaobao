//
//  GJJChoosePickerView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/14.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJChoosePickerView;

@protocol GJJChoosePickerViewDelegate <NSObject>

- (void)chooseThing:(NSString *)thing pickView:(GJJChoosePickerView *)pickView row:(NSInteger)row;

@optional

- (void)userCancelPick:(GJJChoosePickerView *)pickView;

@end

@interface GJJChoosePickerView : UIView

@property (nonatomic, strong) NSArray *chooseThings;

@property (nonatomic, weak) id <GJJChoosePickerViewDelegate> delegate;

- (void)showView;

@end
