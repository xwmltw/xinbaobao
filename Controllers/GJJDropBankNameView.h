//
//  GJJDropBankNameView.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GJJBankModel;

typedef void (^ReturnBankModel)(GJJBankModel *bankModel);

@interface GJJDropBankNameView : UIView

@property (nonatomic, strong) NSMutableArray *bankArray;

@property (nonatomic, copy) ReturnBankModel returnBank;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) BOOL isNeedSeparator;

@end
