//
//  FirstViewController.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/11/3.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "FirstViewController.h"
#import "DetailViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIScrollView *scroView = [[UIScrollView alloc]init];
    
    scroView.delegate = self;
    scroView.showsHorizontalScrollIndicator = NO;
    scroView.showsVerticalScrollIndicator = NO;
    [scroView setPagingEnabled:YES];
    [scroView setBounces:NO];
    [scroView setContentSize:CGSizeMake(SCREEN_WIDTH *2, 0)];
    
    UIImageView *image1 = [[UIImageView alloc]init];
    [image1 setImage:[UIImage imageNamed:@"jinrong"]];
    
    UIImageView *image2 = [[UIImageView alloc]init];
    [image2 setImage:[UIImage imageNamed:@"jinrong2"]];
    for (int i = 0; i<2; i++) {
        if (i == 0) {
            image1.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 200);
            [scroView addSubview:image1];
        }else{
           image2.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 200);
            [scroView addSubview:image2];
        }
    }
    return scroView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"易宪容:未来有更多利好的金融政策会推出";
            cell.detailTextLabel.text = @"发布时间： 2017-11-9";
            break;
        case 1:
            cell.textLabel.text = @"防范金融风险重在健全监管体系";
            cell.detailTextLabel.text = @"发布时间： 2017-11-9";
            break;
        case 2:
            cell.textLabel.text = @"比特币能挺过下次金融危机吗？";
            
            cell.detailTextLabel.text = @"发布时间： 2017-11-9";
            break;
        case 3:
            
            cell.textLabel.text = @"中国金融市场发展指明方向";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
        case 4:
            cell.textLabel.text = @"把现代金融归入产业体系发出什么信号？";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
        case 5:
            cell.textLabel.text = @"现金贷遭遇冷眼？";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
        case 6:
            cell.textLabel.text = @"现金贷和消费信贷怎能混为一谈";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
            
        case 7:
            cell.textLabel.text = @"贷款超市：闷声发大财，还是亏本赚吆喝";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
        case 8:
            cell.textLabel.text = @"上海监管部门窗口指导银行和现金贷的合作业务";
            cell.detailTextLabel.text = @"发布时间： 2017-11-10";
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [DetailViewController new];
    vc.indenx = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)headerRefresh{
    MBProgressHUD *hud = nil;
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabel.text = @"加载中...";
    
    if (hud) {
        [hud hideAnimated:YES];
    }
   
    [self.tableV.mj_header endRefreshing];
    [self.tableV.mj_footer endRefreshing];
}

-(void)footerRefresh{
    MBProgressHUD *hud = nil;
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabel.text = @"加载中...";
    
    if (hud) {
        [hud hideAnimated:YES];
    }
     [self.tableV.mj_header endRefreshing];
     [self.tableV.mj_footer endRefreshing];
}
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
