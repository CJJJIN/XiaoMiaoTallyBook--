//
//  KEChartView.h
//  KETallyBOOK
//
//  Created by 科文 on 18/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLCurveChartLib/SLCurveChartLib.h>

@interface KEChartView : UIView
@property (nonatomic, strong) SLLineChartDataSet* dataset;
@property (strong, nonatomic) BaseCurveView *myView;
@property (nonatomic, strong) NSMutableArray* viewArry;
@end
