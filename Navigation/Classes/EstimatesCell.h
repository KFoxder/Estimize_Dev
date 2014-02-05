//
//  EstimatesCell.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimatesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userHandle;
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
@property (weak, nonatomic) IBOutlet UILabel *tickerSymbol;
@property (weak, nonatomic) IBOutlet UILabel *tickerCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *tickerFQ;
@property (weak, nonatomic) IBOutlet UILabel *tickerReleaseType;

@end
