//
//  CCXBillDetailModel.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCXBillDetailModel : NSObject

@property(nonatomic,copy)NSString *nodeContent;
@property(nonatomic,copy)NSString *happendTime;
@property(nonatomic,copy)NSString *detail;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
