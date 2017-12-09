//
//  GJJIDCardScanSuccessView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/14.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globaltypedef.h"

@class GJJIDCardScanSuccessView;

@protocol GJJIDCardScanSuccessViewDelegate <NSObject>

- (void)sureAgainInfo:(NSDictionary *)infoDict infoView:(GJJIDCardScanSuccessView *)infoView;

- (void)IDCardScanSureInfoWithInfo:(NSDictionary *)infoDict;

- (void)IDCardRescan;

@end

@interface GJJIDCardScanSuccessView : UIView

- (instancetype)initWithType:(TCARD_TYPE)iCardType image:(UIImage *)cardImage;

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, weak) id <GJJIDCardScanSuccessViewDelegate> delegate;

@end
