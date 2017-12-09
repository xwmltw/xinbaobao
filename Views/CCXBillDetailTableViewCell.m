//
//  CCXBillDetailTableViewCell.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/18.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillDetailTableViewCell.h"
#import "CCXSuperViewController.h"

@implementation CCXBillDetailTableViewCell{
    UIImageView *_imageV;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_detailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.separatorInset = UIEdgeInsetsMake(0, AdaptationWidth(55), 0 ,0);
        
        self.imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(0, 0, 100, 148)];
        [self addSubview:_imageV];
        _nameLabel = [[UILabel alloc]initWithFrame:CCXRectMake(110, 34, 300, 30)];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = CCXColorWithHex(@"#666666");
        _nameLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
        _timeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(450, 62, 260, 24)];
        _timeLabel.font = [UIFont systemFontOfSize:24*CCXSCREENSCALE];
        _timeLabel.textColor = CCXColorWithHex(@"#666666");
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
        _detailLabel = [[UILabel alloc]initWithFrame:CCXRectMake(110, 76, 300, 60)];
        _detailLabel.font = [UIFont systemFontOfSize:22*CCXSCREENSCALE];
        _detailLabel.textColor = CCXColorWithHex(@"#666666");
        _detailLabel.numberOfLines = 2;
        _detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_detailLabel];
    }
    return self;
}

-(void)setModel:(CCXBillDetailModel *)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.nodeContent?model.nodeContent:@""];
    _detailLabel.text = [NSString stringWithFormat:@"%@", model.detail?model.detail:@""];
    _timeLabel.text = [NSString stringWithFormat:@"%@", model.happendTime?model.happendTime:@""];
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
