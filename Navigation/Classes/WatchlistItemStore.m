//
//  WatchlistItemStore.m
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

#import "WatchlistItemStore.h"
#import "WatchlistItem.h"
#import "TickerItem.h"


@implementation WatchlistItemStore

+ (WatchlistItemStore *) defaultStore;
{
    static WatchlistItemStore * store = nil;
    
    if(!store){
        store = [[super allocWithZone:nil] init];
    }
    
    return store;
}

- (id) init
{
    self = [super init];
    
    if(self){
        
        //Read in Watchlist.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        //Get our file path to store SQLite file
        NSString * path = [self itemArchivePath];
        
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        BOOL success = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];

        if(!success){
            [NSException raise:@"Open Watchlist Store failed" format:@"Reason : %@", [error localizedDescription]];
        }
        
        //Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        //The managed object context can manage undo, but we don't need it
        [context setUndoManager:nil];
        
        
        
        
        //call loadAllItems method
        [self loadAllItems];
        
        
    }
    
    return self;
}
- (WatchlistItem *) createItem
{
    double order;
    if([allItems count] ==0){
        order = 1.0;
    }else{
        order = [[allItems lastObject] orderValue] +1.0;
    }


    WatchlistItem * item = [NSEntityDescription insertNewObjectForEntityForName:@"WatchlistItem" inManagedObjectContext:context];
    [item setOrderValue:order];

    
    
    [allItems addObject:item];
    
    return item;
}
-(BOOL) removeItem: (WatchlistItem *) itemToRemove
{
    NSArray * items = [self allItems];
    if(items && itemToRemove){
        if(items.count!=0){
            
            for(int x = 0;x<items.count;x++){
                WatchlistItem * item = [items objectAtIndex:x];
                if([item.ticker isEqualToString:itemToRemove.ticker]){
                    [context deleteObject:item];
                    [allItems removeObjectAtIndex:x];
                    NSLog(@"Deleted Watchlist Item, %@",[itemToRemove ticker]);
                }
            }
            
            
        }
        
    }
    return YES;
}

- (void) loadAllItems
{
    if(!allItems){
        NSLog(@"Loading all Items");
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"WatchlistItem"];
        [request setEntity:e];
        
        //Sort the way watchlist items are loaded
       // NSSortDescriptor * sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"orderValue" ascending:YES];
        //[request setSortDescriptors:sortDesc];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if(!result){
            [NSException raise:@"Method (loadAllItems) failed" format:@"Reason : %@",[error localizedDescription]];
        }
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *) allItems
{
    return allItems;
}

-(BOOL) saveChanges
{
    NSError *err = nil;
    BOOL success = [context save:&err];
    if(!success){
        NSLog(@"Error Saving Watchlist file : %@", [err localizedDescription]);
    }
    return success;
}


- (NSString *) itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"watchlist.data"];
}

//Method checks if the a ticker is in the user's watchlist

- (BOOL) tickerIsInWatchlist: (TickerItem *) tickerToTest
{
    //Check if tickerToTest is not not null
    if(!tickerToTest){
        return YES;
    }
    
    NSString * symbol = [tickerToTest symbol];
    

    
    //Iteratore through items and make sure the symbol isn't in the watchlist Item
    for(WatchlistItem * watchlistItem in [self allItems]){
        NSString * watchlistTickerSymbol = [watchlistItem ticker];
        if([symbol isEqualToString:watchlistTickerSymbol]){
            return YES;
        }
    }
    
    //If none of them match then we return NO
    return NO;
    
}
@end
