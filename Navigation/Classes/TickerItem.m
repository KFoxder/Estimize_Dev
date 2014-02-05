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
@synthesize symbol,companyName,releaseInfo;

-(id) initWithJSONDictionary:(NSDictionary *) dict
{
    self = [self init];
    
    if(self){
        symbol = [dict objectForKey:@"symbol"];
        companyName = [dict objectForKey:@"companyName"];
        releaseInfo = [dict objectForKey:@"releaseInfo"];
    }
    return self;
}

- (NSArray *) getReleaseInfoForDate: (NSDate *) searchDate
{
    if(!searchDate){
        return nil;
    }
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:searchDate];
    NSDate * searchDateTemp = [calendar dateFromComponents:components];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];

    if(!releaseInfo){
        return nil;
    }else{
        for(NSArray * info in releaseInfo){
            NSString * releaseDateString = [info lastObject];
            if(releaseDateString){
                NSDate * releaseDate = [dateFormatter dateFromString:releaseDateString];
                if(releaseDate){
                    components = [calendar components:flags fromDate:releaseDate];
                    NSDate * releaseDateTemp = [calendar dateFromComponents:components];
                    if([releaseDateTemp isEqualToDate:searchDateTemp]){
                        return info;
                    }
                }
            }
            
            
        }
    }
    return nil;
}

- (NSArray *) getReleaseInfoForFQ:(NSString *) FQString
{
    if(!releaseInfo || !FQString || [FQString isEqualToString:@""]){
        return nil;
    }else{
        for(NSArray * info in releaseInfo){
            NSString * releaseFQString = [info firstObject];
            if([releaseFQString isEqualToString:FQString]){
                return info;
            }
            
        }
    }
    return nil;
}
@end
