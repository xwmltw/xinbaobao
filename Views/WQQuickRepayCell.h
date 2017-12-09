  //
//  WQQuickRepayCell.h
//  RenRenhua2.0
//
//  Created by peterwon on 2017/2/6.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQQuickRepayModel.h"

@interface WQQuickRepayCell : UITableViewCell

/*
 1. repayFundLabel
 2. deadlineLabel
 3. repayDateLabel
 4. repayDetailDateLabel
 */

@property (nonatomic, strong) UILabel *repayFundLabel;
@property (nonatomic, strong) UILabel *repayDetailDateLabel;
@property (nonatomic, strong) WQQuickRepayModel *model; 
@property (nonatomic, assign) NSInteger cellRow;

@end
