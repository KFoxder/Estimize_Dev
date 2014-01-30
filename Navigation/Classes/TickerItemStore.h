//
//  TickerItemStore.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TickerItem;
@interface TickerItemStore : NSObject
{
    NSMutableArray *allItems;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

- (NSString *) itemArchivePath;
+ (TickerItemStore *) defaultStore;
- (NSArray *) allItems;
- (TickerItem *) createItem;

-(BOOL) removeItem: (TickerItem *) itemToRemove;
- (void) loadAllItems;
- (BOOL) saveChanges;

-(TickerItem *) getTickerWithSymbol:(NSString *) symbolString;
- (NSArray *) getTickersWithDate: (NSDate *) date;

@end
