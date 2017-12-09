//
//  WQSwitch.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/12/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQSwitch : UIControl

@property (nonatomic, assign, getter = isOn) BOOL on;

@property (nonatomic, strong) UIColor *onTintColor;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSString *onText;
@property (nonatomic, strong) NSString *offText;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
