//
//  STMessageCenterCell.m
//  XianJinDaiSystem
//
//  Created by 孙涛 on 2017/9/23.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "STMessageCenterCell.h"
#import "SDAutoLayout.h"
@implementation STMessageCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    [self addSubview:self.typeLabel];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.dateLabel];
    
    [self addSubview:self.contentLabel];
    
    [self addSubview:self.seperatorLabel];
    

    //布局

    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptationWidth(16));
        make.left.mas_equalTo(self).offset(AdaptationWidth(30));
        make.width.mas_equalTo(AdaptationWidth(40));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptationWidth(16));
        make.left.mas_equalTo(_typeLabel.mas_right).offset(8);
        make.right.mas_equalTo(self).offset(-AdaptationWidth(30));
        
    }];
    [_seperatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(AdaptationWidth(30));
        make.right.mas_equalTo(self).offset(-AdaptationWidth(30));
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_seperatorLabel.mas_top).offset(AdaptationWidth(16));
        make.left.mas_equalTo(self).offset(AdaptationWidth(30));
    }];
    

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self).offset(AdaptationWidth(30));
        make.right.mas_equalTo(self).offset(-AdaptationWidth(30));
        make.bottom.mas_equalTo(_dateLabel.mas_top).offset(8);
    }];
    
    

    
}

-(void)setMessageModel:(WQInteractionMessage *)messageModel{
    _messageModel = messageModel;
    if (_messageModel) {
        
        if ([messageModel.isRead isEqualToString:@"0"]) {
            if ([messageModel.type isEqualToString:@"0"]) {
                self.typeLabel.text = @"系统";
                self.typeLabel.backgroundColor = CCXColorWithRGB(78, 142, 220);
                self.typeLabel.textColor = [UIColor whiteColor];
            }else{
                self.typeLabel.text = @"活动";
                self.typeLabel.backgroundColor = CCXColorWithRGB(41, 179, 129);
                self.typeLabel.textColor = [UIColor whiteColor];
            }
            self.titleLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.8);
            self.contentLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.48);


        }else{
            if ([messageModel.type isEqualToString:@"0"]) {
                self.typeLabel.text = @"系统";
                self.typeLabel.backgroundColor = CCXColorWithRBBA(78, 142, 220,0.16);
                self.typeLabel.textColor = [UIColor whiteColor];
            }else{
                self.typeLabel.text = @"活动";
                self.typeLabel.backgroundColor = CCXColorWithRBBA(41, 179, 129,0.16);
                self.typeLabel.textColor = [UIColor whiteColor];
                
            }
            self.titleLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.16);
            self.contentLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.16);

        }
        
        self.titleLabel.text = messageModel.title;
        self.dateLabel.text = messageModel.publishTime;
        self.contentLabel.text = messageModel.content;
    }
}




-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
//        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:AdaptationHeight(14)];
    }
    
    return _typeLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        _dateLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.48);
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}


-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 2;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _contentLabel.textColor = CCXColorWithRBBA(34, 58, 80, 0.48);
        _contentLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    }
    return _contentLabel;
}

-(UILabel *)seperatorLabel{
    if (!_seperatorLabel) {
        _seperatorLabel = [[UILabel alloc]init];
        _seperatorLabel.backgroundColor = CCXColorWithRGB(240, 240, 240);
    }
    return _seperatorLabel;
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
