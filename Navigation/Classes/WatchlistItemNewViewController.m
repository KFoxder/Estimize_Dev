//
//  WatchlistItemNewViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "WatchlistItemNewViewController.h"
#import "WatchlistItem.h"
#import "WatchlistItemStore.h"
#import "TickerItem.h"
#import "TickerItemStore.h"
#import "Constants.h"


@interface WatchlistItemNewViewController ()

@property (nonatomic) NSMutableArray *searchResults;

@end

@implementation WatchlistItemNewViewController


///////////////////////////////////////
//                                   //
//  TableDataSource Protocol Methods //
//                                   //
///////////////////////////////////////

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
     */
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        //return search results [self.searchResults count];
        return [self.searchResults count];
    }
    else
    {
        if(self.tickers){
            return [self.tickers count];
        }else{
            return 0;
        }
        
    }
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    /*
     If the requesting table view is the search display controller's table view, configure the cell using the search results array, otherwise use the product array.
     */
    TickerItem * tickerItem;
       
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        tickerItem = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
       tickerItem = [self.tickers objectAtIndex:indexPath.row];
    }
    
    [[cell textLabel] setText:[tickerItem symbol]];

    return cell;
}

///////////////////////////////////////
//                                   //
//  TableDelegate Protocol Methods   //
//                                   //
///////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TickerItem * tickerItem;
    WatchlistItemStore * watchlistStore = [WatchlistItemStore defaultStore];
    //Check which tableView is being used first
    if (tableView == self.searchDisplayController.searchResultsTableView){
        
        tickerItem = [self.searchResults objectAtIndex:indexPath.row];
        BOOL tickerInWatchlist = [watchlistStore tickerIsInWatchlist:tickerItem];
        if(!tickerInWatchlist){
            
            WatchlistItem * newItem = [watchlistStore createItem];
            [newItem setTicker:[tickerItem symbol]];
            [newItem setTickerName:[tickerItem fullName]];
            [newItem setTickerObject:tickerItem];
            [watchlistStore saveChanges];
            
            [self cancel:self];
        }else{
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Add Ticker"
                                                               message:@"Ticker is already in Watchlist"
                                                              delegate:self
                                                     cancelButtonTitle:@"Back"
                                                     otherButtonTitles:nil];
            [theAlert show];
        }
        
    }else{
        
        tickerItem = [self.tickers objectAtIndex:indexPath.row];
        BOOL tickerInWatchlist = [watchlistStore tickerIsInWatchlist:tickerItem];
        if(!tickerInWatchlist){
            WatchlistItem * newItem = [watchlistStore createItem];
            [newItem setTicker:[tickerItem symbol]];
            [newItem setTickerName:[tickerItem fullName]];
            [newItem setTickerObject:tickerItem];
            [watchlistStore saveChanges];
            
            [self cancel:self];
        }else{
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Add Ticker"
                                                               message:@"Ticker is already in Watchlist"
                                                              delegate:self
                                                     cancelButtonTitle:@"Back"
                                                     otherButtonTitles:nil];
            [theAlert show];
            
        }
        
    }
    
}



#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self updateFilteredContentForProductName:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [self.searchDisplayController.searchBar text];
    NSString *scope;
    
    if (searchOption > 0)
    {
       // scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
*/
#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)tickerSearch
{

    // If there is no search string and the scope is chosen.
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    for (TickerItem *ticker in self.tickers)
    {
        if ([ticker.symbol isEqualToString:tickerSearch] || [ticker.fullName isEqualToString:tickerSearch])
        {
            [searchResults addObject:ticker];
        }
    }
    self.searchResults = searchResults;
    
    return;
}

///////////////////////////////////////
//                                   //
//  UISearchBar Delegate Protocol    //
//                                   //
///////////////////////////////////////

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
     [searchBar setBackgroundColor:[UIColor colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setBackgroundColor:[UIColor clearColor]];
}

//Go back to Root View Controller Method
- (void) cancel: (id) sender
{
    NSLog(@"User Went Back");
    if(self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
    
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //Add function to go back to left button
    [self.leftButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    TickerItemStore * store = [TickerItemStore defaultStore];
    NSArray * allTickers = [store allItems];
    self.tickers = allTickers;
    
    if(self.tickers){
        self.searchResults = [[NSMutableArray alloc] initWithCapacity:self.tickers.count];
    }else{
        self.searchResults = [[NSMutableArray alloc] init];
    }
    
    
}
- (void) viewDidAppear:(BOOL)animated
{
    //Set Autofocus on search
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
