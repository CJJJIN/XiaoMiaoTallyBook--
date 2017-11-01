//
//  GATextField.m
//  GATextField
//
//  Created by Gamble on 12-4-13.
//  Copyright 2012 Gaotime. All rights reserved.
//

#import "GATextField.h"

#define KEYBOARD_BUTTON_WIDTH (self.key_board_number_subview.frame.size.width / 3.0f)
#define KEYBOARD_BUTTON_HEIGHT (self.key_board_number_subview.frame.size.height / 4.0f)
#define ScreenWidth ([[UIScreen mainScreen]bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen]bounds].size.height)

#define COLOR_RGBA(R,G,B,A) ([UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:A])

#define KEY_WINDOW  ([[UIApplication sharedApplication] keyWindow])

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]

#pragma mark - 自定义字体
#define DEF_CUSTOM_CITYD_BOLD @"CityD-Bold"
@implementation GATextField

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
        [self initKeyBoard];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initKeyBoard];
    }
    return self;
}

- (void)initKeyBoard {
    if (self) {
        self.delegate = self;

        self.font = [UIFont fontWithName:DEF_CUSTOM_CITYD_BOLD size:self.font.pointSize];

        _headString = @"";
        self.middleString = @"";
        _tailString = @"";

        _operatorButtonArray = [NSMutableArray array];

        m_keyboard_view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight * 0.6, ScreenWidth, ScreenHeight * 0.4 - ScreenHeight * 0.088)];
        m_keyboard_view.backgroundColor = [UIColor clearColor];

        m_keyboard_subview = [[UIView alloc] initWithFrame:CGRectMake(0, KEYBOARD_BUTTON_HEIGHT, KEYBOARD_BUTTON_WIDTH * 2, KEYBOARD_BUTTON_HEIGHT * 4)];
        m_keyboard_subview.backgroundColor = [UIColor clearColor];
//        [m_keyboard_view addSubview:m_keyboard_subview];
        
        self.key_board_left_subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_keyboard_view.frame.size.width * (1 - 0.21875), m_keyboard_view.frame.size.height)];
        [m_keyboard_view addSubview:self.key_board_left_subview];
        
//        self.key_board_operator_subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.088)];
//        [self.key_board_left_subview addSubview:self.key_board_operator_subview];
        
//        self.key_board_remark_subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.088)];
//        self.key_board_remark_subview.backgroundColor = [UIColor whiteColor];
//        [self.key_board_left_subview addSubview:self.key_board_remark_subview];
        
        self.key_board_number_subview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.key_board_left_subview.frame.size.width, self.key_board_left_subview.frame.size.height )];
        [self.key_board_left_subview addSubview:self.key_board_number_subview];
        
        self.key_board_right_subview = [[UIView alloc] initWithFrame:CGRectMake(self.key_board_left_subview.frame.origin.x + self.key_board_left_subview.frame.size.width,  0, ScreenWidth * 0.21875, self.key_board_left_subview.frame.size.height)];
        [m_keyboard_view addSubview:self.key_board_right_subview];
        

        self.inputView = m_keyboard_view;
        self.inputAccessoryView = nil;
       
        [self configKeypad:keyboardTypeNum];
        
        
       // self.text = @"¥";
        
        
        self.textColor = [UIColor colorWithWhite:110.0f/255 alpha:1.0f];
        self.keyBoardView = m_keyboard_view;
    }
}

- (NSString *)configNumberForEachButton:(UIButton *)button {
	NSString *a_button_text;
	if (button.tag == 0) {
		a_button_text = @"";
	}
	else if (button.tag < 4) {
		a_button_text = [NSString stringWithFormat:@"%li",(long)button.tag];
	}else if (button.tag == 4) {
		a_button_text = @"";
	}else if (button.tag > 4 && button.tag < 8) {
		a_button_text = [NSString stringWithFormat:@"%li",(long)button.tag-1];
	}else if (button.tag == 8) {
		a_button_text = @"600";
	}
	else if (button.tag < 12) {
		a_button_text = [NSString stringWithFormat:@"%li",(long)button.tag-2];
	}				
	else if (button.tag == 12) {
		a_button_text = @"601";
	}
	else if (button.tag == 13) {
		a_button_text = @"000";
	}
	else if (button.tag == 14) {
		a_button_text = @"0";
	}
	else if (button.tag == 15) {
		a_button_text = @"";
	}
	else if (button.tag == 16) {
		a_button_text = @"300";
	}
	else if (button.tag == 17) {
		a_button_text = @"002";
	}
	else if (button.tag == 18) {
		a_button_text = @"";
	}
	else if (button.tag == 19) {
		a_button_text = @"";
	}	
	return a_button_text;
}


- (NSString *)configAlphaForEachButton:(UIButton *)button {
	NSString *a_button_text = @"";
	if (button.tag < 24) {
		char labelTitle = 'A';
		labelTitle += button.tag;
		a_button_text = [NSString stringWithFormat:@"%c",labelTitle];
	}
	else if (button.tag == 24) {
		a_button_text = @"";
	}
	else if (button.tag == 25) {
		a_button_text = @"Y";
	}
	else if (button.tag == 26) {
		a_button_text = @"Z";
	}
	else if (button.tag == 27) {
		a_button_text = @"";
	}
	else if (button.tag == 28) {
		a_button_text = @"";
	}
	else if (button.tag == 29) {
		a_button_text = @"";
	}

	return a_button_text;
}


- (void)setImageForButton:(UIButton*)aButton {
	if (m_type == keyboardTypeNum) {
		if (aButton.tag == 0) {
			[aButton setBackgroundImage:[UIImage imageNamed:@"上证指数.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 4){
			[aButton setBackgroundImage:[UIImage imageNamed:@"深证成指.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 15){
			[aButton setBackgroundImage:[UIImage imageNamed:@"退格.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 18){
			[aButton setBackgroundImage:[UIImage imageNamed:@"abc.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 19){
			[aButton setBackgroundImage:[UIImage imageNamed:@"键盘.png"] forState:UIControlStateNormal];
		}
		else {
			[aButton setBackgroundImage:[UIImage imageNamed:@"键盘02.png"] forState:UIControlStateNormal];
		}
	}
	else {
		if (aButton.tag == 24) {
			[aButton setBackgroundImage:[UIImage imageNamed:@"退格.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 27){
			[aButton setBackgroundImage:[UIImage imageNamed:@"星号.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 28){
			[aButton setBackgroundImage:[UIImage imageNamed:@"123.png"] forState:UIControlStateNormal];
		}
		else if (aButton.tag == 29){
			[aButton setBackgroundImage:[UIImage imageNamed:@"键盘.png"] forState:UIControlStateNormal];
		}
		else {
			[aButton setBackgroundImage:[UIImage imageNamed:@"键盘02.png"] forState:UIControlStateNormal];
		}		
	}
}

- (void)hiddenOperatorButton {
//    for (UIButton * button in _operatorButtonArray) {
//        button.hidden = YES;
//    }
//    [m_keyboard_view setFrame:CGRectMake(0, 0, KEYBOARD_BUTTON_WIDTH * 4, KEYBOARD_BUTTON_HEIGHT * 4)];
//    [m_keyboard_subview setFrame:CGRectMake(0, 0, KEYBOARD_BUTTON_WIDTH * 4, KEYBOARD_BUTTON_HEIGHT * 4)];
}

- (void)configNumPad {
    
//    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.key_board_remark_subview.frame.size.width * 0.2, self.key_board_remark_subview.frame.size.height)];
//    [remarkLabel setText:@"备注："];
//    remarkLabel.font = [UIFont systemFontOfSize:18.0];
//    [remarkLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.key_board_remark_subview addSubview:remarkLabel];
//    
//    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(self.key_board_remark_subview.frame.size.width * 0.2, 0, self.key_board_remark_subview.frame.size.width * 0.4, self.key_board_remark_subview.frame.size.height)];
//    [self.key_board_remark_subview addSubview:textFiled];
//    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.key_board_remark_subview.frame.size.width * 0.6, 0, self.key_board_remark_subview.frame.size.width * 0.4-20, self.key_board_remark_subview.frame.size.height)];
//    [_moneyLabel setText:@"¥0"];
//    _moneyLabel.font = [UIFont systemFontOfSize:18.0];
//    [_moneyLabel setTextAlignment:NSTextAlignmentRight];
//    [self.key_board_remark_subview addSubview:_moneyLabel];
    
    
    
    CGFloat number_font_size = 28.0f;
    
    NSArray * headArray = [NSArray arrayWithObjects:@"/", @"x", @"-", @"+", nil];
    
    for (int i = 0; i < 4; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i * self.key_board_operator_subview.frame.size.width / 4.0f, 0, self.key_board_operator_subview.frame.size.width / 4.0f, self.key_board_operator_subview.frame.size.height)];
        button.tag = 100 + i + 1;
        button.titleLabel.font = [UIFont systemFontOfSize:number_font_size];
        [button setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
        [button setTitle:[headArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
        [self.key_board_operator_subview addSubview:button];
        [_operatorButtonArray addObject:button];
    }
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(j * self.key_board_number_subview.frame.size.width / 3.0f, i * self.key_board_number_subview.frame.size.height / 4.0f, self.key_board_number_subview.frame.size.width / 3.0f, self.key_board_number_subview.frame.size.height / 4.0f)];
            button.tag = (i + 1) * (j + 1);
            button.titleLabel.font = [UIFont fontWithName:DEF_CUSTOM_CITYD_BOLD size:number_font_size];
            [button setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
            [button setTitle:[NSString stringWithFormat:@"%i",i * 3 + j + 1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            [self.key_board_number_subview addSubview:button];
        }
    }

    UIButton * zeroButton = [[UIButton alloc] initWithFrame:CGRectMake(KEYBOARD_BUTTON_WIDTH * 1, KEYBOARD_BUTTON_HEIGHT * 3, KEYBOARD_BUTTON_WIDTH, KEYBOARD_BUTTON_HEIGHT)];
    zeroButton.titleLabel.font = [UIFont fontWithName:DEF_CUSTOM_CITYD_BOLD size:number_font_size];
    [zeroButton setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
    [zeroButton setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
    [zeroButton setTitle:@"0" forState:UIControlStateNormal];
    [zeroButton setTitleColor:[UIColor colorWithWhite:110.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [zeroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [zeroButton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_number_subview addSubview:zeroButton];

    UIButton * radix_pointButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KEYBOARD_BUTTON_HEIGHT * 3, KEYBOARD_BUTTON_WIDTH, KEYBOARD_BUTTON_HEIGHT)];
    radix_pointButton.tag = 11;
    radix_pointButton.titleLabel.font = [UIFont systemFontOfSize:number_font_size];
    [radix_pointButton setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
    [radix_pointButton setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
    [radix_pointButton setTitle:@"." forState:UIControlStateNormal];
    [radix_pointButton setTitleColor:[UIColor colorWithWhite:110.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [radix_pointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [radix_pointButton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_number_subview addSubview:radix_pointButton];

    UIButton * deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(KEYBOARD_BUTTON_WIDTH * 2, KEYBOARD_BUTTON_HEIGHT * 3, KEYBOARD_BUTTON_WIDTH, KEYBOARD_BUTTON_HEIGHT)];
    deleteButton.tag = 12;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:number_font_size];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
    //[deleteButton setImage:[UIImage imageNamed:@"deleteImage.png"] forState:UIControlStateNormal];
    [deleteButton setTitle:@"⌫" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithWhite:110.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    //[deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [deleteButton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_number_subview addSubview:deleteButton];

    self.acButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.key_board_right_subview.frame.size.height / 2.0f * 0, self.key_board_right_subview.frame.size.width, self.key_board_right_subview.frame.size.height / 4.0f)];
    self.acButton.tag = 1000;
    [self.acButton setBackgroundColor:[UIColor whiteColor]];
    [self.acButton setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [self.acButton setTitle:@"今天" forState:UIControlStateNormal];
    self.acButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [self.acButton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_right_subview addSubview:self.acButton];
    
    UIButton * subbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.key_board_right_subview.frame.size.height / 4.0f * 1, self.key_board_right_subview.frame.size.width, self.key_board_right_subview.frame.size.height / 4.0f)];
    subbutton.tag = 103;
    subbutton.titleLabel.font = [UIFont systemFontOfSize:number_font_size];
    [subbutton setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
    [subbutton setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
    [subbutton setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [subbutton setTitle:@"-" forState:UIControlStateNormal];
    [subbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [subbutton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_right_subview addSubview:subbutton];
    
    UIButton * addbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.key_board_right_subview.frame.size.height / 4.0f * 2, self.key_board_right_subview.frame.size.width, self.key_board_right_subview.frame.size.height / 4.0f)];
    addbutton.tag = 104;
    addbutton.titleLabel.font = [UIFont systemFontOfSize:number_font_size];
    [addbutton setBackgroundImage:[UIImage imageNamed:@"white_image.png"] forState:UIControlStateNormal];
    [addbutton setBackgroundImage:[UIImage imageNamed:@"barcolor_image.png"] forState:UIControlStateHighlighted];
    [addbutton setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    [addbutton setTitle:@"+" forState:UIControlStateNormal];
    [addbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [addbutton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_right_subview addSubview:addbutton];

    _okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.key_board_right_subview.frame.size.height / 4.0f * 3, self.key_board_right_subview.frame.size.width, self.key_board_right_subview.frame.size.height / 4.0f)];
    _okButton.tag = 10000;
    [_okButton setBackgroundColor:COLOR_RGBA(254, 217, 83, 1.0f)];
    [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    [_okButton setTitle:@"=" forState:UIControlStateSelected];
    [_okButton setTitleColor:[UIColor colorWithWhite:100.0f/255 alpha:1.0f] forState:UIControlStateNormal];
    _okButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [_okButton addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.key_board_right_subview addSubview:_okButton];
    
}

- (void)hideOperatorButton {
    [m_keyboard_view setFrame:CGRectMake(0, 0, KEYBOARD_BUTTON_WIDTH * 4, KEYBOARD_BUTTON_HEIGHT * 4)];
    [m_keyboard_subview setFrame:CGRectMake(0, 0, KEYBOARD_BUTTON_WIDTH * 4, KEYBOARD_BUTTON_HEIGHT * 4)];

    for (UIButton * button in _operatorButtonArray) {
        button.hidden = YES;
    }
}

- (void)configAlphaPad {
	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 6; j++) {
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = i+j*5;
			[button addTarget:self action:@selector(buttonClickAtIndex:) forControlEvents:UIControlEventTouchUpInside];
			button.frame = CGRectMake(0+64*i, 2+35*j, 60, 30);
			[m_keyboard_view addSubview:button];
			NSString *a_button_text = [self configAlphaForEachButton:button];
			[button setTitle:a_button_text forState:UIControlStateNormal];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[self setImageForButton:button];
		}
	}
}


- (void)configKeypad:(KeyboardType)aType {
	m_type = aType;
	if (aType == keyboardTypeNum) {
		[self configNumPad];
	}
	else if (aType == keyboardTypeAlpha) {
		[self configAlphaPad];
	}
}

- (void)deleteAllChar {
    _currentOperator = 0;
    if (_okButton) {
        _okButton.selected = NO;
    }
    _last_numberString = @"";
    if (![self.middleString isEqualToString:@""]) {
        [self setText:@""];
    }
}


- (void)deleteChar {
    NSMutableString * self_text = [NSMutableString stringWithFormat:@"%@",[[super text] substringFromIndex:[_headString length]]];
    if ([self_text isEqualToString:@""]) {
        return;
    }
	NSRange range = {([self_text length] - 1),1};
    [self_text deleteCharactersInRange:range];
    if ([self.middleString isEqualToString:@""]) {
        _last_numberString = [NSString stringWithFormat:@"%@",self_text];
    }
    else {
        self.middleString = [NSString stringWithFormat:@"%@",self_text];
    }
    [super setText:[NSString stringWithFormat:@"%@%@%@",_headString,self_text,_tailString]];
}


- (void)removeExistButtons {
    for(UIView *mySubview in m_keyboard_view.subviews){
        [mySubview removeFromSuperview];
    }
}


- (void)changeKeyPad {
	[self removeExistButtons];  //移除上次的button
	if (m_type == keyboardTypeNum) {
		[self configKeypad:keyboardTypeAlpha];
	}
	else {
		[self configKeypad:keyboardTypeNum];
	}
}


- (void)displayNumChar:(NSString *)aString {
    if (_isOperatorButtonJustClicked) {
        _isOperatorButtonJustClicked = NO;
        if (![self.middleString isEqualToString:@""]) {
        [self setText:@""];
    }
    }
    NSMutableString *a_text_str = [NSMutableString stringWithFormat:@"%@",self.middleString];
    
   
    if ([a_text_str length]<=8) {
        [a_text_str appendFormat:@"%@",aString];
    }
    
	[self setText:a_text_str];
}


- (void)buttonOnClicked:(id)sender {
	UIButton *button = (UIButton*)sender;
	if (m_type == keyboardTypeNum) {
		switch (button.tag) {
			case 11:
			{
                BOOL isDisplay = YES;
                for (int i = 0; i < [self.middleString length]; i++) {
                    NSString * simpleStr = [self.middleString substringWithRange:NSMakeRange(i, 1)];
                    if ([simpleStr isEqualToString:@"."]) {
                        isDisplay = NO;
                        break;
                    }
                }
                if (isDisplay) {
                    [self displayNumChar:@"."];
                }
			}
				break;
			case 12:
			{
                [self deleteChar];
			}
				break;
			case 101:
            {
                _last_numberString = [self calculateWith_left_number:_last_numberString operator_number:_currentOperator right_number:self.middleString];
                [self setText:_last_numberString];
                self.middleString = @"";
                _currentOperator = 1;
                if (_okButton) {
                    _okButton.selected = YES;
                }
                _isOperatorButtonJustClicked = YES;
			}
				break;
			case 102:
            {
                _last_numberString = [self calculateWith_left_number:_last_numberString operator_number:_currentOperator right_number:self.middleString];
                [self setText:_last_numberString];
                self.middleString = @"";
                _currentOperator = 2;
                if (_okButton) {
                    _okButton.selected = YES;
                }
                _isOperatorButtonJustClicked = YES;
			}
				break;
			case 103:
            {
                _last_numberString = [self calculateWith_left_number:_last_numberString operator_number:_currentOperator right_number:self.middleString];
                [self setText:_last_numberString];
                self.middleString = @"";
                _currentOperator = 3;
                if (_okButton) {
                    _okButton.selected = YES;
                }
                _isOperatorButtonJustClicked = YES;
			}
                break;
            case 104:
            {
                _last_numberString = [self calculateWith_left_number:_last_numberString operator_number:_currentOperator right_number:self.middleString];
                [self setText:_last_numberString];
                self.middleString = @"";
                _currentOperator = 4;
                if (_okButton) {
                    _okButton.selected = YES;
                }
                _isOperatorButtonJustClicked = YES;
            }
                break;
            case 1000:
            {
                
                self.dateBtnAction();
                [self resignFirstResponder];
                //[self.acButton setTitle:self.dateBtnAction() forState:normal];
                //[self deleteAllChar];
            }
                break;
            case 10000:
            {
                if (button.selected) {
                    button.selected = !button.selected;
                    if (_isOperatorButtonJustClicked) {
                        _isOperatorButtonJustClicked = NO;
                        [self setText:_last_numberString];
                        _last_numberString = @"";
                        _currentOperator = 0;
                        return;
                    }
                    _last_numberString = [self calculateWith_left_number:_last_numberString operator_number:_currentOperator right_number:self.middleString];
                    _currentOperator = 0;
                    [self setText:_last_numberString];
                }
                else {
                    self.okBtnAction();
                }
            }
                break;
			default:
				break;
		}
	}
	else {
		switch (button.tag) {
			case 24:
			{
				[self deleteChar];  //删除输入的内容
			}
				break;
			case 28:
			{
				[self changeKeyPad];  //切换
			}
				break;
			case 29:
			{
				[self resignFirstResponder];  //弹回自定义键盘
			}
				break;
			default:
				break;
		}
	}
}

- (void)setText:(NSString *)text {
    NSCharacterSet * setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.-"] invertedSet];

    text = [[text componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
    
    
    
    self.middleString = text;
    [super setText:[NSString stringWithFormat:@"%@%@%@",_headString,text,_tailString]];

    if ([_ga_delegate respondsToSelector:@selector(GATextFieldDidChangedEditing:)]) {
        [_ga_delegate GATextFieldDidChangedEditing:self];
    }
}

- (NSString*)text {
    
    return [NSString stringWithFormat:@"%.2f",[self.middleString doubleValue]];
}

- (NSString*)wipe_off_zero:(CGFloat)numberFloat {
    NSString * numberStr = [NSString stringWithFormat:@"%.2f",numberFloat];
    while (YES) {
        if ([[numberStr substringFromIndex:[numberStr length] - 1] intValue] == 0) {
            numberStr = [numberStr substringToIndex:[numberStr length] - 1];
        }
        else {
            break;
        }
    }
    return numberStr;
    return 0;
}

- (void)buttonClickAtIndex:(id)sender {
	UIButton *button = (UIButton*)sender;
	NSString *str = @"";
	if (m_type == keyboardTypeNum) {
		if (button.tag > 10) {
			[self buttonOnClicked:sender];
			return;
		}
		else {
			str = button.titleLabel.text;
		}
	}
	else {
		if (button.tag==24||button.tag==28||button.tag==29) {
			[self buttonOnClicked:sender];
			return;
		}
		else if (button.tag == 27) {
			str = @"*";
		}
		else {
			str = button.titleLabel.text;
		}
	}
	[self displayNumChar:str];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![textField.text isEqualToString:@"0.00"]) {
        [self setText:textField.text];
        if ([[textField.text substringToIndex:1]  isEqual: @"-"]) {
             [self setText:[textField.text substringFromIndex:1]];
        }
        self.middleString = textField.text;
    }else{
        self.middleString = @"";
    }
    if ([self.middleString isEqualToString:@""]) {
        [self setText:@""];
    }

    _currentOperator = 0;
    _last_numberString = @"";
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_ga_delegate respondsToSelector:@selector(GATextFieldDidEndEditing:)]) {
        [_ga_delegate GATextFieldDidEndEditing:textField];
    }
    if (!self.middleString) {
        if (_last_numberString) {
            [textField setText:[NSString stringWithFormat:@"%.2f",[_last_numberString doubleValue]]];
        }
    }
    else {
        if ([self isPureInt:self.middleString]) {
            [textField setText:self.middleString];
        }else{
            [textField setText:[NSString stringWithFormat:@"%.2f",[self.middleString doubleValue]]];
        }
        
    }
}

#pragma mark - 一些必要的函数

- (NSString*)calculateWith_left_number:(NSString*)left_number operator_number :(NSInteger)operator_number right_number:(NSString*)right_number {
    
    if (!left_number || [left_number isEqualToString:@""]) {
        return right_number;
    }
    
    if (!right_number || [right_number isEqualToString:@""]) {
        return left_number;
    }
    
    switch (operator_number) {
        case 1: {
            return [NSString stringWithFormat:@"%.2f",[left_number doubleValue] / [right_number doubleValue]];
            break;
        }
            
        case 2: {
            return [NSString stringWithFormat:@"%.2f",[left_number doubleValue] * [right_number doubleValue]];
            break;
        }
        case 3: {
            return [NSString stringWithFormat:@"%.2f",[left_number doubleValue] - [right_number doubleValue]];
            break;
        }
            
        case 4: {
            return [NSString stringWithFormat:@"%.2f",[left_number doubleValue] + [right_number doubleValue]];
            break;
        }
            
        default:
            return left_number ? left_number : right_number;
            break;
    }
    
    return left_number ? left_number : right_number;
}

-(void)setMiddleString:(NSString *)middleString{
    _middleString = middleString;
}

//判断字符串是否为浮点数
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
@end
