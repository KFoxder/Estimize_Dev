//
//  EstimatesCell.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "EstimatesCell.h"

@implementation EstimatesCell
@synthesize userFullName,userHandle,tickerFQ,tickerCompanyName,tickerReleaseType,tickerSymbol;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
