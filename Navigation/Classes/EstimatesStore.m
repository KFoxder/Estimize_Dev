//
//  EstimatesStore.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

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
        url = [NSURL URLWithString:@"https://gist.github.com/KFoxder/8745354/raw/a3ec3b02435e72bd19f14a2380f063b895427276/estimates.json"];
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
