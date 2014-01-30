//
//  DetailTickerGraphViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/26/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#define NUMBER_OF_QUARTERS 12.0

#import "DetailTickerGraphViewController.h"
#import <float.h>
#import "Constants.h"

@interface DetailTickerGraphViewController ()

@end

@implementation DetailTickerGraphViewController
@synthesize dataForEPSPlot,tickerSelected,isEPS,dataForREVPlot,dataForQuarters,quarterSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{

    [self setupPlot];
}

-(void) setupData
{
    float max_y_value_REV = FLT_MIN;
    float min_y_value_REV = FLT_MAX;
    float max_y_value_EPS = FLT_MIN;
    float min_y_value_EPS = FLT_MAX;
    
    // Add some initial data
    NSMutableArray *contentArrayEPS = [NSMutableArray arrayWithCapacity:15];
    NSUInteger i;
    for ( i = 0; i < NUMBER_OF_QUARTERS; i++ ) {
        NSNumber *x = [NSNumber numberWithFloat:i];
        NSNumber *y = [NSNumber numberWithFloat:4.2 * rand() / (float)RAND_MAX + 1.2];
        [contentArrayEPS addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"FQ", y, @"y", nil]];
        
        //check for min
        float y_val = y.floatValue;
        
        if(y_val < min_y_value_EPS) min_y_value_EPS = y_val;
        if(y_val > max_y_value_EPS) max_y_value_EPS = y_val;
        
    }
    self.dataForEPSPlot = contentArrayEPS;
    
    NSMutableArray *contentArrayREV = [NSMutableArray arrayWithCapacity:15];
    for ( i = 0; i < NUMBER_OF_QUARTERS; i++ ) {
        NSNumber *x = [NSNumber numberWithFloat:i];
        NSNumber *y = [NSNumber numberWithFloat:3.2 * rand() / (float)RAND_MAX + 12.2];
        [contentArrayREV addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"FQ", y, @"y", nil]];
        
        //check for min
        float y_val = y.floatValue;
        
        if(y_val < min_y_value_REV) min_y_value_REV = y_val;
        if(y_val > max_y_value_REV) max_y_value_REV = y_val;
        
    }
    self.dataForREVPlot = contentArrayREV;
    
    
    //Set max and min of data with padding
    maxY_EPS = max_y_value_EPS + 1.0;
    minY_EPS = min_y_value_EPS - 1.0;
    
    maxY_REV = max_y_value_REV + 1.0;
    minY_REV = min_y_value_REV - 1.0;
    
    NSLog(@" Max Y - EPS = %f",maxY_EPS);
    NSLog(@" Min Y - EPS = %f",minY_EPS);
    NSLog(@" Max Y - REV = %f",maxY_REV);
    NSLog(@" Min Y - REV = %f",minY_REV);
    
    //Setup Number of Quarters
    NSMutableArray * quarters = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_QUARTERS];
    for ( i = 0; i < NUMBER_OF_QUARTERS; i++ ) {
        [quarters addObject:[NSString stringWithFormat:@"FQ%d",i]];
    }
    self.dataForQuarters = quarters;
    
    //Set the quarter selected to most recent quarter available
    self.quarterSelected = [quarters objectAtIndex:NUMBER_OF_QUARTERS-1];
    self.quarterSelectedIndex = [NSNumber numberWithDouble:(NUMBER_OF_QUARTERS-1)];
    
    NSLog(@"Default Quarter Selected = %@",self.quarterSelected);
    

}

-(void) setupPlot
{
    //Determine which min and max for y-axis should be used
    float minY;
    float maxY;
    if(isEPS){
        minY = minY_EPS;
        maxY = maxY_EPS;
    }else{
        minY = minY_REV;
        maxY = maxY_REV;
    }
    
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = graph;
    
    // Border
    graph.plotAreaFrame.borderLineStyle = nil;
    
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:25.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    [graph.plotAreaFrame setPaddingRight:10.0f];
    
    //Padding
    graph.paddingLeft   = 10.0;
    graph.paddingTop    = 30.0;
    graph.paddingRight  = 10.0;
    graph.paddingBottom = 0.0;
    
    
    //Setup title
    NSString * graphTitle;
    if(isEPS){
        graphTitle = @"EPS";
    }else{
        graphTitle = @"Revenue";
    }
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color         = [CPTColor lightGrayColor];
    titleStyle.fontName      = @"Helvetica-Bold";
    titleStyle.fontSize      = 12.0;
    titleStyle.textAlignment = CPTTextAlignmentCenter;
    
    graph.title          = [NSString stringWithString:graphTitle];
    graph.titleTextStyle = titleStyle;
    graph.titleDisplacement        = CGPointMake(0.0, 20.0);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;


    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(NUMBER_OF_QUARTERS+0.5)];
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat((maxY-minY)+1.0)];
 
    ///////////////////////////////////////////
    //                                       //
    //           Axes Below                  //
    //                                       //
    //                                       //
    ///////////////////////////////////////////
    
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor lightGrayColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [CPTColor lightGrayColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor lightGrayColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 8.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor lightGrayColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor lightGrayColor];
    gridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f], [NSNumber numberWithFloat:1.0f], nil];
    gridLineStyle.lineWidth =0.5f;
    
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    
    
    
    
    //X Axis
    CPTXYAxis *x          = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(minY);
    x.majorGridLineStyle = gridLineStyle;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 1.0f;
    x.tickDirection = CPTSignNegative;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:NUMBER_OF_QUARTERS];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:NUMBER_OF_QUARTERS];
    NSInteger i = 0;
    int index;
    for (index = 0;index<NUMBER_OF_QUARTERS;index++) {
        NSString * textLabel = [dataForQuarters objectAtIndex:index];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:textLabel  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;    
    x.majorTickLocations = xLocations;
    
    
    

    
    //Y Axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = gridLineStyle;
    y.axisLineStyle = nil;
    y.majorIntervalLength         = CPTDecimalFromDouble(1.0);
    y.minorTicksPerInterval       = nil;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.labelTextStyle = axisTextStyle;
    //y.majorTickLineStyle = axisLineStyle;


    //y.delegate             = self;
    
    
    
    
    
    
    
    ///////////////////////////////////////////
    //                                       //
    //           Plot Lines Below            //
    //                                       //
    //                                       //
    ///////////////////////////////////////////
    
    
    // Create a Estimize Plot
    CPTScatterPlot *estimizeLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0;
    lineStyle.lineWidth         = 1.5;
    lineStyle.lineColor         = [CPTColor blueColor];
    lineStyle.dashPattern       = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0f], [NSNumber numberWithFloat:2.0f], nil];
    estimizeLinePlot.dataLineStyle = lineStyle;
    estimizeLinePlot.identifier    = @"Estimize";
    estimizeLinePlot.dataSource    = self;
    estimizeLinePlot.delegate    = self;
    estimizeLinePlot.plotSymbolMarginForHitDetection = 10.0f;
    
    [graph addPlot:estimizeLinePlot];
    
    // Do a blue gradient
    //CPTColor *areaColor1       = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
   // CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
   // areaGradient1.angle = -90.0;
   // CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
   // boundLinePlot.areaFill      = areaGradientFill;
   // boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blueColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(2.0, 2.0);
    estimizeLinePlot.plotSymbol = plotSymbol;
    
    // Create a black plot 
    CPTScatterPlot *wallstreetLinePlot = [[CPTScatterPlot alloc] init];
    lineStyle                        = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth              = 1.3;
    lineStyle.lineColor              = [CPTColor blackColor];
    lineStyle.dashPattern       = [NSArray arrayWithObjects:[NSNumber numberWithFloat:2.0f], [NSNumber numberWithFloat:2.0f], nil];
    wallstreetLinePlot.dataLineStyle = lineStyle;
    wallstreetLinePlot.identifier    = @"Wall Street";
    wallstreetLinePlot.dataSource    = self;
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyleBlack = [CPTMutableLineStyle lineStyle];
    symbolLineStyleBlack.lineColor = [CPTColor blackColor];
    CPTPlotSymbol *plotSymbolBlack = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbolBlack.fill          = [CPTFill fillWithColor:[CPTColor blackColor]];
    plotSymbolBlack.lineStyle     = symbolLineStyleBlack;
    plotSymbolBlack.size          = CGSizeMake(2.0, 2.0);
    wallstreetLinePlot.plotSymbol = plotSymbolBlack;
    
    // Put an area gradient under the plot above
   // CPTColor *areaColor       = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
   // CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
   // areaGradient.angle               = -90.0;
   // areaGradientFill                 = [CPTFill fillWithGradient:areaGradient];
  //  dataSourceLinePlot.areaFill      = areaGradientFill;
    // dataSourceLinePlot.areaBaseValue = CPTDecimalFromDouble(1.75);
    
    [graph addPlot:wallstreetLinePlot];
    // Animate in the new plot, as an example
    //dataSourceLinePlot.opacity = 0.0;
    
    
    //CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //fadeInAnimation.duration            = 1.0;
    //fadeInAnimation.removedOnCompletion = NO;
    //fadeInAnimation.fillMode            = kCAFillModeForwards;
    //fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    //[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
    
    //Create Green Plot
    // Create a black plot
    CPTScatterPlot *actualPlotLine = [[CPTScatterPlot alloc] init];
    lineStyle                        = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth              = 1.3;
    lineStyle.lineColor              = [CPTColor greenColor];
    actualPlotLine.dataLineStyle = lineStyle;
    actualPlotLine.identifier    = @"Actual";
    actualPlotLine.dataSource    = self;
    
    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyleGreen = [CPTMutableLineStyle lineStyle];
    symbolLineStyleGreen.lineColor = [CPTColor greenColor];
    CPTPlotSymbol *plotSymbolGreen = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbolGreen.fill          = [CPTFill fillWithColor:[CPTColor greenColor]];
    plotSymbolGreen.lineStyle     = symbolLineStyleGreen;
    plotSymbolGreen.size          = CGSizeMake(2.0, 2.0);
    actualPlotLine.plotSymbol = plotSymbolGreen;

     [graph addPlot:actualPlotLine];
    

    
}
-(void)changePlotRange
{
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0 + 2.0 * rand() / RAND_MAX)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(3.0 + 2.0 * rand() / RAND_MAX)];
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if(isEPS){
        return [dataForEPSPlot count];
    }else{
        return [dataForREVPlot count];
    }
    return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"FQ" : @"y");
    NSNumber *num;
    if(isEPS){
        num = [[dataForEPSPlot objectAtIndex:index] valueForKey:key];
    }else{
        num = [[dataForREVPlot objectAtIndex:index] valueForKey:key];
    }
   
    
    // Green plot gets shifted above the blue
    if ( [(NSString *)plot.identifier isEqualToString : @"Wall Street"] ) {
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            num = [NSNumber numberWithDouble:[num doubleValue]];
        }
    }
    if ( [(NSString *)plot.identifier isEqualToString : @"Actual"] ) {
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            if(index == (NUMBER_OF_QUARTERS-1)){
                return nil;
            }
            num = [NSNumber numberWithDouble:[num doubleValue] +1.0];
        }
    }
    if ( [(NSString *)plot.identifier isEqualToString : @"Estimize"] ) {
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            num = [NSNumber numberWithDouble:[num doubleValue] - 0.5];
        }
    }
    return num;
}

- (NSDictionary *) getEPSEstimatesForQuarterIndex: (NSNumber *) index
{
    double index_double = index.doubleValue;
    if((index_double>=NUMBER_OF_QUARTERS) || (index_double<0.0)){
        return nil;
    }

    NSUInteger i = index.unsignedIntegerValue;
    NSNumber *wallstreetEPS =  [[dataForEPSPlot objectAtIndex:i] valueForKey:@"y"];
    NSNumber *actualEPS = [NSNumber numberWithDouble:[wallstreetEPS doubleValue] + 1.0];
    NSNumber *estimizeEPS = [NSNumber numberWithDouble:[wallstreetEPS doubleValue] - 0.5];
    
    NSDictionary * returnDict = [NSDictionary dictionaryWithObjectsAndKeys:wallstreetEPS,@"wallstreet",actualEPS,@"actual",estimizeEPS,@"estimize", nil];
    return returnDict;
    
}

- (NSDictionary *) getREVEstimatesForQuarterIndex: (NSNumber *) index
{
    double index_double = index.doubleValue;
    if((index_double>=NUMBER_OF_QUARTERS) || (index_double<0.0)){
        return nil;
    }
    
    NSUInteger i = index.unsignedIntegerValue;
    
    NSNumber *wallstreetREV =  [[dataForREVPlot objectAtIndex:i] valueForKey:@"y"];
    NSNumber *actualREV = [NSNumber numberWithDouble:wallstreetREV.doubleValue + 1.0];
    NSNumber *estimizeREV = [NSNumber numberWithDouble:wallstreetREV.doubleValue - 0.5];
    NSDictionary * returnDict = [NSDictionary dictionaryWithObjectsAndKeys:wallstreetREV,@"wallstreet",actualREV,@"actual",estimizeREV,@"estimize", nil];
    return returnDict;
    
}
#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle *positiveStyle = nil;
    static CPTTextStyle *negativeStyle = nil;
    
    NSFormatter *formatter = axis.labelFormatter;
    CGFloat labelOffset    = axis.labelOffset;
    NSDecimalNumber *zero  = [NSDecimalNumber zero];
    
    NSMutableSet *newLabels = [NSMutableSet set];
    
    for ( NSDecimalNumber *tickLocation in locations ) {
        CPTTextStyle *theLabelTextStyle;
        
        if ( [tickLocation isGreaterThanOrEqualTo:zero] ) {
            if ( !positiveStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            theLabelTextStyle = positiveStyle;
        }
        else {
            if ( !negativeStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            theLabelTextStyle = negativeStyle;
        }
        
        NSString *labelString       = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer *newLabelLayer = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
        
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation = tickLocation.decimalValue;
        newLabel.offset       = labelOffset;
        
        [newLabels addObject:newLabel];
    }
    
    axis.axisLabels = newLabels;
    
    return NO;
}

///////////////////////////////////////////
//                                       //
//      Scatter Plot Delegate            //
//                                       //
//                                       //
///////////////////////////////////////////


- (void) scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSString * resultQuarter = [dataForQuarters objectAtIndex:index];
    quarterSelected = resultQuarter;
    self.quarterSelectedIndex = [NSNumber numberWithUnsignedInteger:index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FiscalQuarterNotification" object:self];
    NSLog(@"Plot Symbol Touched at %@",resultQuarter);
    
    
}


- (NSString *) getNextQuarter
{
    double num = self.quarterSelectedIndex.doubleValue;
    NSLog(@"Quarter next = %f",num);
    if((num+1.0)<NUMBER_OF_QUARTERS){
        NSLog(@"NEXT QUARTER ");
        NSString * stringToReturn = [dataForQuarters objectAtIndex:(num+1.0)];
        self.quarterSelectedIndex = [NSNumber numberWithDouble:(num+1.0)];
        self.quarterSelected = stringToReturn;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FiscalQuarterNotification" object:self];
        return stringToReturn;
    }else{
        NSLog(@"NOTHING! 2222 ");
        return nil;
    }
}
- (NSString *) getLastQuarter
{
    double num = self.quarterSelectedIndex.doubleValue;
     NSLog(@"Quarter last = %f",num);
    if(!num){
        return nil;
    }
    if((num-1.0)>=0){
        NSString * stringToReturn = [dataForQuarters objectAtIndex:(num-1.0)];
        self.quarterSelectedIndex = [NSNumber numberWithDouble:(num-1.0)];
        self.quarterSelected = stringToReturn;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FiscalQuarterNotification" object:self];
        return stringToReturn;
    }else{
        return nil;
    }

}
//Method called to switch between Rev and EPS graphs
- (void) redrawGraph
{
    [graph reloadData];
    [self setupPlot];
    NSLog(@"User wants new graph");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
