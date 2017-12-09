//
//  GJJMessageVerificationAgainViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/4/26.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@class GJJOperatorsModel;

@interface GJJMessageVerificationAgainViewController : CCXNeedBackViewController

@property (nonatomic, assign) NSUInteger schedule;

@property (nonatomic, strong) GJJOperatorsModel *operatorsModel;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) UIViewController *popViewController;

@end
