//
//  CCXBillPayModel.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCXBillPayModel : NSObject

@property(nonatomic,copy)NSString *instalmentplanTitle;
@property(nonatomic,copy)NSString *expirationDateTitle;
@property(nonatomic,copy)NSString *instalmentplanCash;
@property(nonatomic,copy)NSString *expirationDateReminder;
@property(nonatomic,copy)NSString *repayDetailId;
@property(nonatomic,copy)NSString *status;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
