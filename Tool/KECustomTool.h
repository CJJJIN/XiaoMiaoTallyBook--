//
//  KECustomTool.h
//  KETallyBOOK
//
//  Created by 科文 on 17/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KECustomTool : NSObject
+ (NSString*)weekdayStringFromDate:(NSString*)inputDate;

+ (BOOL)isPureFloat:(NSString*)string;

+ (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month;

+ (NSDate *)dateFromeString:(NSString*)string;
+ (NSDate *)yearFromeString:(NSString*)string;
@end
