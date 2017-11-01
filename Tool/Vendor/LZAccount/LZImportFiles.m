//
//  LZImportFiles.m
//  KETallyBOOK
//
//  Created by 科文 on 19/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import "LZImportFiles.h"

#import "LZGestureTool.h"
#import "LZGestureScreen.h"
#import "TouchIdUnlock.h"

@implementation LZImportFiles

- (void)verifyPassword {
    
    if ([LZGestureTool isGestureEnable]) {
        
        [[LZGestureScreen shared] show];
        
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[LZGestureScreen shared] dismiss];
            }];
        }
    }
}

@end
