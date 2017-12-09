//
//  CCXBillDetailViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@interface CCXBillDetailViewController : CCXNeedBackViewController

@property(nonatomic,copy)NSString *billId;
@property(nonatomic,copy)NSString *mesId;
@property(nonatomic,copy)NSString *isJump;
@property(nonatomic,copy)NSString *isPay;
@property(nonatomic,copy)NSDictionary *orderDict;
@property(nonatomic,assign)BOOL isNeedPopToRootController;

//0.还款中 1.审核 2.结清 3.驳回 4.签字
@property(nonatomic,copy)NSString *type;

@end
