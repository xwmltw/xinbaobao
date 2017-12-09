//
//  WQMessageDetailViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQMessageDetailViewController.h"
#import "WQMessageDetail.h"
#import "WQLabel.h"

@interface WQMessageDetailViewController (){
    WQMessageDetail *_model;
}

@end

@implementation WQMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:0];
}

-(void)headerRefresh{
    [self prepareDataWithCount:0];
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *secession = [self getSeccsion];
    if (self.requestCount == 0) {
        self.cmd = WQQueryOneMessageByMesId;
        self.dict = @{@"userId" :secession.userId,
                      @"mesId":self.messageId};
    }
}

/**
 网络请求成功之后的结果
 
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    [self setHudWithName:@"获取成功" Time:1 andType:0];
    _model = [WQMessageDetail yy_modelWithDictionary:dict];
    [self createTableViewWithFrame:CGRectMake(0, 64, CCXSIZE_W, CCXSIZE_H-64)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CCXSIZE_H;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = CCXBackColor;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CCXRectMake(40, 30, 670, 60)];
    
//    titleLabel.backgroundColor = [UIColor greenColor];
    
    titleLabel.font = [UIFont systemFontOfSize:35*CCXSCREENSCALE];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = _model.title;
    [headerView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CCXRectMake(40, 100, 670/2, 60)];
    timeLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    timeLabel.textColor = [UIColor grayColor];
    
//    timeLabel.backgroundColor = [UIColor blueColor];
    timeLabel.text = _model.publishTime;
    [headerView addSubview:timeLabel];
    
    UILabel *teamLabel = [[UILabel alloc]initWithFrame:CCXRectMake(40, 170, 670/2, 60)];
    teamLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    teamLabel.textColor = [UIColor grayColor];
    teamLabel.text = @"莫愁花团队";
    [headerView addSubview:teamLabel];
    
//    teamLabel.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CCXRectMake(40, 100, 670, 1000)];
    imageV.image = [UIImage imageNamed:@"系统消息详情背景"];
    [headerView addSubview:imageV];
    
    WQLabel *content = [[WQLabel alloc]initWithFrame:CCXRectMake(40, 260, 590, 600)];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: _model.comtent];
    //设置字体颜色
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;//缩进
    style.firstLineHeadIndent = 30;
    style.lineSpacing = 10;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    content.attributedText = text;
    content.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    content.numberOfLines = 0;
    [content setVerticalAlignment:VerticalAlignmentTop];
    content.lineBreakMode = kCFStringTokenizerUnitLineBreak;
    [imageV addSubview:content];
    
    WQLabel *label = [[WQLabel alloc]initWithFrame:CCXRectMake(40, 850, 590, 50)];
    label.text = @"给您带来的不便请敬请谅解!";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    [imageV addSubview:label];
    
    WQLabel *bottomLabel = [[WQLabel alloc]initWithFrame:CCXRectMake(40, 900, 590, 50)];
    NSString *srcStr = _model.publishTime;
    NSRange range = [srcStr rangeOfString:@" "];
    NSString *str = [srcStr substringToIndex:range.location];
    NSLog(@"%@",str);
    bottomLabel.text = [NSString stringWithFormat:@"莫愁花团队 %@",str];
    bottomLabel.textAlignment = NSTextAlignmentRight;
    bottomLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
    bottomLabel.textColor = [UIColor lightGrayColor];
    [imageV addSubview:bottomLabel];
    return headerView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
