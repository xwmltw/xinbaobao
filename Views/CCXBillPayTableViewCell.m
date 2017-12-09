//
//  CCXBillPayTableViewCell.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillPayTableViewCell.h"
#import "CCXSuperViewController.h"
#import "SDAutoLayout.h"
@implementation CCXBillPayTableViewCell{
    /**分期数*/
    UILabel *_instalmentplanTitleLabel;
    /**分期额度*/
    UILabel *_instalmentplanCashLabel;
    /**截止日期*/
    UILabel *_expirationDateTitleLabel;
    /**还款提醒*/
    UILabel *_expirationDateReminderLabel;
    /**cell上的view*/
    UIView *_view;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = CCXColorWithHex(@"#F2F2F2");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
        
    }
    return self;
}

-(void)setupView{
    _view = [[UIView alloc]initWithFrame:CCXRectMake(0, 10, 750, 146)];
    _view.layer.backgroundColor = CCXCGColorWithHex(@"#FFFFFF");
    _view.userInteractionEnabled = YES;
    [self.contentView addSubview:_view];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        self.button.frame = CCXRectMake(36, 52, 42, 42);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.button setBackgroundImage:[[UIImage imageNamed:@"hikuan_select"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch] forState:UIControlStateSelected];
    [self.button setBackgroundImage:[[UIImage imageNamed:@"universal_reg_normal"] resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_view addSubview:self.button];
    
    //        _instalmentplanTitleLabel = [[UILabel alloc]initWithFrame:CCXRectMake(148, 20, 300, 30)];
    _instalmentplanTitleLabel = [UILabel new];
    _instalmentplanTitleLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _instalmentplanTitleLabel.textAlignment = NSTextAlignmentLeft;
    _instalmentplanTitleLabel.textColor = CCXColorWithHex(@"#999999");
    [_view addSubview:_instalmentplanTitleLabel];
    
    //        _instalmentplanCashLabel = [[UILabel alloc]initWithFrame:CCXRectMake(128, 90, 300, 30)];
    _instalmentplanCashLabel = [UILabel new];
    _instalmentplanCashLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _instalmentplanCashLabel.textAlignment = NSTextAlignmentLeft;
    _instalmentplanCashLabel.textColor = CCXColorWithHex(@"#666666");
    //        _instalmentplanCashLabel.adjustsFontSizeToFitWidth = YES;
    [_view addSubview:_instalmentplanCashLabel];
    
    //        _expirationDateTitleLabel = [[UILabel alloc]initWithFrame:CCXRectMake(450, 20, 222, 20)];
    _expirationDateTitleLabel = [UILabel new];
    _expirationDateTitleLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    _expirationDateTitleLabel.textColor = CCXColorWithHex(@"#999999");
    _expirationDateTitleLabel.textAlignment = NSTextAlignmentRight;
    [_view addSubview:_expirationDateTitleLabel];
    
    //        _expirationDateReminderLabel = [[UILabel alloc]initWithFrame:CCXRectMake(450, 90, 222, 28)];
    _expirationDateReminderLabel = [UILabel new];
    _expirationDateReminderLabel.textColor = CCXColorWithHex(@"#FF5A00");
    _expirationDateReminderLabel.textAlignment = NSTextAlignmentRight;
    _expirationDateReminderLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
    [_view addSubview:_expirationDateReminderLabel];
    
    //
    _view.sd_layout
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,10*CCXSCREENSCALE)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView,10*CCXSCREENSCALE);
    
    self.button.sd_layout
    .leftSpaceToView(_view,40*CCXSCREENSCALE)
    .centerYEqualToView(_view)
    .widthIs(40*CCXSCREENSCALE)
    .heightIs(40*CCXSCREENSCALE);
    
    _instalmentplanTitleLabel.sd_layout
    .leftSpaceToView(_button,40*CCXSCREENSCALE)
    .topSpaceToView(_view,21.5*CCXSCREENSCALE)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(30*CCXSCREENSCALE);
    
    _instalmentplanCashLabel.sd_layout
    .leftSpaceToView(_button,40*CCXSCREENSCALE)
    .bottomSpaceToView(_view,21.5*CCXSCREENSCALE)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(30*CCXSCREENSCALE);
    
    _expirationDateTitleLabel.sd_layout
    .rightSpaceToView(_view,60*CCXSCREENSCALE)
    .topSpaceToView(_view,21.5*CCXSCREENSCALE)
    .heightIs(30*CCXSCREENSCALE)
    .autoWidthRatio(0);
    [_expirationDateTitleLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    _expirationDateReminderLabel.sd_layout
    .rightSpaceToView(_view,60*CCXSCREENSCALE)
    .bottomSpaceToView(_view,21.5*CCXSCREENSCALE)
    .widthIs(200*CCXSCREENSCALE)
    .heightIs(30*CCXSCREENSCALE);

}

-(void)setModel:(CCXBillPayModel *)model{
    _instalmentplanTitleLabel.text = model.instalmentplanTitle;
    _instalmentplanCashLabel.text = [NSString stringWithFormat:@"%@元",model.instalmentplanCash];
    if (![model.status intValue]) {
        self.button.selected = YES;
    }
    _expirationDateTitleLabel.text = model.expirationDateTitle;
    _expirationDateReminderLabel.text = model.expirationDateReminder;
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
