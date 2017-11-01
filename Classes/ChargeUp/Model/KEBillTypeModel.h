//
//  KEBillTypeModel.h
//  KETallyBOOK
//
//  Created by 科文 on 09/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BGModel.h"

@interface KEBillTypeModel : NSObject

@property (nonatomic,copy) NSString *categoryImageFileName_Normal;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *categoryImageFileName_S;
@property (nonatomic,copy) NSString *categoryImageFileName_Selected;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,assign) BOOL isIncome;
@end
