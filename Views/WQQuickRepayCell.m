//
//  WQQuickRepayCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2017/2/6.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "WQQuickRepayCell.h"
#import "CCXSuperViewController.h"
#import "Masonry.h"

@implementation WQQuickRepayCell{
    UIImageView *_checkImageV;
    UIImageView *_remarkImageV;
    UILabel     *_repayTitleLabel;
    UILabel     *_repayDeadlineTitle;
    UILabel     *_repayDateTitle;
    UILabel     *_repayTitle;
    UILabel     *_repayDeadLine;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customView];
    }
    return self;
}

- (void)customView{
    
    //勾选框
    _checkImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _checkImageV.image = [UIImage imageNamed:@"check"];
    [self addSubview:_checkImageV];
    [_checkImageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(40*CCXSCREENSCALE);
        make.left.equalTo(self).offset(30*CCXSCREENSCALE);
        make.width.equalTo(40*CCXSCREENSCALE);
    }];

    //标记还款情况
    _remarkImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    //需要判断添加逾期标识还是还款标识
    [self addSubview:_remarkImageV];
    [_remarkImageV makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(60*CCXSCREENSCALE);
        make.left.equalTo(_checkImageV.right).offset(45*CCXSCREENSCALE);
        make.width.equalTo(60*CCXSCREENSCALE);
    }];

    //每期还款额度
    self.repayFundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.repayFundLabel.font = [UIFont systemFontOfSize:34*CCXSCREENSCALE weight:18];
    self.repayFundLabel.textColor = CCXColorWithHex(@"#ec1111");
    [self addSubview:self.repayFundLabel];
    [self.repayFundLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_remarkImageV.right).offset(45*CCXSCREENSCALE);
        make.width.equalTo(150*CCXSCREENSCALE);
        make.centerY.equalTo(_remarkImageV.center);
        make.height.equalTo(@60);
    }];
    
    //应还日期标题 + 应还日期
    _repayDateTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _repayDateTitle.textColor = CCXColorWithHex(@"#666666");
    _repayDateTitle.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _repayDateTitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_repayDateTitle];
    [_repayDateTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_repayFundLabel).offset(70*CCXSCREENSCALE);
        make.height.equalTo(60*CCXSCREENSCALE);
        make.right.equalTo(self.right);
        make.width.equalTo(self).multipliedBy(1.0/2);
    }];

    //还款期限标题 + 还款期限
    _repayDeadlineTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _repayDeadlineTitle.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _repayDeadlineTitle.textAlignment = NSTextAlignmentCenter;
    _repayDeadlineTitle.textColor = CCXColorWithHex(@"#666666");
    _repayDeadlineTitle.text = @"还款期限：";
    _repayDeadLine = [[UILabel alloc] initWithFrame:CGRectZero];
    _repayDeadLine.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _repayDeadLine.textColor = CCXColorWithHex(@"#666666");
    _repayDeadLine.textAlignment = NSTextAlignmentRight;
    [_repayDeadlineTitle addSubview:_repayDeadLine];
    [self addSubview:_repayDeadlineTitle];
    [_repayDeadlineTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(34*CCXSCREENSCALE);
        make.height.equalTo(60*CCXSCREENSCALE);
        make.width.equalTo(self.width).multipliedBy(1.0/3);
        make.centerX.equalTo(_repayDateTitle);
    }];
    
    [_repayDeadLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_repayDeadlineTitle);
        make.right.equalTo(_repayDeadlineTitle.right);
        make.height.equalTo(_repayDeadlineTitle);
        make.width.equalTo(70*CCXSCREENSCALE);
    }];

    //cell底部加一条线
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60*CCXSCREENSCALE);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(1*CCXSCREENSCALE);
    }];
}

-(void)setModel:(WQQuickRepayModel *)model{
    _model = model;
    _repayDeadLine.text = _model.days;
    _repayDateTitle.text = [NSString stringWithFormat:@"应还日期：%@",_model.shouldPayDate];
    self.repayFundLabel.text = model.shouldPayAmt;
}



-(void)setCellRow:(NSInteger)cellRow{
    _cellRow = cellRow;
    if ([_model.status intValue] == 4) {
        _remarkImageV.image = [UIImage imageNamed:@"进度还款"];
    }else if ([_model.status intValue] == 6){
        _remarkImageV.image = [UIImage imageNamed:@"进度逾期"];
        _repayDeadLine.textColor = [UIColor redColor];
    }
}


/**
 字符串的属性修改

 @param str 原字符串
 @param strColor 要调整的字符串的颜色
 @param strFont 要调整字符串的大小
 @param index 距离到某个字符串位置为止
 @return 可以继续增加
 */
-(NSMutableAttributedString *)returnChangeString:(NSString *)str strColor:(UIColor *)strColor strFont:(UIFont *)strFont index:(int)index{
    
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string]rangeOfString:[str substringToIndex:str.length -index]];
    [textColor addAttribute:NSForegroundColorAttributeName value:strColor range:rangel];
    [textColor addAttribute:NSFontAttributeName value:strFont range:rangel];
    
    return textColor;
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
