//
//  GJJBillDetailModel.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/9.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJJBillDetailModel : NSObject

@property (nonatomic, copy) NSString *actualAmt;

@property (nonatomic, copy) NSString *bankNum;

@property (nonatomic, copy) NSString *borrowAmt;

@property (nonatomic, strong) NSArray *detaList;

@property (nonatomic, copy) NSString *fwurl;

@property (nonatomic, copy) NSString *isPay;

@property (nonatomic, copy) NSString *jkurl;

@property (nonatomic, copy) NSString *jqzmurl;

@property (nonatomic, copy) NSString *monthPay;

@property (nonatomic, copy) NSString *orderExplanin;

@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, copy) NSString *perions;

@property (nonatomic, copy) NSString *status;

@end
