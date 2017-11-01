//
//  KEHomeBillModel.h
//  KETallyBOOK
//
//  Created by 科文 on 09/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BGModel.h"

@interface KEHomeBillModel : NSObject

@property (nonatomic,copy) NSString *typeName;  //吃饭
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,copy) NSString *categoryImageFileName_S;
@property (nonatomic,assign) BOOL isIncome;
@end
