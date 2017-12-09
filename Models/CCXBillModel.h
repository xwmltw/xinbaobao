//
//  CCXBillModel.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCXBillModel : NSObject

@property(nonatomic,copy)NSString *lastLoanTime;
@property(nonatomic,copy)NSString *size;
@property(nonatomic,copy)NSString *type;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
