//
//  STBankInfoCell.h
//  RenRenhua2.0
//
//  Created by 孙涛 on 2017/7/31.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJJGetBankModel.h"
#import "GJJAdultCreditCardNumberModel.h"
#import "SDAutoLayout.h"

typedef void (^STCellCallback)();
@interface STBankInfoCell : UITableViewCell
@property (nonatomic,strong)UIImageView *bankIcon;//银行icon
@property (nonatomic,strong)UILabel *bankName;//银行名称
@property (nonatomic,strong)UILabel *bankType;//银行类型
@property (nonatomic,strong)UILabel *bankNumber;//银行号码
@property (nonatomic,strong)UIImageView *backgroundImageV;//背景图片

@property (nonatomic,strong)GJJGetBankModel *model;
@property (nonatomic,strong)GJJAdultCreditCardNumberModel *creditCardNumberModel;
@property (nonatomic,copy)STCellCallback callback;
@end
