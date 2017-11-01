#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIColor+SLExtension.h"
#import "BaseCurveView.h"
#import "ChartAxisBase.h"
#import "ChartComponentBase.h"
#import "ChartHighlight.h"
#import "SLChartBaseDataSet.h"
#import "SLLineChartDataSet.h"
#import "ChartDataEntry.h"
#import "ChartDataEntryBase.h"
#import "SLChartAxisValueFormatterPotocol.h"
#import "SLChartDataProtocol.h"
#import "SLChartFormatterProtocol.h"
#import "SLCurveChartLib.h"
#import "SLGCDTimerTool.h"

FOUNDATION_EXPORT double SLCurveChartLibVersionNumber;
FOUNDATION_EXPORT const unsigned char SLCurveChartLibVersionString[];

