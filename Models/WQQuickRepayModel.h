//
//  WQQuickRepayModel.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/2/6.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQQuickRepayModel : NSObject

/*
 1.还款总额
 2.每一期还款额度
 3.还款期限
 4.应还日期
 5.还款明细日期
 "totalAmt"
 "shouldPayDate": "2017-01-22",
 "shouldPayAmt": "313.50",
 "repayDetailId": "38",
 "days": "-19",
 "status": "4"
 */

@property (nonatomic, copy) NSString *shouldPayDate;
@property (nonatomic, copy) NSString *shouldPayAmt;
@property (nonatomic, copy) NSString *repayDetailId;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *status;

@end
