//
//  WQLoanSuperMarketCell.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/10/26.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQLoanSuperMarketCell.h"
#import "CCXSuperViewController.h"


@implementation WQLoanSuperMarketCell{
    UIView *_view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customView];
    }
    return self;
}


-(void)customView{
    /*
    @property (nonatomic,strong)UIImageView *org_pic_urlImageV;
    @property (nonatomic,strong)UIImageView *org_pic_url_logImageV;
    @property (nonatomic,strong)UILabel *loan_org_nameLabel;
    @property (nonatomic,strong)UILabel *org_descLabel;
     */
    
    /**大图*/
    self.org_pic_urlImageV = [[UIImageView alloc]init];
    self.org_pic_urlImageV.frame = CCXRectMake(0, 0, 750, 428);
    [self addSubview:self.org_pic_urlImageV];
    
    /**view的高度*/
    _view = [[UIView alloc]init];
    _view.frame = CCXRectMake(0, 428, 750, 147);
    _view.backgroundColor = [UIColor whiteColor];
    [self addSubview:_view];
    
    /**logo*/
    self.org_pic_url_logImageV = [[UIImageView alloc]init];
    self.org_pic_url_logImageV.frame = CCXRectMake(40, 22, 103, 103);
    [_view addSubview:self.org_pic_url_logImageV];
    
    /**公司名*/
    self.loan_org_nameLabel = [[UILabel alloc]init];
    self.loan_org_nameLabel.frame = CCXRectMake(168, 38, 180, 40);
    self.loan_org_nameLabel.adjustsFontSizeToFitWidth = YES;
    self.loan_org_nameLabel.textColor = CCXMainColor;
    self.loan_org_nameLabel.font = [UIFont boldSystemFontOfSize:34*CCXSCREENSCALE];
    [_view addSubview:self.loan_org_nameLabel];
    
    /**公司描述*/
    self.org_descLabel = [[UILabel alloc]init];
    self.org_descLabel.frame = CCXRectMake(168, 98, 750-168, 30);

    self.org_descLabel.adjustsFontSizeToFitWidth = YES;
    self.org_descLabel.textColor = CCXColorWithHex(@"#909090");
    self.org_descLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    [_view addSubview:self.org_descLabel];
}


-(void)setModel:(WQLoanSuperMarketModel *)model{
    [self.org_pic_urlImageV setImageWithURL:[NSURL URLWithString:model.org_pic_url] placeholderImage:[UIImage imageNamed:@""]];
    [self.org_pic_url_logImageV setImageWithURL:[NSURL URLWithString:model.org_pic_url_log] placeholderImage:[UIImage imageNamed:@""]];
    NSLog(@"%f,%f",self.org_pic_urlImageV.image.size.width,self.org_pic_urlImageV.image.size.height);

    self.loan_org_nameLabel.text = [NSString stringWithFormat:@"< %@ >",model.loan_org_name];
    self.org_descLabel.text = [NSString stringWithFormat:@"“%@”",model.org_desc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
