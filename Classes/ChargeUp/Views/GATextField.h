//
//  GATextField.h
//  GATextField
//
//  Created by Gamble on 12-4-13.
//  Copyright 2012 Gaotime. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef enum {
	keyboardTypeNum = 0,
	keyboardTypeAlpha,
}KeyboardType;

typedef enum {
	systemKeyboard = 0,
	customKeyboard,
}KeyboardShowMode;

typedef void(^okAction)(void);
typedef void(^dateAction)(void);

typedef enum {
    none = 0,
    division,
    multiplication,
    subtraction,
    addition,
}KeyboardOperator;

@protocol GATextFieldDelegate <NSObject>

@optional

- (void)GATextFieldDidEndEditing:(UITextField *)textField;
- (void)GATextFieldDidChangedEditing:(UITextField *)textField;

@end

@interface GATextField : UITextField<UITextFieldDelegate> {
	///自定义键盘view
	UIView * m_keyboard_view;
    UIView * m_keyboard_subview;
	///键盘类型(数字或者字母)
	KeyboardType m_type;
	///键盘代理
	id GAdelegate;
    CGFloat number;
    KeyboardOperator _currentOperator;
}
@property (nonatomic, copy) dateAction dateBtnAction;
@property (nonatomic, copy) okAction okBtnAction;
@property (nonatomic, assign) id<GATextFieldDelegate> ga_delegate;
@property (nonatomic, assign) BOOL isOperatorButtonJustClicked;
@property (nonatomic, strong) NSString * last_numberString;
@property (nonatomic, strong) NSMutableArray * operatorButtonArray;
@property (nonatomic, strong) NSString * headString;
@property (nonatomic, strong) NSString * tailString;
@property (nonatomic, strong) NSString * middleString;


@property (nonatomic, strong) UIView * key_board_left_subview;
@property (nonatomic, strong) UIView * key_board_right_subview;
@property (nonatomic, strong) UIView * key_board_operator_subview;
@property (nonatomic, strong) UIView * key_board_remark_subview;
@property (nonatomic, strong) UIView * key_board_number_subview;
@property (nonatomic, strong) UIButton * okButton;
@property (nonatomic, strong) UIButton * acButton;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *keyBoardView;

- (void)configKeypad:(KeyboardType)aType;

- (void)initKeyBoard;

- (void)hiddenOperatorButton;

@end
