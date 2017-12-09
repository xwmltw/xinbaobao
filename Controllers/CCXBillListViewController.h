//
//  CCXBillListViewController.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXNeedBackViewController.h"

@interface CCXBillListViewController : CCXNeedBackViewController

//0.还款中 1.审核 2.结清 3.驳回 4.签字
@property(nonatomic,copy)NSString *type;


@end
