//
//  GJJIdentityVerifyViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/6.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJNeedOCRViewController.h"

@interface GJJIdentityVerifyViewController : GJJNeedOCRViewController

@property (nonatomic, copy) NSString *requestIDCardFrontImageString;

@property (nonatomic, copy) NSString *requestIDCardBackImageString;

@property (nonatomic, assign) NSUInteger schedule;

@property (nonatomic, strong) UIViewController *popViewController;

@end
