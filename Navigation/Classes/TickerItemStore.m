//
//  TickerItemStore.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "TickerItemStore.h"
#import "TickerItem.h"
#import "TickerJSONLoader.h"

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
        url = [NSURL URLWithString:@"https://gist.github.com/KFoxder/8744014/raw/1d3b8ac1236728abfc62fe18a1ce13701f0a4b2c/Tickers.json"];
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
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    NSMutableArray * tickers = [[NSMutableArray alloc] init];
    NSArray * allTickers = [self allItems];
    //iterate through all TickerItems
    for(TickerItem * ticker in allTickers){
        NSArray * releaseDates = [ticker releaseInfo];
        for(NSArray * tickerInfo in releaseDates){
            NSString * dateString = [tickerInfo lastObject];
            NSLog(@"%@",dateString);
            NSDate * tickerDate = [dateFormatter dateFromString:dateString];
            if(tickerDate){
                NSLog(@"COnvert Date Succesful");
                components = [calendar components:flags fromDate:tickerDate];
                NSDate * tickerDateTemp = [calendar dateFromComponents:components];
                if([tickerDateTemp isEqualToDate:dateTemp]){
                    [tickers addObject:ticker];
                }
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


- (void) loadAllItems
{
    if(!allItems){
        TickerJSONLoader * loader = [[TickerJSONLoader alloc] init];
        NSArray * tickers = [loader tickersFromJSONFile:url];
        if(tickers){
            allItems = [NSMutableArray arrayWithArray:tickers];
        }
    }
}

- (NSArray *) allItems
{
    return allItems;
}



@end
