//
//  KEChartView.m
//  KETallyBOOK
//
//  Created by 科文 on 18/10/2017.
//  Copyright © 2017 科文. All rights reserved.
//

#import "KEChartView.h"

#import "XAxisFormtter.h"
#import "YAxisFormtter.h"
#import "YRightAxisFormtter.h"
#import "HighLightFormatter.h"
@interface KEChartView ()


@property (nonatomic, strong) NSMutableArray* tempArray1;
@property (nonatomic, strong) SLGCDTimer timer;

@property (nonatomic, strong) HighLightFormatter *highLightFor;

@end

@implementation KEChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupMyView];
    }
    return self;
}

-(void)setupMyView{
    self.myView = [[BaseCurveView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    ChartAxisBase* xAxis = self.myView.XAxis;
    xAxis.axisValueFormatter = [[XAxisFormtter alloc] init];
    xAxis.drawLabelsEnabled = YES;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.labelFont = [UIFont systemFontOfSize:11.0];
    xAxis.labelTextColor = [UIColor darkGrayColor];
    xAxis.maxLongLabelString = @"1234";
    xAxis.GridLinesMode = dashModeLine;
    xAxis.enabled = YES;
    //xAxis.axisLineColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    ChartAxisBase* leftYAxis = self.myView.leftYAxis;
    leftYAxis.axisValueFormatter = [[YAxisFormtter alloc] init];
    leftYAxis.drawLabelsEnabled = YES;
    leftYAxis.drawAxisLineEnabled = YES;
    leftYAxis.drawGridLinesEnabled = YES;
    leftYAxis.labelFont = [UIFont systemFontOfSize:11.0];
    leftYAxis.labelTextColor = [UIColor darkGrayColor];
    leftYAxis.maxLongLabelString = @"100.0";
    leftYAxis.GridLinesMode = dashModeLine;
    leftYAxis.gridColor = [UIColor colorWithColor:[UIColor whiteColor] andalpha:0.25];
    leftYAxis.enabled = YES;
    
    ChartAxisBase* rightYAxis = self.myView.rightYAxis;
    rightYAxis.axisValueFormatter = [[YRightAxisFormtter alloc] init];
    rightYAxis.drawLabelsEnabled = YES;
    rightYAxis.drawAxisLineEnabled = YES;
    rightYAxis.drawGridLinesEnabled = YES;
    rightYAxis.labelFont = [UIFont systemFontOfSize:11.0];
    rightYAxis.labelTextColor = [UIColor darkGrayColor];
    rightYAxis.maxLongLabelString = @"100.0";
    rightYAxis.GridLinesMode = dashModeLine;
    rightYAxis.gridColor = [UIColor colorWithColor:[UIColor blueColor] andalpha:0.25];;
    rightYAxis.enabled = YES;
    
    //默认选择的highlight
    ChartHighlight* highLight = [[ChartHighlight alloc] init];
    highLight.dataIndex = 0;
    highLight.enabled = YES;
    self.highLightFor = [[HighLightFormatter alloc] init];
    highLight.delegate = self.highLightFor;
    self.myView.hightLight = highLight;
    

}



-(void)setViewArry:(NSMutableArray *)viewArry{
    _tempArray1 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < viewArry.count; i++) {
        ChartDataEntry* entry = [[ChartDataEntry alloc] initWithX:i+1 y:[(viewArry[i]) floatValue]];
        
        [_tempArray1 addObject:entry];
    }
    _dataset = [[SLLineChartDataSet alloc] initWithValues:self.tempArray1 label:@"Default"];
    _dataset.lineWidth = 1.0;
    _dataset.mode = curveLineMode;
    _dataset.color = [UIColor darkTextColor];
    _dataset.circleRadius = 5.0;
    _dataset.circleHoleRadius = 3.0;
    _dataset.circleHoleColor = [UIColor colorWithRed:254/255.f green:217/255.f blue:83/255.f alpha:1.f];
    _dataset.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
    _dataset.drawCircleHoleEnabled = YES;
    _dataset.drawCirclesEnabled = YES;
    [self.myView setScaleXEnabled:@(YES)];
    [self.myView setDynamicYAixs:@(NO)];
    [self.myView setBaseYValueFromZero:@(YES)];
    
    //设置的时候务必保证  VisibleXRangeDefaultmum 落在 VisibleXRangeMinimum 和 VisibleXRangeMaximum 否则将导致缩放功能不可用
    [self.myView setVisibleXRangeMaximum:@(32)];
    [self.myView setVisibleXRangeMinimum:@(2)];
    [self.myView setVisibleXRangeDefaultmum:@(32)];
    //直接调用Set方法和refreashDataSourceRestoreContext 和该方法等效
    [self.myView refreashDataSourceRestoreContext:_dataset];
    
    self.myView.leftYAxis.enabled = NO;
    self.myView.rightYAxis.enabled = NO;
    self.myView.backgroundColor = [UIColor whiteColor];
    _dataset.mode = brokenLineMode;
    [self addSubview:self.myView];
    //[self.myView refreashGraph];
}


//-(NSMutableArray *)viewArry{
//    if (_tempArray1 == nil) {
//        _tempArray1 = [NSMutableArray arrayWithCapacity:1];
//        for (int i = 0; i < _viewArry.count; i++) {
//            _viewArry[i]
//            ChartDataEntry* entry = [[ChartDataEntry alloc] initWithX:i y:temp];
//            [_tempArray1 addObject:entry];
//        }
//    }
//    return _tempArray1;
//}
@end
