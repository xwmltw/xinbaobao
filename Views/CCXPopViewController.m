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

@implementation CCXPopViewController

- (instancetype)initWithPopView:(UIView*)soureceV orBaritem:(UIBarButtonItem*)item{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        if (soureceV) {
            self.popoverPresentationController.sourceView = soureceV;
            self.popoverPresentationController.sourceRect = soureceV.bounds;
        }else{
            self.popoverPresentationController.barButtonItem = item;}
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.popoverPresentationController.backgroundColor = [UIColor whiteColor];
        self.popoverPresentationController.delegate =self;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tab = [UITableView new];
    tab.delegate = self;
    tab.dataSource = self;
    tab.frame = self.view.bounds;
    [self.view addSubview:tab];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indenti = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indenti];
    }
    cell.textLabel.text = self.listsArr[indexPath.row];
    cell.textLabel.textColor = CCXMainColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popViewController:didSelectAtIndex:)]) {
        [self.delegate popViewController:self didSelectAtIndex:(int)indexPath.row];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGSize)preferredContentSize{
    /**
     150 pop视图的宽度
     */
    return CGSizeMake(100, self.listsArr.count*50);
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

@end
