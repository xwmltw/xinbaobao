//
//  GJJBindCardScanSuccessView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJJBindCardScanSuccessView;

@protocol GJJBindCardScanSuccessViewDelegate <NSObject>

- (void)bankCardScanSureInfoWithDict:(NSDictionary *)dict infoView:(GJJBindCardScanSuccessView *)infoView;

- (void)bankCardRescan;

@end

@interface GJJBindCardScanSuccessView : UIView

- (instancetype)initWithImage:(UIImage *)cardImage;

@property (nonatomic, strong) NSArray *bankListArray;

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, weak) id <GJJBindCardScanSuccessViewDelegate> delegate;

@end
