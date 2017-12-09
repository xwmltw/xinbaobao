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
#import "WQSystemMessage.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger,WQQueryOneMessageRequest){
    WQQueryOneMessageByMesIdRequest
};


@interface WQMessageDetailViewController (){
    WQMessageDetail *_model;
    UITextView      *_textView;
    UIImageView     *_imageV;
    WQLabel         *_label;
}


@end

@implementation WQMessageDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareDataWithCount:WQQueryOneMessageByMesIdRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /**创建tableView*/
//    [self createTableViewWithFrame:CGRectZero];
//    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif
//
//-(void)headerRefresh{
//    [self prepareDataWithCount:WQQueryOneMessageByMesIdRequest];
//}


/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：-1 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button{
    if (self.blockMesId) {
        self.blockMesId(self.messageId);
    }
    [self.navigationController popViewControllerAnimated:YES];;
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    NSString *uuidStr = [self getUUID];
    if (self.requestCount == WQQueryOneMessageByMesIdRequest) {
        self.cmd = WQQueryOneMessageByMesId;
        if ([user.userId intValue] == -100) {
            self.dict = @{@"phoneId":uuidStr,
                          @"mesId": self.messageId};
        }else{
            self.dict = @{@"userId":user.userId,@"phoneId":uuidStr,
                          @"mesId": self.messageId};
        }
        
      
    }
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    _model = [WQMessageDetail yy_modelWithDictionary:dict];
     [self setUI];
//    [self.tableV reloadData];
}

/**
 网络请求失败之后的结果
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
   
}

//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return self.view.bounds.size.height;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
//}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
- (void)setUI{
//    if (_model) {
        UIView *headerView = [[UIView alloc]initWithFrame:self.view.bounds];
        headerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headerView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [headerView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:35*CCXSCREENSCALE];
        titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        titleLabel.text = _model.title;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(@(AdaptationWidth(20)));
            make.right.equalTo(headerView).offset(@(AdaptationWidth(-20)));
            make.top.equalTo(headerView).offset(@(AdaptationHeight(23)));
            make.height.equalTo(@(AdaptationHeight(20)));
        }];


        UILabel *timeLabel = [[UILabel alloc]init];
        [headerView addSubview:timeLabel];
        timeLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.text = _model.publishTime;
        [timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(titleLabel);
            make.top.equalTo(titleLabel.bottom).offset(@(AdaptationHeight(15)));
        }];
       
        UILabel *teamLabel = [[UILabel alloc]init];
        [headerView addSubview:teamLabel];
//        teamLabel.text = [NSString stringWithFormat:@"%@团队",APPDEFAULTNAME];
        teamLabel.text = @"管理员";
        teamLabel.textColor = [UIColor colorWithHexString:@"999999"];
        teamLabel.font = [UIFont systemFontOfSize:28*CCXSCREENSCALE];
        [teamLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(timeLabel);
            make.top.equalTo(timeLabel.bottom).offset(@(AdaptationHeight(10)));
        }];
        
        UIImageView *contentImageView = [[UIImageView alloc]init];
        [headerView addSubview:contentImageView];
        contentImageView.image = [UIImage imageNamed:@"系统消息详情背景"];
        [contentImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(teamLabel.bottom).offset(@(19));
            make.left.equalTo(headerView).offset(@(AdaptationWidth(22)));
            make.right.equalTo(headerView).offset(@(AdaptationWidth(-22)));
            make.bottom.equalTo(headerView).offset(@(AdaptationHeight(-44)));
        }];
        
        UILabel *contentTilteLabel = [[UILabel alloc]init];
        [contentImageView addSubview:contentTilteLabel];
        contentTilteLabel.text = @"尊敬的用户：";
        contentTilteLabel.textColor = [UIColor colorWithHexString:@"666666"];
        contentTilteLabel.font = [UIFont systemFontOfSize:35*CCXSCREENSCALE];
        [contentTilteLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentImageView).offset(@(AdaptationWidth(15)));
            make.right.equalTo(contentImageView).offset(@(AdaptationWidth(-15)));
            make.top.equalTo(contentImageView).offset(@(AdaptationHeight(22)));
            make.height.equalTo(@(AdaptationHeight(20)));
        }];
        
        UITextView *contentTextView = [[UITextView alloc]init];
//        contentTextView.scrollEnabled = YES;
    
        [headerView addSubview:contentTextView];
        //首行缩进
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;    //行间距
        paragraphStyle.firstLineHeadIndent = 2*28*CCXSCREENSCALE;    /**首行缩进宽度*/
        paragraphStyle.alignment = NSTextAlignmentJustified;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:28*CCXSCREENSCALE],
                                     NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
    contentTextView.attributedText = [[NSAttributedString alloc] initWithString:_model.comtent?:@"" attributes:attributes];
//        contentTextView.editable = NO;
    contentTextView.text = _model.comtent;

//

        [contentTextView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentImageView).offset(@(AdaptationWidth(18)));
            make.right.equalTo(contentImageView).offset(@(AdaptationWidth(-18)));
            make.top.equalTo(contentTilteLabel.bottom).offset(@(AdaptationHeight(10)));
            make.bottom.equalTo(contentImageView).offset(@(AdaptationHeight(-10)));
           
        }];
//    contentTextView.contentSize = sizeToFit;
    
    
//        return headerView;
//    }
//    return nil;
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
