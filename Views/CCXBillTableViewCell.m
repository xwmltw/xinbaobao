//
//  CCXBillTableViewCell.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillTableViewCell.h"
#import "CCXSuperViewController.h"

@implementation CCXBillTableViewCell{
    UIImageView *_imageV;
    UILabel *_typeLabel;
    UILabel *_timeLabel;
    UILabel *_numberLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 174, 130)];
        [self addSubview:_imageV];
        
        _typeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(196, 40, 350, 30)];
        _typeLabel.textColor = CCXColorWithHex(@"#666666");
        _typeLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
        [self addSubview:_typeLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(196, 80, 350, 20)];
        _timeLabel.textColor = CCXColorWithHex(@"#909090");
        _timeLabel.font = [UIFont systemFontOfSize:20*CCXSCREENSCALE];
        [self addSubview:_timeLabel];
        
        _numberLabel = [[UILabel alloc]initWithFrame:CCXRectMake(620, 45, 40, 40)];
        _numberLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
        _numberLabel.layer.cornerRadius = 20*CCXSCREENSCALE;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = CCXColorWithHex(@"#ffffff");
        [self addSubview:_numberLabel];
    }
    return self;
}

-(void)setModel:(CCXBillModel *)model{
    _numberLabel.text = model.size;
    _timeLabel.text = model.lastLoanTime;
    switch ([model.type intValue]) {
        case 0:{
            _typeLabel.text = @"还款中";
            _numberLabel.layer.backgroundColor = CCXCGColorWithHex(STBillStatusColorStringFirst);
            _imageV.image = [UIImage imageNamed:@"mybill_icon_hk"];
        }break;
        case 1:{
            _typeLabel.text = @"审核中";
            _numberLabel.layer.backgroundColor = CCXCGColorWithHex(STBillStatusColorStringThird);
            _imageV.image = [UIImage imageNamed:@"mybill_icon_sh"];
        }break;
        case 2:{
            _typeLabel.text = @"已结清";
            _numberLabel.layer.backgroundColor = CCXCGColorWithHex(STBillStatusColorStringFourth);
            _imageV.image = [UIImage imageNamed:@"mybill_icon_jq"];
        }break;
        case 3:{
            _typeLabel.text = @"已驳回";
            _numberLabel.layer.backgroundColor = CCXCGColorWithHex(STBillStatusColorStringFifth);
            _imageV.image = [UIImage imageNamed:@"mybill_icon_bh"];
        }break;
        case 4:{
            _typeLabel.text = @"待签字";
            _numberLabel.layer.backgroundColor = CCXCGColorWithHex(STBillStatusColorStringSecond);
            _imageV.image = [UIImage imageNamed:@"mybill_icon_qz"];
        }break;
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
