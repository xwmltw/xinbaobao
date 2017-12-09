//
//  CCXBillPayViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/4.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXBillPayViewController.h"
#import "CCXBillPayModel.h"
#import "CCXBillPayTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CCXPopViewController.h"
#import "CCXRootWebViewController.h"
#import "YBPopupMenu.h"
@interface CCXBillPayViewController ()<UIActionSheetDelegate,CCXPopViewControllerDelegate,UIAlertViewDelegate,YBPopupMenuDelegate>

@property (nonatomic, strong) UIPopoverController *popover;

@end

@implementation CCXBillPayViewController{
    UIAlertView *_alertV;
    NSString *_totalMoney;
    NSMutableArray *_dataSourceArr;
    /**还款金额总计*/
    UILabel *_cashLabel;
    NSMutableArray *_array;
    NSString *_fuht;
    NSString *_jkht;
    NSString *_jqht;
    int ob;
}
#pragma mark - 控制器方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"快速还款"];
    
    [self setRightNaviBarButtonWithTag:10001];
    [self prepareDataWithCount:0];
//      [self addobserver];
    
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 父类方法

/**
 设置网络请求参数
 */
-(void)setRequestParams{
    if ( 0 == self.requestCount) {
        self.cmd = CCXQueryRepayDetail;
        self.dict =  @{@"withDrawId": self.billId,@"status":self.status};
    }else if (1 == self.requestCount){
        CCXUser *user = [self getSeccsion];
        self.cmd = CCXPayZfb;
        self.dict = @{@"repayIds":_array,@"userId":user.uuid};
    }
}

/**
 网络请求成功之后请求
 
 @param dict detail的详细信息
 */
-(void)requestSuccessWithDictionary:(NSDictionary *)dict{
    if (0 == self.requestCount) {
        _array = [NSMutableArray new];
        _totalMoney = @"0";
        _jkht = dict[@"jkurl"];
        _fuht = dict[@"fwurl"];
        _jqht = dict[@"jqzmurl"];
        NSArray *arr = dict[@"dataList"];
        _totalMoney = @"0";
        self.dataSourceArr = [NSMutableArray new];
        for (NSDictionary *dic in arr) {
            CCXBillPayModel *model = [[CCXBillPayModel alloc]initWithDictionary:dic];
            if ([model.status isEqualToString:@"0"]) {
                _totalMoney = [NSString stringWithFormat:@"%.2f",[_totalMoney floatValue]+[model.instalmentplanCash floatValue]];
                NSDictionary *dict = @{@"repayId":model.repayDetailId};
                [_array addObject:dict];
            }
            [self.dataSourceArr addObject:model];
        }
        [self createTableViewWithFrame:CGRectZero];
        [self.tableV makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else if (1 == self.requestCount){
        NSString *appScheme = ZFBSCHEME;
        [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"orderInfo"]fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                NSString *allString=resultDic[@"result"];
                NSString * FirstSeparateString=@"\"&";
                NSString *  SecondSeparateString=@"=\"";
                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                if ([dic[@"success"]isEqualToString:@"true"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
                }
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:returnStr=@"订单正在处理中";break;
                    case 4000:returnStr=@"订单支付失败";break;
                    case 6001:returnStr=@"订单取消";break;
                    case 6002:returnStr=@"网络连接出错";break;
                    default:break;}
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
            }
        }];
    }
}

/**
 下拉刷新
 */
-(void)headerRefresh{
    [self.tableV removeFromSuperview];
    [self prepareDataWithCount:0];
}

#pragma mark popover代理方法

-(void)popViewController:(CCXPopViewController *)con didSelectAtIndex:(int)index{
    CCXRootWebViewController *rootVC = [[CCXRootWebViewController alloc]init];
    if (index == 0) {
        rootVC.title = @"分期服务合同";
        rootVC.url = [NSString stringWithFormat:@"%@&type=3",_jkht];
    }
    [self.navigationController pushViewController:rootVC animated:YES];
}

#pragma mark TableView代理协议方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 166*CCXSCREENSCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 300*CCXSCREENSCALE;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    CCXBillPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CCXBillPayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
 
    if (self.dataSourceArr.count) {
        CCXBillPayModel *model = self.dataSourceArr[indexPath.row];
        cell.button.tag = indexPath.row+1;
        if ([model.status intValue]) {
            cell.button.selected = NO;
        }else{
            cell.button.selected = YES;
        }
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIButton *btn = (UIButton *)[self.view viewWithTag:indexPath.row+1];
    if (!btn.selected) {
        for (int i=0; i<btn.tag; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i+1];
            CCXBillPayModel *model = self.dataSourceArr[i];
            model.status = @"0";
            if (!button.selected) {
                button.selected = YES;
                _totalMoney = [NSString stringWithFormat:@"%.2f",[_totalMoney floatValue]+[model.instalmentplanCash floatValue]];
                NSDictionary *dict = @{@"repayId":model.repayDetailId};
                
                [_array addObject:dict];
            }
        }
    }else{
        for (int i=(int)btn.tag; i<=self.dataSourceArr.count; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CCXBillPayModel *model = self.dataSourceArr[i-1];
            model.status = @"1";
            if (button.selected) {
                button.selected = NO;
                _totalMoney = [NSString stringWithFormat:@"%.2f",[_totalMoney floatValue]-[model.instalmentplanCash floatValue]];
                NSDictionary *dict = @{@"repayId":model.repayDetailId};
                [_array removeObject:dict];
            }
        }
    }
    [self.tableV reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataSourceArr.count) {
        UIView *footView = [[UIView alloc]initWithFrame:CCXRectMake(0, 0, 750, 120)];

        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CCXRectMake(0, 10, 425, 24)];
        titleLabel.text = @"还款金额总计:";
//        titleLabel.font = [UIFont systemFontOfSize:24];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [footView addSubview:titleLabel];
        
        _cashLabel = [[UILabel alloc]initWithFrame:CCXRectMake(425, 10, 235, 24)];
        [footView addSubview:_cashLabel];
        _cashLabel.text = [NSString stringWithFormat:@"%@元",_totalMoney];
        _cashLabel.textAlignment = NSTextAlignmentLeft;
        _cashLabel.textColor = CCXColorWithHex(@"#ff5a00");
        
        UIButton *repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repayBtn.frame = CCXRectMake(115, 59, 520, 64);
        repayBtn.layer.cornerRadius = 10*CCXSCREENSCALE;
        repayBtn.clipsToBounds = YES;
        repayBtn.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
        [repayBtn setTitle:@"立刻还款" forState:UIControlStateNormal];
        [repayBtn setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
        repayBtn.titleLabel.font = [UIFont systemFontOfSize:30*CCXSCREENSCALE];
        repayBtn.tag = -1;
        [repayBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:repayBtn];
        return footView;
    }
    return nil;
}

#pragma mark - alertView代理协议方法

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 自定义方法

/**
 *  支付宝返回字段解析
 *
 *  @param AllString            字段
 *  @param FirstSeparateString  第一个分离字段的词
 *  @param SecondSeparateString 第二个分离字段的词
 *
 *  @return 返回字典
 */
-(NSMutableDictionary *)setComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
    }
    return dic;
}

/**
 设置导航栏右按钮
 
 @param tag 按钮的tag值
 */
-(void)setRightNaviBarButtonWithTag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-30, 64, 60, 30);
    [button setTitle:@"合同" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.tag = tag;
    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem =item;

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 64, 64, 0);
//    [button setTitle:@"合同" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    button.tag = tag;
//    [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem =item;
}

/**
 按钮的点击事件
 
 @param btn 被点击的按钮
 */
-(void)onButtonClick:(UIButton *)btn{
    if (10001 == btn.tag) {//导航栏右按钮
        [self createPopoverViewWithView:btn];
    }else if (-1 == btn.tag){//立即还款按钮
        if ([_totalMoney floatValue]<=0) {
            [self setHudWithName:@"还款金额不能为零" Time:0.5 andType:3];
            return;
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"-选择支付方式-" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
        [alertController addAction:cancelAction];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"支付宝支付" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (!ob) {
               [self addobserver];
                ob++;
            }
            [self prepareDataWithCount:1];
                }];
        [alertController addAction:moreAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/**
 创建popVIew
 */
-(void)createPopoverViewWithView:(UIButton *)button{
    [YBPopupMenu showRelyOnView:button titles:@[@"分期服务合同"] icons:nil menuWidth:AdaptationWidth(130) delegate:self];

//    CCXPopViewController *popVC = [[CCXPopViewController alloc]initWithPopView:nil orBaritem:self.navigationItem.rightBarButtonItem];
//    popVC.listsArr = @[@"分期服务合同"];
//    popVC.delegate = self;
//    [self presentViewController:popVC animated:YES completion:nil];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    CCXRootWebViewController *rootVC = [[CCXRootWebViewController alloc]init];
    if (index == 0) {
        rootVC.title = @"分期服务合同";
        rootVC.url = [NSString stringWithFormat:@"%@&type=3",_jkht];
    }
    [self.navigationController pushViewController:rootVC animated:YES];
}

/**
 添加观察者
 */
-(void)addobserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySucesss:) name:@"AliPaySucceed" object:nil];
}

/**
 支付宝支付成功回调

 @param notificion 支付宝支付成功
 */
-(void)paySucesss:(NSNotification *)notificion{
    if ([notificion.userInfo[@"success"] isEqualToString:@"支付成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self setHudWithName:notificion.userInfo[@"success"] Time:1 andType:2];
    }
}

@end
