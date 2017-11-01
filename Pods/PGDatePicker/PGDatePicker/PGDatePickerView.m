//
//  PGDatePickerView.m
//  HooDatePickerDemo
//
//  Created by piggybear on 2017/7/25.
//  Copyright © 2017年 piggybear. All rights reserved.
//

#import "PGDatePickerView.h"
#import "UIColor+PGHex.h"

@interface PGDatePickerView()
@property (nonatomic, weak) UILabel *label;
@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kContentFont 17
#define kViewHeight 50
@implementation PGDatePickerView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma Setter
- (void)setCurrentDate:(BOOL)currentDate {
    _currentDate = currentDate;
    if (currentDate) {
        self.label.textColor = [UIColor colorWithHexString:@"#FAD9A2"];
    }else {
        self.label.textColor = [UIColor colorWithHexString:@"#838383"];
    }
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.label.text = content;
    CGSize size = [content sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kContentFont]}];
    self.label.frame = (CGRect){{kScreenWidth / 2 - size.width / 2, kViewHeight / 2 - size.height / 2}, size};
}

#pragma Getter
- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:kContentFont];
        [self.contentView addSubview:label];
        _label = label;
    }
    return _label;
}

@end
