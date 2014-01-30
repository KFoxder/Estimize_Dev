//
//  LeftPanelItem.m
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

#import "LeftPanelItem.h"

@implementation LeftPanelItem
@synthesize title,link,icon;

-(id) initWithTitle: (NSString *) t Icon: (UIImage *) i andLink: (NSString *) l
{
    self = [super init];
    
    if(self){
        [self setTitle:t];
        [self setIcon:i];
        [self setLink:l];
        
    }
    
    return self;
}


@end
