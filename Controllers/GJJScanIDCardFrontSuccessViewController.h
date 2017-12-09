//
//  GJJScanIDCardFrontSuccessViewController.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/27.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@protocol GJJScanIDCardFrontSuccessViewControllerDelegate <NSObject>

- (void)userRescanIDCardFront;

- (void)userSureIDCardFront;

@end

@interface GJJScanIDCardFrontSuccessViewController : CCXNeedBackViewController

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) UIImage *idcardFrontImage;

@property (nonatomic, weak) id <GJJScanIDCardFrontSuccessViewControllerDelegate> delegate;

@end
