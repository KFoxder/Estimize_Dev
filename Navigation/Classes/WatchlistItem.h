//
//  WatchlistItem.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TickerItem;
@interface WatchlistItem : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic) double orderValue;
@property  (nonatomic, retain) TickerItem * tickerObject;
@property (nonatomic, retain) NSString * tickerName;
@property (nonatomic, retain) NSString * ticker;

@end
