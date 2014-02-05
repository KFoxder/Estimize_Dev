//
//  EstimateItem.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "EstimateItem.h"
#import "TickerItem.h"
#import "TickerItemStore.h"

@implementation EstimateItem
@synthesize tickerSymbol,tickerReleaseType,tickerCompanyName,estimateFQ,userHandle,userFullName;

- (id) initWithJSONDictionary:(NSDictionary *)dict
{
    self = [self init];
    if(self){
        tickerSymbol = [dict objectForKey:@"tickerSymbol"];
        userHandle = [dict objectForKey:@"username"];
        userFullName = [dict objectForKey:@"userFullName"];
        estimateFQ = [dict objectForKey:@"estimateFQ"];
        [self completeInit];
        
    }
    return self;
}

- (void) completeInit
{
    if(tickerSymbol){
        TickerItem * ticker = [[TickerItemStore defaultStore] getTickerWithSymbol:tickerSymbol];
        if(ticker){
            tickerCompanyName = [ticker companyName];
            NSArray * releaseInfo = [ticker getReleaseInfoForFQ:estimateFQ];
            tickerReleaseType = [releaseInfo objectAtIndex:1];
            
        }
    }
}
@end
