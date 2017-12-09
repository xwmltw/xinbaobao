//
//  CCXBillDetailTableViewCell.h
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCXBillDetailModel.h"

@interface CCXBillDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)CCXBillDetailModel *model;
@property(nonatomic,strong)UIImageView *imageV;
@end
