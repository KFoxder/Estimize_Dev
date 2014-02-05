//
//  WatchlistViewController.m
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

NSString * const WATCHLIST_CELL_NIB = @"WatchlistCell";

#define NUMBER_OF_SECTIONS 1

#import "WatchlistViewController.h"
#import "WatchlistItemStore.h"
#import "WatchlistItem.h"
#import "DetailTickerViewController.h"
#import "TickerItem.h"
#import "TickerItemStore.h"
#import "WatchlistItemNewViewController.h"
#import "WatchlistCell.h"


@interface WatchlistViewController ()

@end

@implementation WatchlistViewController

- (id) init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(243.0f/255.0f) green:(243.0f/255.0f) blue:(243.0f/255.0f) alpha:1.0f]];
    
    [self setupWatchlistTableView];

    
    
}

-(void) setupWatchlistTableView
{
    UINib *nib = [UINib nibWithNibName:@"WatchlistCell" bundle:nil];
    CGRect frameInset = CGRectInset(self.view.frame, 15, 15);
    self.watchlistTableView = [[UITableView alloc] initWithFrame:frameInset style:UITableViewStylePlain];
    [self.watchlistTableView setDataSource:self];
    [self.watchlistTableView setDelegate:self];
    [self.watchlistTableView registerNib:nib forCellReuseIdentifier:@"WatchlistCell"];
    [self.view addSubview:self.watchlistTableView];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [self.watchlistTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWatchlistTableView:nil];
    [super viewDidUnload];
}


///////////////////////////////////////
//                                   //
//  TableDataSource Protocol Methods //
//                                   //
///////////////////////////////////////
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WatchlistItemStore * store = [WatchlistItemStore defaultStore];
    if(store){
        NSLog(@"Retreieved WatchlistStore");
        if([store allItems]){
            return [store allItems].count;
        }else{
            return 0;
        }
        
    }
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchlistItemStore * store = [WatchlistItemStore defaultStore];
    NSArray * watchlistItems = [store allItems];
    WatchlistItem * item = [watchlistItems objectAtIndex:indexPath.row];
    NSString * ticker = [item ticker];
    NSString * tickerName = [item tickerName];
    
    WatchlistCell * cell = [self.watchlistTableView dequeueReusableCellWithIdentifier:@"WatchlistCell"];
    
    [cell.fullNameLabel setText:tickerName];
    [cell.symbolLabel setText:ticker];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        WatchlistItemStore * store = [WatchlistItemStore defaultStore];
        NSArray * allItems = [store allItems];
        WatchlistItem * itemToRemove = [allItems objectAtIndex:indexPath.row];
        if(itemToRemove){
            [store removeItem:itemToRemove];
            [store saveChanges];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }
}


///////////////////////////////////////
//                                   //
//  TableDelegate Protocol Methods   //
//                                   //
///////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchlistItemStore * store = [WatchlistItemStore defaultStore];
    NSArray * watchlistItems = [store allItems];
    WatchlistItem * item = [watchlistItems objectAtIndex:indexPath.row];
    NSLog(@" Selected %@",[item tickerName]);
    
  
    
    //Get Watchlist Ticker selected and push detialed ticker view wit Ticker Object
    
    TickerItem * tickerItem = [item tickerObject];
    DetailTickerViewController * tickerView = [[DetailTickerViewController alloc] initWithTicker:tickerItem];
    
    [[self navigationController] pushViewController:tickerView animated:YES];
    
    

    
}

//Method to make new Watchlsit Item
// It is called from the centeViewController right button when selected

- (void) newWatchlistItem: (id) sender
{
    NSLog(@"User wants to add new watchlist Item");
    
    WatchlistItemNewViewController * newWatchListItemVC = [[WatchlistItemNewViewController alloc] init];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self.navigationController pushViewController:newWatchListItemVC animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];
     
}















@end
