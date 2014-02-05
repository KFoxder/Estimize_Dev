//
//  TickerItem.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TickerItem : NSObject

@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSArray * releaseInfo;

-(id) initWithJSONDictionary:(NSDictionary *) dict;

- (NSArray *) getReleaseInfoForDate: (NSDate *) searchDate;
- (NSArray *) getReleaseInfoForFQ:(NSString *) FQString;

@end
