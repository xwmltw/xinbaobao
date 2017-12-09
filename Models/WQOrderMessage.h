//
//  WQOrderMessage.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/1/12.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQOrderMessage : NSObject

/*
 "publishTime": "2017-01-13 11:44:02.0",
 "comtent": "你于2017-01-13在莫愁花申请400元借款,审核通过后会及时对你尾号为0421的账号进行打款",
 "isPay": "false",
 "withDrawId": "55",
 "isRead": "1",
 "mesId": "89",
 "title": "提现申请通知"
 */

@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *comtent;
@property (nonatomic, copy) NSString *isPay;
@property (nonatomic, copy) NSString *withDrawId;
@property (nonatomic, copy) NSString *isRead;
@property (nonatomic, copy) NSString *mesId;
@property (nonatomic, copy) NSString *title;

@end
