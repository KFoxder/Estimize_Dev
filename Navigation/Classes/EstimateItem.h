//
//  EstimateItem.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstimateItem : NSObject

@property (nonatomic,readonly) NSString * tickerSymbol;
@property (nonatomic,readonly) NSString *userHandle;
@property (nonatomic,readonly) NSString *userFullName;
@property (nonatomic,readonly) NSString *tickerCompanyName;
@property (nonatomic,readonly) NSString *estimateFQ;
@property (nonatomic,readonly) NSString *tickerReleaseType;


- (id) initWithJSONDictionary:(NSDictionary *) dict;
@end
