//
//  GJJContractWaitView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/20.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GJJContractWaitView : UIView

- (instancetype)initWithTitle:(NSString *)title waitImageNamed:(NSString *)waitImageNamed content:(NSString *)content;

- (void)showContractWaitView;

- (void)closeContractWaitView;

@end
