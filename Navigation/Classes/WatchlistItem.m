//
//  WatchlistItem.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "WatchlistItem.h"
#import "TickerItemStore.h"
#import "TickerItem.h"

@implementation WatchlistItem

@dynamic link;
@dynamic orderValue;
@dynamic tickerObject;
@dynamic tickerName;
@dynamic ticker;

//When we load watchlist items from user iphone we need to get the ticker object
// associated with watchlist item
- (void) awakeFromFetch
{
    [super awakeFromFetch];
    TickerItemStore * store = [TickerItemStore defaultStore];
    TickerItem * tickerObj = [store getTickerWithSymbol:self.ticker];
    if(tickerObj){
        [self setTickerObject:tickerObj];
    }
    
}
@end
