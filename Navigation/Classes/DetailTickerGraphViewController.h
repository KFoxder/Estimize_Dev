//
//  DetailTickerGraphViewController.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/26/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@class TickerItem;

@interface DetailTickerGraphViewController : UIViewController<CPTPlotDataSource,CPTAxisDelegate,CPTPlotDelegate>
{
    float maxY_REV;
    float minY_REV;
    float maxY_EPS;
    float minY_EPS;
    
    @private
    CPTXYGraph *graph;
    NSMutableArray *dataForEPSPlot;
    NSMutableArray *dataForREVPlot;
    
}
@property (readwrite, strong, nonatomic) NSMutableArray *dataForQuarters;
@property (readwrite, strong, nonatomic) NSMutableArray *dataForREVPlot;
@property (readwrite, strong, nonatomic) NSMutableArray *dataForEPSPlot;
@property (strong, nonatomic) NSString * quarterSelected;
@property (nonatomic) NSNumber * quarterSelectedIndex;
@property (strong, nonatomic) TickerItem * tickerSelected;
@property (nonatomic) BOOL isEPS;

- (void) redrawGraph;
- (NSString *) getLastQuarter;
- (NSString *) getNextQuarter;
- (NSDictionary *) getREVEstimatesForQuarterIndex: (NSNumber *) index;
- (NSDictionary *) getEPSEstimatesForQuarterIndex: (NSNumber *) index;

@end
