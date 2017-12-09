//
//  WQInteractionMessageCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQInteractionMessageCell.h"
#import "CCXSuperViewController.h"

@implementation WQInteractionMessageCell{
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIImageView *_imageV;
    UILabel *_titleLabel;
    UIImageView  *_thumbImageV;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self customView];
    return self;
}

-(void)customView{
    _timeLabel       = [[UILabel alloc]initWithFrame:CCXRectMake(0, 10, 750, 60)];
    [self addSubview:_timeLabel];
    
    //    _timeLabel.backgroundColor = [UIColor redColor];
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font      = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _imageV               = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 80, 670, 226)];
    _imageV.userInteractionEnabled = YES;
    _imageV.image         = [UIImage imageNamed:@"消息框"];
    
    _thumbImageV = [[UIImageView alloc] init];
    
    [self addSubview:_imageV];
    _titleLabel           = [[UILabel alloc]initWithFrame:CCXRectMake(80, 20, 590, 60)];
    _titleLabel.font      = [UIFont systemFontOfSize:35*CCXSCREENSCALE];
    _titleLabel.textColor = [UIColor grayColor];
    
    //    _titleLabel.backgroundColor = [UIColor greenColor];
    
    [_imageV addSubview:_titleLabel];
    
    self.btn = [[UIButton alloc]initWithFrame:_imageV.bounds];
    [_imageV addSubview:self.btn];
    [self.btn addTarget:self action:@selector(onbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentLabel         = [[UILabel alloc]initWithFrame:CCXRectMake(60, 80, 590, 100)];
    [_imageV addSubview:_contentLabel];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font      = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    //设置行距
    //    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    style.lineSpacing = 20;//行距
    //    [_contentLabel.text ];
    //    _contentLabel.backgroundColor = [UIColor yellowColor];
    
    _contentLabel.numberOfLines = 0;
}

-(void)setCellRow:(NSInteger)cellRow{
    _cellRow = cellRow;
    [_imageV addSubview:_thumbImageV];
    if ([_model.isRead intValue] == 0) {
        _thumbImageV.image = [UIImage imageNamed:@"unreadDot"];
        _thumbImageV.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageV).offset(@(AdaptationHeight(20)));
            make.left.mas_equalTo(_imageV).offset(@(AdaptationWidth(20)));
            make.width.mas_equalTo(@(AdaptationWidth(10)));
            make.height.mas_equalTo(@(AdaptationWidth(10)));
        }];
    }else{
        [_thumbImageV removeFromSuperview];
        _titleLabel.frame = CCXRectMake(60, 20, 590, 60);
    }
}

-(void)setModel:(WQInteractionMessage *)model{
    _model = model;
    _timeLabel.text    = model.publishTime;
    _titleLabel.text   = model.title;
    _contentLabel.text = model.content;
    
}

-(void)onbtnClick:(UIButton *)btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(WQInteractionCustomBtnClicked:)]) {
        [_delegate WQInteractionCustomBtnClicked:btn];
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

