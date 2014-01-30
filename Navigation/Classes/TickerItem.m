//
//  TickerItem.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "TickerItem.h"

@interface TickerItem()

//@property (retain,readwrite) NSArray * releaseDates;

@end

@implementation TickerItem

@dynamic dataLink;
@dynamic fullName;
@dynamic symbol;
@dynamic releaseDates;

- (void) awakeFromFetch
{
    [super awakeFromFetch];
    
    NSDate * date = [NSDate date];
    NSArray * dates = [NSArray arrayWithObject:date];
    
    //Switch up dates
    if([self.symbol isEqualToString:@"AAPL"]){
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:-1];
        
        NSDate * dateTemp = [[NSCalendar currentCalendar]
                             dateByAddingComponents:dateComponents
                             toDate:date options:0];
        dates = [NSArray arrayWithObject:dateTemp];
    }else if([self.symbol isEqualToString:@"GS"]){
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:+1];
        
        NSDate * dateTemp = [[NSCalendar currentCalendar]
                             dateByAddingComponents:dateComponents
                             toDate:date options:0];
        dates = [NSArray arrayWithObject:dateTemp];
    }
    self.releaseDates = dates;
    
}
@end
