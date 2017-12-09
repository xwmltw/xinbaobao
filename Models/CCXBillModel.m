//
//  CCXBillModel.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillModel.h"

@implementation CCXBillModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.lastLoanTime = dict[@"lastLoanTime"];
        self.type = dict[@"type"];
        self.size = dict[@"size"];
    }
    return self;
}

@end
