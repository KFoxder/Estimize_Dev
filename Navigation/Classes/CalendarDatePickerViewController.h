//
//  CalendarDatePickerViewController.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDatePickerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneSelection:(id)sender;

@end
