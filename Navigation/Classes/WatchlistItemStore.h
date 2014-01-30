//
//  WatchlistItemStore.h
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class WatchlistItem;
@class TickerItem;

@interface WatchlistItemStore : NSObject
{
    NSMutableArray *allItems;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

- (NSString *) itemArchivePath;
+ (WatchlistItemStore *) defaultStore;
- (NSArray *) allItems;
- (WatchlistItem *) createItem;

-(BOOL) removeItem: (WatchlistItem *) itemToRemove;
- (void) loadAllItems;
- (BOOL) saveChanges;
- (BOOL) tickerIsInWatchlist: (TickerItem *) tickerToTest;

@end
