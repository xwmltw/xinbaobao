//
//  CCXPopViewController.m
//  RenRenhua2.0
//
//  Created by 陈传熙 on 16/11/5.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "CCXPopViewController.h"
#import "CCXSuperViewController.h"

@interface CCXPopViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPopoverPresentationControllerDelegate>

@property(nonatomic,weak) UITableView  *listTabView;


@end

static NSInteger popViewWidth = 150;
static NSInteger heightForCell = 50;

@implementation CCXPopViewController

- (instancetype)initWithPopView:(UIView*)soureceV orBaritem:(UIBarButtonItem*)item{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        if (soureceV) {
            self.popoverPresentationController.sourceView = soureceV;
            self.popoverPresentationController.sourceRect = soureceV.bounds;
        }else{
            self.popoverPresentationController.barButtonItem = item;
        }
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.popoverPresentationController.backgroundColor = [UIColor whiteColor];
        self.popoverPresentationController.delegate =self;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    [tab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.listTabView = tab;
}
- (NSArray *)listsArr{
    if (_listsArr == nil) {
        _listsArr = @[];
    }
    return _listsArr;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heightForCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indenti = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indenti];
    }
    UILabel *textLabel = [[UILabel alloc]init];
    [cell addSubview:textLabel];
    textLabel.text = self.listsArr[indexPath.row];
    textLabel.textColor = [UIColor colorWithHexString:GJJOrangeTextColorString];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell);
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popViewController:didSelectAtIndex:)]) {
        [self.delegate popViewController:self didSelectAtIndex:(int)indexPath.row];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGSize)preferredContentSize{
    /**
     150 pop视图的宽度
     */
    return CGSizeMake(AdaptationWidth(popViewWidth), self.listsArr.count*heightForCell);
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

@end
