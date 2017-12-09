//
//  GJJScanIDCardBackSuccessViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/29.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@protocol GJJScanIDCardBackSuccessViewControllerDelegate <NSObject>

- (void)userRescanIDCardBack;

- (void)userSureIDCardBack;

@end

@interface GJJScanIDCardBackSuccessViewController : CCXNeedBackViewController

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) UIImage *idcardBackImage;

@property (nonatomic, weak) id <GJJScanIDCardBackSuccessViewControllerDelegate> delegate;

@end
