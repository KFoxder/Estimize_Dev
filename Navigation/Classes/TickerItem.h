//
//  TickerItem.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TickerItem : NSManagedObject

@property (nonatomic, retain) NSString * dataLink;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSArray * releaseDates;

@end
