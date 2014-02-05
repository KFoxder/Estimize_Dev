//
//  DetailTickerViewController.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/23/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TickerItem,DetailTickerGraphViewController;

@interface DetailTickerViewController : UIViewController 
{
    TickerItem * tickerItem;
    BOOL tickerInWatchlist;
}
@property (weak, nonatomic) IBOutlet UILabel *tickerTitle;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *watchlistButton;
@property (strong, nonatomic) DetailTickerGraphViewController * graphViewController;
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UIButton *EPSButton;
@property (weak, nonatomic) IBOutlet UIButton *REVButton;
@property (weak, nonatomic) IBOutlet UIView *AllEstimatesView;
- (IBAction)addToWatchlist:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *forwardQuarterButton;
@property (weak, nonatomic) IBOutlet UIButton *backQuarterButton;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;

@property (weak, nonatomic) IBOutlet UILabel *actualEPS;
@property (weak, nonatomic) IBOutlet UILabel *actualREV;
@property (weak, nonatomic) IBOutlet UILabel *estimizeEPS;
@property (weak, nonatomic) IBOutlet UILabel *estimizeREV;
@property (weak, nonatomic) IBOutlet UILabel *wallstreetEPS;
@property (weak, nonatomic) IBOutlet UILabel *wallstreetREV;




-(id) initWithTicker: (TickerItem *) ticker;
- (IBAction)cancel:(id)sender;
- (IBAction) addEstimate:(id)sender;
- (IBAction)toggleGraph:(id)sender;
- (IBAction)goBackQuarter:(id)sender;
- (IBAction)goForwardQuarter:(id)sender;

@end
