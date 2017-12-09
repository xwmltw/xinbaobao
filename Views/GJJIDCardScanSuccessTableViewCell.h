//
//  GJJIDCardScanSuccessTableViewCell.h
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/4.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globaltypedef.h"
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
@class GJJIDCardScanSuccessTableViewCell;

@protocol GJJIDCardScanSuccessTableViewCellDelegate <NSObject>

//- (void)userNeedEditInfoWithCell:(GJJIDCardScanSuccessTableViewCell *)cell textField:(UITextField *)textField iCardType:(TCARD_TYPE)iCardType;

@end

@interface GJJIDCardScanSuccessTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *infoDict;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UITextField *infoText;

@property (nonatomic, weak) id <GJJIDCardScanSuccessTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath iCardType:(TCARD_TYPE)iCardType;

@end

