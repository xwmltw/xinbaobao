//
//  GJJHomePageModel.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/21.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJJHomePageModel : NSObject

@property (nonatomic, copy) NSString *creatAmt;

@property (nonatomic, copy) NSString *levle;

@property (nonatomic, copy) NSString *rrhRate;

@property (nonatomic, copy) NSString *shouldPayAmt;

@property (nonatomic, copy) NSString *useAmt;

@property (nonatomic, copy) NSString *xiaofeiAmt;

@property (nonatomic, copy) NSString *withId;

@property (nonatomic, copy) NSString *isVirtualNetworkOperator;

@property (nonatomic, copy) NSString *maxDayLine;//最大借款期限

@property (nonatomic, copy) NSString *minDayLine;//最小借款期限

@property (nonatomic, copy) NSString *maxBorrowAmt;//最小借款金额

@property (nonatomic, copy) NSString *minBorrowAmt;//最小借款金额
+ (instancetype)sharedInstance;
@end
