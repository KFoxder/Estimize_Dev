//
//  DetailTickerViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/23/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "DetailTickerViewController.h"
#import "TickerItem.h"
#import "DetailTickerGraphViewController.h"
#import "Constants.h"
#import "WatchlistItem.h"
#import "WatchlistItemStore.h"




@interface DetailTickerViewController ()

@end

@implementation DetailTickerViewController
@synthesize tickerTitle,graphView,graphViewController,AllEstimatesView,actualEPS,actualREV,estimizeEPS,estimizeREV,wallstreetEPS,wallstreetREV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithTicker:(TickerItem *)ticker
{
    self = [super initWithNibName:@"DetailTickerViewController" bundle:nil];
    if(self){
        
        tickerItem = ticker;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedQuarter:) name:@"FiscalQuarterNotification" object:nil];
        tickerInWatchlist = [[WatchlistItemStore defaultStore] tickerIsInWatchlist:ticker];
        
    
    }
    return self;
}


-(IBAction) addEstimate: (id)sender
{
    NSLog(@"User switch to add estimate View");
    
}
//Cancel Method to push user back 
- (IBAction)cancel:(id)sender
{
    NSLog(@"User Went Back");
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (IBAction)addToWatchlist:(id)sender {
    WatchlistItemStore * watchlistStore = [WatchlistItemStore defaultStore];
    TickerItem *tickerSelected = tickerItem;
    if(!tickerInWatchlist){
        WatchlistItem * newItem = [watchlistStore createItem];
        [newItem setTicker:[tickerSelected symbol]];
        [newItem setTickerName:[tickerSelected companyName]];
        [newItem setTickerObject:tickerSelected];
        [watchlistStore saveChanges];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Watchlist"
                                                           message:@"Ticker Added to Watchlist!"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        tickerInWatchlist = YES;
        [self.watchlistButton setEnabled:NO];
        
    }else{
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Watchlist Alert"
                                                           message:@"Did not add ticker to Watchlist because Ticker is already in Watchlist."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString * tickerSymbol = tickerItem.symbol;
    [self.tickerTitle setText:tickerSymbol];
    
    //Setup All Estimates View
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AllEstimatesViewBar"
                                                          owner:nil
                                                        options:nil];
    
    [AllEstimatesView addSubview:[arrayOfViews objectAtIndex:0]];
    [AllEstimatesView setBackgroundColor:[UIColor clearColor]];
    [AllEstimatesView setNeedsDisplay];
    
    [self setupGraph];
    [self setupButtons];
    
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [self setupLabel];
    
}
-(void) setupButtons
{
    if(tickerInWatchlist){
        [self.watchlistButton setEnabled:NO];
    }
}
- (void) setupLabel
{
    NSString * quarterSelected = self.graphViewController.quarterSelected;
    while(!quarterSelected){
        quarterSelected = self.graphViewController.quarterSelected;
    }
    NSLog(@"Quarter selected = %@",quarterSelected);
    [self.quarterLabel setText:quarterSelected];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    
    NSNumber * fiscalQuarterIndex = [NSNumber numberWithInt:[self.graphViewController quarterSelectedIndex].intValue];
    NSDictionary * EPSDictionary = [self.graphViewController getEPSEstimatesForQuarterIndex:fiscalQuarterIndex];
    NSNumber * EPS_wallstreet = [EPSDictionary objectForKey:@"wallstreet"];
    NSNumber * EPS_actual = [EPSDictionary objectForKey:@"actual"];
    NSNumber * EPS_estimize = [EPSDictionary objectForKey:@"estimize"];
    
    [wallstreetEPS setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:EPS_wallstreet]]];
    [actualEPS setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:EPS_actual]]];
    [estimizeEPS  setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:EPS_estimize]]];
    
    NSDictionary * REVDictionary = [self.graphViewController getREVEstimatesForQuarterIndex:fiscalQuarterIndex];
    NSNumber * REV_wallstreet = [REVDictionary objectForKey:@"wallstreet"];
    NSNumber * REV_actual = [REVDictionary objectForKey:@"actual"];
    NSNumber * REV_estimize = [REVDictionary objectForKey:@"estimize"];
    
    [wallstreetREV setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:REV_wallstreet]]];
    [actualREV setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:REV_actual]]];
    [estimizeREV  setText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:REV_estimize]]];

    
}
- (void) setupGraph
{
    
    self.graphViewController = [[DetailTickerGraphViewController alloc] init];
    [graphViewController setTickerSelected:tickerItem];
    
    //Defualt graph to EPS
    [graphViewController setIsEPS:YES];
    [self.EPSButton setTitleColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA] forState:UIControlStateSelected];
    [self.REVButton setTitleColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA] forState:UIControlStateSelected];
    [self.EPSButton setSelected:YES];
    
    
    [self.graphView addSubview:graphViewController.view];
    [self addChildViewController:graphViewController];
    [graphViewController didMoveToParentViewController:self];
    
}

- (IBAction)toggleGraph:(id)sender
{
    UIButton * button = (UIButton *) sender;
    
    if([graphViewController isEPS] && [button.titleLabel.text isEqualToString:@"Revenue"]){
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             graphViewController.view.frame = CGRectMake(320, graphViewController.view.frame.origin.y, graphViewController.view.frame.size.width, graphViewController.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 graphViewController.view.frame = CGRectMake(-320, graphViewController.view.frame.origin.y, graphViewController.view.frame.size.width, graphViewController.view.frame.size.height);
                                 NSLog(@"Switching to Rev.");
                                
                                 
                                 [graphViewController redrawGraph];
                                 
                                 [self resetGraphView];
                                 
                             }
                         }];
            
        [self.REVButton setSelected:YES];
        [self.EPSButton setSelected:NO];
        [graphViewController setIsEPS:NO];

    }
    if((![graphViewController isEPS]) && [button.titleLabel.text isEqualToString:@"EPS"]){
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             graphViewController.view.frame = CGRectMake(-320, graphViewController.view.frame.origin.y, graphViewController.view.frame.size.width, graphViewController.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 graphViewController.view.frame = CGRectMake(320, graphViewController.view.frame.origin.y, graphViewController.view.frame.size.width, graphViewController.view.frame.size.height);
                                 NSLog(@"Switching to EPS.");
                                
                                 [graphViewController redrawGraph];
                                 [self resetGraphView];
                                 
                             }
                         }];
        [self.REVButton setSelected:NO];
        [self.EPSButton setSelected:YES];
        [graphViewController setIsEPS:YES];

    }
}


- (void) changedQuarter: (NSNotification *) notification
{

 
    [self setupLabel];
    [self.view setNeedsDisplay];
}


- (IBAction)goBackQuarter:(id)sender {
    
    //Check if we are at the first Quarter
    double index = [self.graphViewController quarterSelectedIndex].doubleValue - 1;
    NSDictionary * dict = [self.graphViewController getEPSEstimatesForQuarterIndex:[NSNumber numberWithDouble:index]];
    if(dict){
        
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _quarterLabel.frame = CGRectMake(-200, _quarterLabel.frame.origin.y, _quarterLabel.frame.size.width, _quarterLabel.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                               _quarterLabel.frame = CGRectMake(320, _quarterLabel.frame.origin.y, _quarterLabel.frame.size.width, _quarterLabel.frame.size.height);
                             [self.graphViewController getLastQuarter];
                             [self resetFQLabel];
                             
                         }
                     }];
    }


}

- (IBAction)goForwardQuarter:(id)sender {
    //Check if we are at the last Quarter
    double index = [self.graphViewController quarterSelectedIndex].doubleValue + 1.0;
    NSDictionary * dict = [self.graphViewController getEPSEstimatesForQuarterIndex:[NSNumber numberWithDouble:index]];
    if(dict){
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _quarterLabel.frame = CGRectMake(320, _quarterLabel.frame.origin.y, _quarterLabel.frame.size.width, _quarterLabel.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _quarterLabel.frame = CGRectMake(-200, _quarterLabel.frame.origin.y, _quarterLabel.frame.size.width, _quarterLabel.frame.size.height);
                             [self.graphViewController getNextQuarter];
                             [self resetFQLabel];
                             
                         }
                     }];
    }
}
- (void) resetFQLabel
{
  
    [UIView animateWithDuration:0.5f delay:0 options:nil
                     animations:^{
                         _quarterLabel.frame = CGRectMake(110, _quarterLabel.frame.origin.y, _quarterLabel.frame.size.width, _quarterLabel.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             
                         }
                     }];
}
- (void) resetGraphView
{
    [UIView animateWithDuration:0.5f delay:0 options:nil
                     animations:^{
                         graphViewController.view.frame = CGRectMake(0, graphViewController.view.frame.origin.y, graphViewController.view.frame.size.width, graphViewController.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             
                         }
                     }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
