//
//  GJJBindCardScanSuccessView.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2016/12/15.
//  Copyright © 2016年 chenchuanxi. All rights reserved.
//

#import "GJJBindCardScanSuccessView.h"
#import "UITextField+ExtendRange.h"
#import "CCXSuperViewController.h"
#import "GJJBankModel.h"
#import "GJJChoosePickerView.h"

typedef NS_ENUM(NSInteger, GJJBindCardScanSuccessRequest) {
    GJJBindCardScanSuccessRequestBankList,
};

@interface GJJBindCardScanSuccessView ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
GJJChoosePickerViewDelegate>

@end

@implementation GJJBindCardScanSuccessView
{
    UITableView *_infoTableView;
    UITextField *_cardNumberText;
//    UITextField *_bankNameText;
    UILabel *_bankNameLabel;
    UIButton *_cardNumberButton;
    UIButton *_bankNameButton;
    
    GJJChoosePickerView *_chooseBankPickerView;
}

- (instancetype)initWithImage:(UIImage *)cardImage
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setupViewWithImage:cardImage];
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    [_infoTableView reloadData];
}

- (void)setupViewWithImage:(UIImage *)cardImage
{
    self.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
    
    UIView *IDCardView = [[UIView alloc]init];
    [self addSubview:IDCardView];
    IDCardView.backgroundColor = [UIColor whiteColor];
    IDCardView.layer.cornerRadius = AdaptationWidth(10);
    IDCardView.layer.masksToBounds = YES;
    [IDCardView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(@(AdaptationWidth(25)));
        make.right.equalTo(self).offset(@(AdaptationWidth(-25)));
        make.height.equalTo(self).multipliedBy(0.3);
    }];
    
    UIImageView *IDCardImageView = [[UIImageView alloc]init];
    [IDCardView addSubview:IDCardImageView];
    IDCardImageView.image = cardImage;
    IDCardImageView.contentMode = UIViewContentModeScaleAspectFit;
    [IDCardImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(IDCardView).insets(UIEdgeInsetsMake(AdaptationHeight(15), AdaptationWidth(25), AdaptationHeight(15), AdaptationWidth(25)));
    }];
    
    UIView *hintView = [[UIView alloc]init];
    [self addSubview:hintView];
    hintView.backgroundColor = [UIColor clearColor];
    [hintView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDCardView.bottom);
        make.left.right.equalTo(IDCardView);
        make.height.equalTo(@(AdaptationHeight(32)));
    }];
    
    UIImageView *hintImageView = [[UIImageView alloc]init];
    [hintView addSubview:hintImageView];
    hintImageView.image = [UIImage imageNamed:@"身份认证提示"];
    [hintImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hintView);
        make.left.equalTo(hintView);
        make.size.equalTo(CGSizeMake(AdaptationWidth(12), AdaptationWidth(12)));
    }];
    
    UILabel *hintLabel = [[UILabel alloc]init];
    [hintView addSubview:hintLabel];
    hintLabel.text = @"请核对卡号和签发行信息，确认无误";
    hintLabel.font = [UIFont systemFontOfSize:AdaptationWidth(13)];
    hintLabel.textColor = [UIColor colorWithHexString:@"f69a58"];
    hintLabel.adjustsFontSizeToFitWidth = YES;
    [hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hintImageView.right).offset(@(AdaptationWidth(5)));
        make.right.equalTo(hintView);
        make.top.bottom.equalTo(hintView);
    }];
    
    UIView *infoView = [[UIView alloc]init];
    [self addSubview:infoView];
    infoView.backgroundColor = [UIColor whiteColor];
    [infoView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintView.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@(AdaptationHeight(100)));
    }];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [infoView addSubview:_infoTableView];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _infoTableView.bounces = NO;
    _infoTableView.scrollEnabled = NO;
    [_infoTableView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(infoView);
        make.height.equalTo(@(AdaptationHeight(36 * 2)));
        make.left.equalTo(infoView).offset(@(AdaptationWidth(35)));
        make.right.equalTo(infoView).offset(@(AdaptationWidth(-35)));
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureButton];
    sureButton.backgroundColor = [UIColor colorWithHexString:STBtnBgColor];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(18)];
    [sureButton setTitleColor:[UIColor colorWithHexString:STBtnTextColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = AdaptationWidth(4);
    sureButton.layer.masksToBounds = YES;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.bottom).offset(@(AdaptationHeight(60)));
        make.left.equalTo(self).offset(@(AdaptationWidth(17)));
        make.right.equalTo(self).offset(@(AdaptationWidth(-17)));
        make.height.equalTo(@(AdaptationHeight(50)));
    }];
    
    UIButton *rescanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:rescanButton];
    rescanButton.backgroundColor = [UIColor clearColor];
    [rescanButton setTitle:@"重新扫描" forState:UIControlStateNormal];
    rescanButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [rescanButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [rescanButton addTarget:self action:@selector(rescanClick) forControlEvents:UIControlEventTouchUpInside];
    [rescanButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureButton.bottom).offset(@(AdaptationHeight(25)));
        make.centerX.equalTo(self);
        make.size.equalTo(CGSizeMake(AdaptationWidth(100), AdaptationHeight(40)));
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    return AdaptationHeight(35);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *infoLabel = [[UILabel alloc]init];
    [cell addSubview:infoLabel];
    if (indexPath.row == 0) {
        infoLabel.text = @"签发行：";
    }else {
        infoLabel.text = @"卡号：";
    }
    infoLabel.textColor = [UIColor colorWithHexString:@"888888"];
    infoLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
    CGFloat infoWidth = [GJJAppUtils calculateTextWidth:[UIFont systemFontOfSize:AdaptationWidth(14)] givenText:infoLabel.text givenHeight:AdaptationHeight(35)];
    infoLabel.frame = CGRectMake(0, 0, infoWidth, AdaptationHeight(35));
    
    if (indexPath.row == 0) {
        _bankNameLabel = [[UILabel alloc]init];
        [cell addSubview:_bankNameLabel];
        _bankNameLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        _bankNameLabel.userInteractionEnabled = NO;
        UITapGestureRecognizer *chooseBankTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseBank)];
        [_bankNameLabel addGestureRecognizer:chooseBankTap];
        _bankNameLabel.frame = CGRectMake(CGRectGetMaxX(infoLabel.frame), 0, AdaptationWidth(200), AdaptationHeight(35));
        _bankNameLabel.textColor = [UIColor colorWithHexString:@"888888"];
        _bankNameLabel.text = _infoDict[@"bank_name"];
        
        _bankNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:_bankNameButton];
        [_bankNameButton setTitle:@"修改" forState:UIControlStateNormal];
        [_bankNameButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
        _bankNameButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        [_bankNameButton addTarget:self action:@selector(bankNameClick) forControlEvents:UIControlEventTouchUpInside];
        _bankNameButton.frame = CGRectMake(ScreenWidth - AdaptationWidth(120), 0, AdaptationWidth(40), AdaptationHeight(35));
    }else {
        _cardNumberText = [[UITextField alloc]init];
        [cell addSubview:_cardNumberText];
        _cardNumberText.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        _cardNumberText.userInteractionEnabled = NO;
        _cardNumberText.placeholder = @"请输入您的银行卡号";
        _cardNumberText.keyboardType = UIKeyboardTypeNumberPad;
        _cardNumberText.frame = CGRectMake(CGRectGetMaxX(infoLabel.frame), 0, AdaptationWidth(200), AdaptationHeight(35));
        _cardNumberText.textColor = [UIColor colorWithHexString:@"888888"];
        _cardNumberText.text = _infoDict[@"bank_num"];
        _cardNumberText.delegate = self;
        
        _cardNumberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:_cardNumberButton];
        [_cardNumberButton setTitle:@"修改" forState:UIControlStateNormal];
        [_cardNumberButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
        _cardNumberButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
        [_cardNumberButton addTarget:self action:@selector(cardNumberClick) forControlEvents:UIControlEventTouchUpInside];
        _cardNumberButton.frame = CGRectMake(ScreenWidth - AdaptationWidth(120), 0, AdaptationWidth(40), AdaptationHeight(35));
    }
    
    return cell;
}

#pragma makr - button click
- (void)sureClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(bankCardScanSureInfoWithDict:infoView:)]) {
        NSString *bank_num = _cardNumberText.text;
        NSString *bank_name = _bankNameLabel.text;
        _infoDict = @{@"bank_num":bank_num,
                      @"bank_name":bank_name};
        [_delegate bankCardScanSureInfoWithDict:_infoDict infoView:self];
    }
}

- (void)rescanClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(bankCardRescan)]) {
        [self removeFromSuperview];
        [_delegate bankCardRescan];
    }
}

- (void)cardNumberClick
{
    _cardNumberText.userInteractionEnabled = YES;
    [_cardNumberText becomeFirstResponder];
}

- (void)bankNameClick
{
    _bankNameLabel.userInteractionEnabled = YES;
    [self showBankPickerView];
}

#pragma mark - UITextFieldDelegate

static NSInteger const kGroupSize = 4;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _cardNumberText) {
        
        NSString *text = textField.text;
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNo = [self removingSapceString:beingString];
        //校验卡号只能是数字，且不能超过20位
        if ( (string.length != 0 && ![self isValidNumbers:cardNo]) || cardNo.length > 20) {
            return NO;
        }
        //获取【光标右侧的数字个数】
        NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
        //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
        if (beingString.length > kGroupSize) {
            textField.text = [self groupedString:beingString];
        } else {
            textField.text = beingString;
        }
        text = textField.text;
        /**
         * 计算光标位置(相对末尾)
         * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
         * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
         */
        NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
        NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
        
        //如果光标左侧是一个空格，则光标回退一格
        if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:@" "]) {
            currentSelectedRange.location -= 1;
        }
        [textField setSelectedRange:currentSelectedRange];
        return NO;
    }else {
        return NO;
    }
}

#pragma mark - Helper
/**
 *  计算光标相对末尾的位置偏移
 *
 *  @param length           卡号的长度(不包括空格)
 *  @param rightNumberCount 光标右侧的数字个数
 *
 *  @return 光标相对末尾的位置偏移
 */
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount -1 > 0? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount -1 > 0? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

/**
 *  校验给定字符串是否是纯数字
 *
 *  @param numberStr 字符串
 *
 *  @return 字符串是否是纯数字
 */
- (BOOL)isValidNumbers:(NSString *)numberStr {
    NSString* numberRegex = @"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPre evaluateWithObject:numberStr];
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 1. 过滤非汉字、字母、数字字符
        textField.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSLog(@"regex is %@", regex);
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    NSLog(@"result is %@", result);
    
    return result;
}

#pragma mark - UITapGestureRecognizer
- (void)chooseBank
{
    [self showBankPickerView];
}

- (void)showBankPickerView
{
    NSMutableArray *bankNameArray = [NSMutableArray arrayWithCapacity:0];
    for (GJJBankModel *model in _bankListArray) {
        [bankNameArray addObject:model.bankName];
    }
    
    _chooseBankPickerView = [[GJJChoosePickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _chooseBankPickerView.delegate = self;
    _chooseBankPickerView.chooseThings = bankNameArray;
    [_chooseBankPickerView showView];
}

- (void)chooseThing:(NSString *)thing pickView:(GJJChoosePickerView *)pickView row:(NSInteger)row
{
    _bankNameLabel.text = thing;
}

@end
