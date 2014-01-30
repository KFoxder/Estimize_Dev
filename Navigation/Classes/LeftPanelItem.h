//
//  LeftPanelItem.h
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftPanelItem : NSObject

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) UIImage * icon;
@property (nonatomic,strong) NSString * link;

-(id) initWithTitle: (NSString *) t Icon: (UIImage *) i andLink: (NSString *) l;

@end
