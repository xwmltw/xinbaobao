//
//  WQSystemMessageCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQOrderMessageCell.h"
#import "CCXSuperViewController.h"
#import "WQMessageDetailViewController.h"
#import "Masonry/Masonry.h"

@implementation WQOrderMessageCell{
    UILabel      *_timeLabel;
    UILabel      *_contentLabel;
    UIImageView  *_imageV;
    UILabel      *_titleLabel;
    UIImageView  *_thumbImageV;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self customView];
    return self;
}

-(void)customView{
    //时间标题
    _timeLabel       = [[UILabel alloc]initWithFrame:CCXRectMake(0, 10, 750, 60)];
    [self addSubview:_timeLabel];
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font      = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _imageV               = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 80, 670, 226)];
    _imageV.userInteractionEnabled = YES;
    _imageV.image         = [UIImage imageNamed:@"消息框"];
    
    _thumbImageV = [[UIImageView alloc] init];
    
    [self addSubview:_imageV];
    //活动标题
    _titleLabel           = [[UILabel alloc]initWithFrame:CCXRectMake(80, 20, 590, 40)];
    _titleLabel.font      = [UIFont systemFontOfSize:35*CCXSCREENSCALE];
    _titleLabel.textColor = [UIColor grayColor];
    
    [_imageV addSubview:_titleLabel];
    
    self.btn = [[UIButton alloc]initWithFrame:_imageV.bounds];
    [_imageV addSubview:self.btn];
    [self.btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //活动内容
    _contentLabel         = [[UILabel alloc]initWithFrame:CCXRectMake(60, 60, 590, 100)];
    [_imageV addSubview:_contentLabel];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font      = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    _contentLabel.numberOfLines = 0;
    
}


-(void)setModel:(WQOrderMessage *)model{
    _model = model;
    MyLog(@"++++++++%@",model);
    _timeLabel.text    = model.publishTime;
    _titleLabel.text   = model.title;
    _contentLabel.text = model.comtent;
}


-(void)setCellRow:(NSInteger)cellRow{
    _cellRow = cellRow;
    [_imageV addSubview:_thumbImageV];
    if ([_model.isRead intValue] == 0) {
        _thumbImageV.image = [UIImage imageNamed:@"unreadDot"];
        _thumbImageV.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageV).offset(@(AdaptationHeight(15)));
            make.left.mas_equalTo(_imageV).offset(@(AdaptationWidth(20)));
            make.width.mas_equalTo(@(AdaptationWidth(10)));
            make.height.mas_equalTo(@(AdaptationWidth(10)));
        }];
    }else{
        [_thumbImageV removeFromSuperview];
        _titleLabel.frame = CCXRectMake(60, 20, 590, 40);
    }
}


-(void)onBtnClick:(UIButton *)btn{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(WQOrderCustomBtnClicked:)]) {
        [_delegate WQOrderCustomBtnClicked:btn];
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
