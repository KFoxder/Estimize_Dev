//
//  TickerItemStore.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "TickerItemStore.h"
#import "TickerItem.h"

@implementation TickerItemStore

+ (TickerItemStore *) defaultStore;
{
    static TickerItemStore * store = nil;
    
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
            [NSException raise:@"Open Ticker Store failed" format:@"Reason : %@", [error localizedDescription]];
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


- (NSArray *) getTickersWithDate: (NSDate *) date
{
    if(!date){
        return nil;
    }
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate * dateTemp = [calendar dateFromComponents:components];
    
    
    NSMutableArray * tickers = [[NSMutableArray alloc] init];
    NSArray * allTickers = [self allItems];
    //iterate through all TickerItems
    for(TickerItem * ticker in allTickers){
        NSArray * releaseDates = [ticker releaseDates];
        for(NSDate * tickerDate in releaseDates){
            components = [calendar components:flags fromDate:tickerDate];
            NSDate * tickerDateTemp = [calendar dateFromComponents:components];
            if([tickerDateTemp isEqualToDate:dateTemp]){
                [tickers addObject:ticker];
            }
        }
        
    }
    
    NSArray * tickersToReturn = [NSArray arrayWithArray:tickers];
    
    return tickersToReturn;
}

-(TickerItem *) getTickerWithSymbol:(NSString *) symbolString
{
    if(symbolString){
        
        //In production I am sure we will use a webservice to get objects
        // For now we will use iphone storage
        
        NSArray * items = [self allItems];
        
        if(items){
            if(items.count>0){
                
                for(int x = 0;x<items.count;x++){
                    
                    TickerItem * item = [items objectAtIndex:x];
                    if([item.symbol isEqualToString:symbolString]){
                        return item;
                    }
                }
            }
            
        }
        
        
    }
    return nil;
}


- (TickerItem *) createItem
{
    
    TickerItem * item = [NSEntityDescription insertNewObjectForEntityForName:@"TickerItem" inManagedObjectContext:context];
    
    [allItems addObject:item];
    
    return item;
}
-(BOOL) removeItem: (TickerItem *) itemToRemove
{
    NSArray * items = [self allItems];
    if(items && itemToRemove){
        if(items.count!=0){
            
            for(int x = 0;x<items.count;x++){
                
            }
            
            
        }
        
    }
    return YES;
}

- (void) loadAllItems
{
    if(!allItems){
        NSLog(@"Loading all Ticker Items");
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"TickerItem"];
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
    return [documentDirectory stringByAppendingPathComponent:@"tickerlist.data"];
}

@end
