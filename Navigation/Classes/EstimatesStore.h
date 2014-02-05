//
//  EstimatesStore.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EstimateItem;

@interface EstimatesStore : NSObject
{
    NSMutableArray *allItems;
    NSURL * url;
}

+ (EstimatesStore *) defaultStore;
- (NSArray *) allItems;
- (void) loadAllItems;
@end
