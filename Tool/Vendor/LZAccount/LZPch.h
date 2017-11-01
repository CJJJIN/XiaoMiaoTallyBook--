//
//  LZPch.h
//  KETallyBOOK
//
//  Created by 科文 on 19/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#ifndef LZPch_h
#define LZPch_h


#ifdef DEBUG
#define LZLog(s, ... ) NSLog( @"[%@：in line: %d]-->[message: %@]", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define LZLog(s, ... )
#endif

#define LZWeakSelf(ws) __weak typeof(self) ws = self;

#define LZWeak(sf, value) __weak typeof(value) sf = value;
//判断是否是ipad
#define isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

//判断是否是iphone6plus (高度)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone6 (高度)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone5(s) (高度)
#define iPhone5 isIphone5
//判断是否是iphone4 (高度)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone5 (高度)
#define isIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define LZSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define LZSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

// Hex色值
#define LZColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define LZColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//008e14 三叶草绿
//09c628
#define LZColorBase LZColorFromHex(0x0075a9)
#define LZFontDefaulte [UIFont systemFontOfSize:14]
#define LZColorGray LZColorFromHex(0x555555)

#define LZNavigationHeight 64
#define LZTabBarHeight 49
#import <Masonry/Masonry.h>

#endif /* LZPch_h */
