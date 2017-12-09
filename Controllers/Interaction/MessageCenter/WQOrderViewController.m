//
//  WQSystemViewController.m
//  RenRenhua2.0
//
//  Created by peterwon on 2016/11/16.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "WQOrderViewController.h"
#import "WQOrderMessage.h"
#import "WQOrderMessageCell.h"
#import "WQMessageDetailViewController.h"
#import "CCXBillDetailViewController.h"
#import "CCXBillListViewController.h"
#import "CCXBillPayViewController.h"
#import "WQOrderMessage.h"

typedef NS_ENUM(NSInteger,WQQueryOneMessageRequest){
    WQQueryOneMessageMesIdRequest
};

@interface WQOrderViewController ()<WQSystemMessageCellDelegate>

@end

@implementation WQOrderViewController{
    NSMutableArray *_orderMesArr;

}


-(void)viewWillAppear:(BOOL)animated{
    [self prepareDataWithCount:WQQueryOneMessageMesIdRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderMesArr = [NSMutableArray new];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

-(void)headerRefresh{
    [self prepareDataWithCount:WQQueryOneMessageMesIdRequest];
}

#pragma mark -- 网络请求
/**
 设置网络请求的params cmd
 */
-(void)setRequestParams{
    CCXUser *user = [self getSeccsion];
    NSString *uuidStr = [self getUUID];
    if (self.requestCount == WQQueryOneMessageMesIdRequest) {
        self.cmd = WQQueryOneTypeMessage;
        self.dict = @{@"userId" :user.userId,
                      @"phoneId":uuidStr,
                      @"mesType":@"2"};
    }
}

/**
 网络请求成功之后的结果
 @param dict 网络请求成功之后返回的detail
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    MyLog(@"+++++++++++++++++%@",dict);
    
    [_orderMesArr removeAllObjects];
    NSArray *detaList = dict[@"detaList"];
    for (NSDictionary *dic in detaList) {
        WQOrderMessage *model = [WQOrderMessage yy_modelWithDictionary:dic];
//        model.isRead = @"0";
        [_orderMesArr addObject:model];
    }
    [self.tableV reloadData];
    [self setFooter];
}


/**
 网络请求失败

 @param dict 网络请求失败提示
 */
-(void)requestFaildWithDictionary:(NSDictionary *)dict{
    [super requestFaildWithDictionary:dict];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderMesArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380*CCXSCREENSCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellId";
    WQOrderMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[WQOrderMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = CCXBackColor;
        cell.delegate = self;
    }
    if (_orderMesArr.count) {
        WQOrderMessage *model = _orderMesArr[indexPath.row];
        cell.model = model;
        cell.btn.tag = indexPath.row+1;
        cell.cellRow = indexPath.row;
    }
    return cell;
}

-(void)WQOrderCustomBtnClicked:(UIButton *)button{
    WQOrderMessage *model = _orderMesArr[button.tag-1];
    CCXBillDetailViewController *billVC = [CCXBillDetailViewController new];
    billVC.title = @"订单详情";
    billVC.mesId = model.mesId;
    billVC.billId = model.withDrawId;
    billVC.isJump = @"yes";
    billVC.isPay = model.isPay;
    [self.navigationController pushViewController:billVC animated:YES];
}


-(void)setFooter{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.tableV.bounds];
    imageV.image = [UIImage imageNamed:@"无消息"];
    if (_orderMesArr.count == 0) {
        self.tableV.tableFooterView = imageV;
    }else {
        self.tableV.tableFooterView = nil;
    }
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
