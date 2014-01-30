//
//  CalendarViewController.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CalendarViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIView *calendarMainView;


@property (strong,nonatomic) NSDate * currentDate;

-(IBAction) getLastDate: (id) sender;
-(IBAction) getNextDate: (id) sender;

-(void) presentDatePicker: (id) sender;

@end
