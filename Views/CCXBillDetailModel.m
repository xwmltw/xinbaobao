
//
//  CCXBillDetailModel.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillDetailModel.h"

@implementation CCXBillDetailModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.nodeContent = [dict objectForKey:@"nodeContent"];
        self.happendTime = [dict objectForKey:@"happendTime"];
        self.detail = [dict objectForKey:@"detail"];
    }
    return self;
}

@end
