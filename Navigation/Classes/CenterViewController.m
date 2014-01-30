//
//  CenterViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

NSString * const WATCHLIST_LINK = @"Watchlist";
NSString * const CALENDAR_LINK = @"Calendar";
NSString * const HOME_LINK = @"Home";
NSString * const ESTIMATES_LINK = @"Estimates";
NSString * const RANKINGS_LINK = @"Rankings";
NSString * const SECTORS_LINK = @"Sectors";
NSString * const PROFILE_LINK = @"Profile";


#import "CenterViewController.h"
#import "WatchlistViewController.h"
#import "LeftPanelItem.h"
#import "CalendarViewController.h"


@interface CenterViewController ()




@end

@implementation CenterViewController
@synthesize mainViewController,centerView;


#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [self setCenterView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)btnMovePanelRight:(id)sender
{
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark Delagate Method for capturing selected image




- (void)itemSelected:(LeftPanelItem *) item
{
    // only change the main display if a left panel item is selected
    if (item)
    {
        [self showItemSelected:item];
    }
}

// Setup the view for our item selected from left panel
// and move center view panel back to front

- (void)showItemSelected:(LeftPanelItem *)itemSelected
{
    NSString * link = [itemSelected link];
    NSLog(@"%@",link);
    if(link){
        if([link isEqual:WATCHLIST_LINK]){
            [self switchToWatchlist];
            
        }else if([link isEqual:HOME_LINK]){
            
        }else if([link isEqual:ESTIMATES_LINK]){
            
        }else if([link isEqual:RANKINGS_LINK]){
            
        }else if([link isEqual:CALENDAR_LINK]){
            [self switchToCalendarView];
            
        }
        
        [_delegate movePanelToOriginalPosition];
    }

}


#pragma mark Switching between Views
//Returns Watchlsit view but also sets view and viewController
- (UIView *) getWatchlistView
{
    // init view if it doesn't already exist
    if (mainViewController == nil)
    {
        // this is where you define the view for the WatchListView
        self.mainViewController = [[WatchlistViewController alloc] initWithNibName:@"WatchlistViewController" bundle:nil];
        // self.centerViewController.view.tag = LEFT_PANEL_TAG;
        //self.centerViewController.delegate = _centerViewController;
        
        [self.centerView addSubview:self.mainViewController.view];
        [self addChildViewController:mainViewController];
        [mainViewController didMoveToParentViewController:self];
        
        mainViewController.view.frame = CGRectMake(0, 0, self.centerView.frame.size.width, self.centerView.frame.size.height);
    }
    
    
    
    UIView *view = self.mainViewController.view;
    return view;
    
}
#pragma mark Switch to Watchlist View
- (void) switchToWatchlist
{
    //check if a view is being shown already remove it
    if(self.showingView){
        NSLog(@"Removed view before showing");
        [self.mainViewController.view removeFromSuperview];
        [self.mainViewController removeFromParentViewController];
        self.mainViewController = nil;
        self.showingView = NO;
        
        //Removes rigth button actions if any are set
        [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
       
    }
    
    //Check if getWatchListView returns a view and set flag True
    UIView *childView = [self getWatchlistView];
    
    if(childView){
        //Set showingView to True
        self.showingView = YES;
        
        //Change top label of nav bar to Watchlst
        UILabel * title = (UILabel *) [self.view viewWithTag:2];
        [title setText:WATCHLIST_LINK];
        
        //Change the right button action based on view being shown
        [self changeRightButtonAction];
   
        [self.view setNeedsDisplay];
    }
    
    
}
#pragma mark Switch to Calendar View
- (void) switchToCalendarView
{
    //check if a view is being shown already remove it
    if(self.showingView){
        NSLog(@"Removed view before showing");
        [self.mainViewController.view removeFromSuperview];
        [self.mainViewController removeFromParentViewController];
        self.mainViewController = nil;
        self.showingView = NO;
        
        //Removes rigth button actions if any are set
        [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    //Check if getWatchListView returns a view and set flag True
    UIView *childView = [self getCalendarView];
    
    if(childView){
        //Set showingView to True
        self.showingView = YES;
        
        //Change top label of nav bar to Watchlst
        UILabel * title = (UILabel *) [self.view viewWithTag:2];
        [title setText:CALENDAR_LINK];
        
        //Change the right button action based on view being shown
        [self changeRightButtonAction];
        
        [self.view setNeedsDisplay];
    }
    
    
}

//Returns Watchlsit view but also sets view and viewController
- (UIView *) getCalendarView
{
    // init view if it doesn't already exist
    if (mainViewController == nil)
    {
        // this is where you define the view for the WatchListView
        self.mainViewController = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        
        [self.centerView addSubview:self.mainViewController.view];
        [self addChildViewController:mainViewController];
        [mainViewController didMoveToParentViewController:self];
        
        mainViewController.view.frame = CGRectMake(0, 0, self.centerView.frame.size.width, self.centerView.frame.size.height);
    }
    
    
    
    UIView *view = self.mainViewController.view;
    return view;
    
}



//Changes the right button action based on view being shown
- (void) changeRightButtonAction
{
    [self.rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    // Check what view is being shown in center view container to see what action the right
    // button should have.
    //
    if([mainViewController.nibName isEqualToString:@"WatchlistViewController"]){
        
        if([mainViewController respondsToSelector:@selector(presentDatePicker)]){
            //Set Right button Target to add new Watchlist Item if selected
            [self.rightButton setBackgroundImage:[UIImage imageNamed:@"create_post_icon.png"] forState:UIControlStateNormal];
            [self.rightButton addTarget:mainViewController action:@selector(newWatchlistItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.rightButton setHidden:NO];
        }
    }else if([mainViewController.nibName isEqualToString:@"CalendarViewController"]){
        
        if([mainViewController respondsToSelector:@selector(presentDatePicker:)]){
            [self.rightButton setHidden:NO];
            UIImage * cal = [UIImage imageNamed:@"calendar_icon_white2.png"];
            [self.rightButton setBackgroundImage:cal forState:UIControlStateNormal];
            [self.rightButton addTarget:mainViewController action:@selector(presentDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else{
        [self.rightButton setHidden:YES];
    }
}


#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
