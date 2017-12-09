//
//  WQInteractionMessage.h
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQInteractionMessage : NSObject

/*
"h5Url": "http://115.28.242.125:8085/api/share.html?154",
"publishTime": "2016-12-31 20:00",
"isRead": "0",
"messageId": "41",
"title": "奖",
"content": "1月1日，中央气象台继续发布霾橙色预警：预计，2日8时至3日8时，北京东南部、天津、河北东部和中南部、河南大部、山东大部、山西中南部、陕西关中、安徽中北部、江苏西部、湖北中部、湖南北部、辽宁中部等地有中度霾。"
 */

@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *isRead;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *shareStatus;
@property (nonatomic, copy) NSString *type;

@end
