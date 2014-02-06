//
//  EstimatesStore.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#define ESTIMATES_JSON_URL @"https://raw2.github.com/KFoxder/Estimize_Data/master/Estimates.json"

#import "EstimatesStore.h"
#import "EstimatesJSONLoader.h"

@implementation EstimatesStore

+ (EstimatesStore *) defaultStore;
{
    static EstimatesStore * store = nil;
    
    if(!store){
        store = [[super allocWithZone:nil] init];
    }
    
    return store;
}

- (id) init
{
    self = [super init];
    
    if(self){
        url = [NSURL URLWithString:ESTIMATES_JSON_URL];
        //call loadAllItems method
        [self loadAllItems];
        
        
    }
    
    return self;
}

- (void) loadAllItems
{
    if(!allItems){
        EstimatesJSONLoader * loader = [[EstimatesJSONLoader alloc] init];
        NSArray * tickers = [loader estimatesFromJSONFile:url];
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
