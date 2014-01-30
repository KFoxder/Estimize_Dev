//
//  CalendarViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarDatePickerViewController.h"
#import "TickerItem.h"
#import "TickerItemStore.h"
#import "DetailTickerViewController.h"
#import "CalendarCell.h"
#import "WatchlistItem.h"
#import "WatchlistItemStore.h"
#import "Constants.h"


@interface CalendarViewController ()

@property (nonatomic,strong) UITableView * calendarTableView;
@property (nonatomic,strong) NSArray * tickersForCurrentDate;

@end

@implementation CalendarViewController
@synthesize leftButton,rightButton,calendarMainView,dateLabel;

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
    [self setupDateLabelGestures];
    [self setupDateLabel];
    [self setupTableView];
    
    
}

- (void) setupTableView
{
    UINib * nib = [UINib nibWithNibName:@"CalendarCell" bundle:nil];
    
    
    self.calendarTableView = [[UITableView alloc] init];
    [self.calendarTableView setDelegate:self];
    [self.calendarTableView setDataSource:self];
    [self.calendarTableView setFrame:[[UIScreen mainScreen] bounds]];
    [self.calendarTableView registerNib:nib forCellReuseIdentifier:@"CalendarCell"];
    [self.calendarMainView addSubview:self.calendarTableView];
    
    
    
}
-(void) setupDateLabelGestures
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTap:)];
    [self.dateLabel addGestureRecognizer:tapGesture];
    
}
-(void) dateLabelTap: (UITapGestureRecognizer *) tapGesture
{
    NSLog(@"Tapped Label");
    [self presentDatePicker:self];
    
}
-(void) presentDatePicker: (id) sender
{
    if([sender isKindOfClass:[UIButton class]]){
        [sender setEnabled:NO];
    }
    CalendarDatePickerViewController * datePickerVC = [[CalendarDatePickerViewController alloc] init];
    [datePickerVC.view setFrame:CGRectMake(0, 900, datePickerVC.view.frame.size.width, datePickerVC.view.frame.size.height)];
    [self.calendarMainView addSubview:datePickerVC.view];
    [self addChildViewController:datePickerVC];
    [datePickerVC didMoveToParentViewController:self];
    [self disableTopButtons];
    
    //Animate date Picker
    [UIView animateWithDuration:0.8f delay:0.0f options:nil animations:^(void){
        [datePickerVC.view setFrame:CGRectMake(0, 0, datePickerVC.view.frame.size.width, datePickerVC.view.frame.size.height)];
    }completion:^(BOOL finished){
        
    }];
}
- (void) setupDateLabel
{
    if(!self.currentDate){
        self.currentDate = [NSDate date];
    }
    [self.dateLabel setText:[self getDateString:self.currentDate]];
    [self.view setNeedsDisplay];
    
}

- (NSString *) getDateString: (NSDate *) date
{
    if(!date){
        date = [NSDate date];
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMM, d"];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}

-(IBAction) getLastDate: (id) sender
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
    
    NSDate * lastDate = [[NSCalendar currentCalendar]
                         dateByAddingComponents:dateComponents
                         toDate:self.currentDate options:0];
    [self dateChangedTo:lastDate];

    
}
-(IBAction) getNextDate: (id) sender
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    
    NSDate * nextDate = [[NSCalendar currentCalendar]
                         dateByAddingComponents:dateComponents
                         toDate:self.currentDate options:0];
    [self dateChangedTo:nextDate];
}

- (void) dateChangedTo: (NSDate *) date
{
    if(date){
        self.currentDate = date;
        [self setupDateLabel];
        [self.calendarTableView reloadData];
        
    }
}

- (void) enableTopButtons
{
    [self.leftButton setEnabled:YES];
    [self.rightButton setEnabled:YES];
    [[self.dateLabel.gestureRecognizers objectAtIndex:0] setEnabled:YES];
}
- (void) disableTopButtons
{
    
    [self.leftButton setEnabled:NO];
    [self.rightButton setEnabled:NO];
    [[self.dateLabel.gestureRecognizers objectAtIndex:0] setEnabled:NO];
}



///////////////////////////////////////
//                                   //
//  TableDataSource Protocol Methods //
//                                   //
///////////////////////////////////////

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    TickerItemStore * store = [TickerItemStore defaultStore];
    NSDate * date = self.currentDate;
    NSArray * items = [store getTickersWithDate:date];
    self.tickersForCurrentDate = items;
    return [items count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CalendarCell";
    
    CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    __weak CalendarCell *weakCell = cell;
    [cell setAppearanceWithBlock:^{
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:RED green:GREEN  blue:BLUE alpha:1.0] icon:[UIImage imageNamed:@"Watchlist_Icon_White.png"]];

        weakCell.rightUtilityButtons = rightUtilityButtons;
        weakCell.delegate = self;
        weakCell.containingTableView = tableView;
    } force:NO];
    

    TickerItem * ticker = [self.tickersForCurrentDate objectAtIndex:indexPath.row];
    [cell.symbolLabel setText:[ticker symbol]];
    [cell.fullNameLabel setText:[ticker fullName]];
    [cell setCellHeight:cell.frame.size.height];
    return cell;
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



///////////////////////////////////////
//                                   //
//  TableDelegate Protocol Methods   //
//                                   //
///////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    TickerItem * ticker = [self.tickersForCurrentDate objectAtIndex:indexPath.row];
    if(ticker){
        DetailTickerViewController * tickerView = [[DetailTickerViewController alloc] initWithTicker:ticker];
        
        [[self navigationController] pushViewController:tickerView animated:YES];
    }
}

///////////////////////////////////////
//                                   //
//  SWTableViewCellDelegate Methods   //
//                                   //
///////////////////////////////////////


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            // Watchlist button was pressed
            WatchlistItemStore * watchlistStore = [WatchlistItemStore defaultStore];
            NSIndexPath *cellIndexPath = [self.calendarTableView indexPathForCell:cell];
            TickerItem *tickerSelected = [self.tickersForCurrentDate objectAtIndex:cellIndexPath.row];
            BOOL tickerInWatchlist = [watchlistStore tickerIsInWatchlist:tickerSelected];
            if(!tickerInWatchlist){
                WatchlistItem * newItem = [watchlistStore createItem];
                [newItem setTicker:[tickerSelected symbol]];
                [newItem setTickerName:[tickerSelected fullName]];
                [newItem setTickerObject:tickerSelected];
                [watchlistStore saveChanges];
                
                [cell hideUtilityButtonsAnimated:YES];
            }else{
                UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Add Ticker"
                                                                   message:@"Ticker is already in Watchlist"
                                                                  delegate:self
                                                         cancelButtonTitle:@"Back"
                                                         otherButtonTitles:nil];
                [theAlert show];
                [cell hideUtilityButtonsAnimated:YES];
            }

            break;
        }
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
