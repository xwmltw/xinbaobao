//
//  CCXBillPayTableViewCell.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCXBillPayModel.h"

@interface CCXBillPayTableViewCell : UITableViewCell
@property(nonatomic,strong)CCXBillPayModel *model;
@property(nonatomic,strong)UIButton *button;
@end
