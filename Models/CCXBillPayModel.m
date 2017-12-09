//
//  CCXBillPayModel.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillPayModel.h"

@implementation CCXBillPayModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.instalmentplanTitle = [NSString stringWithFormat:@"第%@期",dict[@"qs"]];
        self.expirationDateTitle = [NSString stringWithFormat:@"截止日:%@",dict[@"repayTime"]];
        self.instalmentplanCash = [NSString stringWithFormat:@"%.2f",[dict[@"amt"] floatValue]];
        self.expirationDateReminder = dict[@"days"];
        self.repayDetailId = dict[@"repayDetailId"];
        self.status = dict[@"status"];
    }
    return self;
}

@end
