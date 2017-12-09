//
//  GJJDropBankNameView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/11/2.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJDropBankNameView.h"
#import "GJJBankModel.h"

@interface GJJDropBankNameView ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView *dropTableView;

@end

@implementation GJJDropBankNameView

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _dropTableView = [[UITableView alloc]init];
    [self addSubview:_dropTableView];
    
    return self;
}

- (void)setBankArray:(NSMutableArray *)bankArray
{
    _bankArray = bankArray;
    [_dropTableView reloadData];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    _dropTableView.layer.cornerRadius = _cornerRadius;
    _dropTableView.layer.masksToBounds = YES;
}

- (void)setIsNeedSeparator:(BOOL)isNeedSeparator
{
    _isNeedSeparator = isNeedSeparator;
    if (!_isNeedSeparator) {
        _dropTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    _dropTableView.delegate = self;
    _dropTableView.dataSource = self;
    [_dropTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AdaptationHeight(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    GJJBankModel *model = _bankArray[indexPath.row];
    cell.detailTextLabel.text = model.bankName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GJJBankModel *model = _bankArray[indexPath.row];
    if (self.returnBank) {
        self.returnBank(model);
    }
    [self removeFromSuperview];
}

@end
