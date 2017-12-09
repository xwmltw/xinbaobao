//
//  CCXBillListTableViewCell.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillListTableViewCell.h"
#import "CCXSuperViewController.h"

@implementation CCXBillListTableViewCell{
    UIImageView *_iconImage;
    UILabel *_moneyLabel;
    UILabel *_countLabel;
    UILabel *_totalLabel;
    UILabel *_monthLabel;
    UILabel *_timeLabel;
    UILabel *_goLabel;
    UILabel *_typeLabel;
    UIImageView *_typeImage;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImage = [[UIImageView alloc]initWithFrame:CCXRectMake(36, 47, 40, 40)];
        [self addSubview:_iconImage];
        
//        _moneyLabel = [[UILabel alloc]initWithFrame:CCXRectMake(82, 30, 140, 34)];
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont systemFontOfSize:34*CCXSCREENSCALE];
        _moneyLabel.textColor = CCXColorWithHex(@"#999999");
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_moneyLabel];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(245, 0, 48, 78)];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.image = [UIImage imageNamed:@"mybill_icon_stages"];
        [self addSubview:imageV];
        
        _countLabel = [[UILabel alloc]initWithFrame:CCXRectMake(5, 14, 38, 20)];
        _countLabel.font = [UIFont systemFontOfSize:20*CCXSCREENSCALE];
        _countLabel.textColor = CCXColorWithHex(@"#ffffff");
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.adjustsFontSizeToFitWidth = YES;
        [imageV addSubview:_countLabel];
        
        _totalLabel = [[UILabel alloc]initWithFrame:CCXRectMake(310, 20, 250, 26)];
        _totalLabel.textColor = CCXColorWithHex(@"#999999");
        _totalLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
        _totalLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_totalLabel];
        
        _monthLabel = [[UILabel alloc]initWithFrame:CCXRectMake(310, 56, 250, 26)];
        _monthLabel.textColor = CCXColorWithHex(@"#999999");
        _monthLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
        _monthLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_monthLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(310, 92, 250, 20)];
        _timeLabel.textColor = CCXColorWithHex(@"#999999");
        _timeLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_timeLabel];
        
        _goLabel = [[UILabel alloc]initWithFrame:CCXRectMake(580, 40, 140, 54)];
        _goLabel.textColor = [UIColor colorWithHexString:STSecondColorString];
        _goLabel.layer.borderWidth = 1.0f;
        _goLabel.layer.borderColor = [UIColor colorWithHexString:STSecondColorString].CGColor;
        _goLabel.clipsToBounds = YES;
        _goLabel.font = [UIFont systemFontOfSize:26*CCXSCREENSCALE];
        _goLabel.textAlignment = NSTextAlignmentCenter;
        _goLabel.adjustsFontSizeToFitWidth = YES;
        _goLabel.layer.cornerRadius = 27*CCXSCREENSCALE;
        _goLabel.clipsToBounds = YES;
        [self addSubview:_goLabel];
        
//        _typeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(110, 75, 80, 24)];
//        _typeLabel.font = [UIFont systemFontOfSize:24*CCXSCREENSCALE];
//        [self addSubview:_typeLabel];
//        
//        _typeImage = [[UIImageView alloc]initWithFrame:CCXRectMake(82, 75, 24, 24)];
//        [self addSubview:_typeImage];
    }
    return self;
}

-(void)setModel:(CCXBillListModel *)model{
    
    if ([model.isDelay isEqualToString:@"逾期"] || [model.isDelay isEqualToString:@"正常"]) {
        _moneyLabel.frame = CCXRectMake(82, 30, 140, 34);
        _typeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(110, 75, 80, 24)];
        _typeLabel.font = [UIFont systemFontOfSize:24*CCXSCREENSCALE];
        [self addSubview:_typeLabel];
        
        _typeImage = [[UIImageView alloc]initWithFrame:CCXRectMake(82, 75, 24, 24)];
        [self addSubview:_typeImage];
        
        _typeImage.image = [UIImage imageNamed:model.isDelay];
        _typeLabel.text = model.isDelay;
    }else{
        _moneyLabel.frame = CCXRectMake(82, 42, 140, 50);
    }
    
    _iconImage.image = [UIImage imageNamed:@"mybill_icon_goldbag"];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%.f",[model.borrowAmt floatValue]];
    _countLabel.text = model.perions;
    _totalLabel.text = [NSString stringWithFormat:@"到账金额：%@",model.actualAmt];
    _monthLabel.text =[NSString stringWithFormat:@"每月还款：%@",model.monthPay];
    _timeLabel.text = [NSString stringWithFormat:@"借款日：%@",model.borrowTime];
    _goLabel.backgroundColor = [UIColor whiteColor];
    if ([model.isDelay isEqualToString:@"逾期"]) {
        _typeLabel.textColor = CCXColorWithHex(@"ff0000");
    }else if ([model.isDelay isEqualToString:@"正常"]){
        _typeLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
    }
//    _typeImage.image = [UIImage imageNamed:model.isDelay];
//    _typeLabel.text = model.isDelay;
    switch ([[[NSUserDefaults standardUserDefaults] objectForKey:CCXBillType] intValue]) {
        case 0:{_goLabel.text = @"去还款";}break;
        case 1:
        {
            if ([model.waitingLoan integerValue] == 0) {
                _goLabel.text = @"审核进度";
            }else {
                _goLabel.text = @"等待放款";
            }
        }
            break;
        case 2:{_goLabel.text = @"结清证明";}break;
        case 3:{_goLabel.text = @"驳回原因";}break;
        case 4:{_goLabel.text = @"等待签字";}break;
        default:break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
