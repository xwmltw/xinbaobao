//
//  GJJIDCardScanSuccessTableViewCell.m
//  RenRenhua2.0
//
//  Created by 葛佳佳 on 2017/2/4.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "GJJIDCardScanSuccessTableViewCell.h"


@interface GJJIDCardScanSuccessTableViewCell ()
<UITextFieldDelegate>

@property (nonatomic, copy) NSIndexPath *indexPath;

@property (nonatomic, assign) TCARD_TYPE iCardType;

@end

@implementation GJJIDCardScanSuccessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath iCardType:(TCARD_TYPE)iCardType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    _indexPath = indexPath;
    _iCardType = iCardType;
    
    [self setupView];
    
    return self;
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *separatorLabel = [[UILabel alloc]init];
    [self addSubview:separatorLabel];
    separatorLabel.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    [separatorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(0.5);
    }];
    
    CGFloat maxLabelWidth = [GJJAppUtils calculatorMaxWidthWithString:@[@"姓       名：", @"身份证号："] givenFont:[UIFont boldSystemFontOfSize:AdaptationWidth(14)]];
    
    _hintLabel = [[UILabel alloc]init];
    [self addSubview:_hintLabel];
    _hintLabel.textColor = [UIColor colorWithHexString:@"888888"];
    _hintLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    [_hintLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(maxLabelWidth);
    }];
    
    _infoText = [[UITextField alloc]init];
    [self addSubview:_infoText];
    _infoText.delegate = self;
    _infoText.textColor = [UIColor colorWithHexString:@"888888"];
    _infoText.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    _infoText.userInteractionEnabled = NO;
    [_infoText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    if (_iCardType == 17) {
        if (_indexPath.row != 1) {
            
            UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:editButton];
            [editButton setTitle:@"修改" forState:UIControlStateNormal];
            [editButton setTitleColor:[UIColor colorWithHexString:GJJOrangeTextColorString] forState:UIControlStateNormal];
            editButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(14)];
            [editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
            [editButton makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).offset(@(AdaptationWidth(-10)));
                make.width.equalTo(@(AdaptationWidth(40)));
                make.height.equalTo(@(AdaptationHeight(35)));
            }];
            
            [_infoText makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_hintLabel.right);
                make.top.bottom.equalTo(self);
                make.right.equalTo(editButton.left);
            }];

        }else {
            [_infoText makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_hintLabel.right);
                make.top.bottom.equalTo(self);
                make.right.equalTo(self);
            }];
        }
        
    }else {
        [_infoText makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hintLabel.right);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self);
        }];
    }
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
    _infoDict = infoDict;
    
    if (_iCardType == 17) {
        if (_indexPath.row == 0) {
            _hintLabel.text = @"姓       名：";
            _infoText.text = _infoDict[@"name"];
        }else if (_indexPath.row == 1) {
            _hintLabel.text = @"性       别：";
            _infoText.text = _infoDict[@"sex"];
        }else if (_indexPath.row == 2) {
            _hintLabel.text = @"身份证号：";
            _infoText.text = _infoDict[@"num"];
        }
    }else if (_iCardType == 20) {
        if (_indexPath.row == 0) {
            _hintLabel.text = @"签发机关：";
            _infoText.text = _infoDict[@"issue"];
        }else if (_indexPath.row == 1) {
            _hintLabel.text = @"有效期限：";
            _infoText.text = _infoDict[@"period"];
        }
    }
}

- (void)editClick:(UIButton *)sender
{
    _infoText.userInteractionEnabled = YES;
    [_infoText becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(userNeedEditInfoWithCell:textField:iCardType:)]) {
//        [_delegate userNeedEditInfoWithCell:self textField:textField iCardType:_iCardType];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 1. 过滤非汉字、字母、数字字符
        textField.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
        // 2. 截取
        if (_iCardType == 17 && _indexPath.row == 2) {//身份证号
            if (textField.text.length >= 18) {
                textField.text = [textField.text substringToIndex:18];
            }
        }
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
