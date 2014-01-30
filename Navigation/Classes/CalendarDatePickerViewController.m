//
//  CalendarDatePickerViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/28/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "CalendarDatePickerViewController.h"

@interface CalendarDatePickerViewController ()

@end

@implementation CalendarDatePickerViewController
@synthesize datePicker,doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDatePicker];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) setupDatePicker
{
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
}

-(void) dateChanged: (id) sender
{
    NSDate * date = self.datePicker.date;
    if([self.parentViewController respondsToSelector:@selector(dateChangedTo:)]){
        [self.parentViewController performSelector:@selector(dateChangedTo:) withObject:date];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneSelection:(id)sender {
    UIViewController * parent = self.parentViewController;
    NSLog(@"%@",[parent nibName]);
    if([parent respondsToSelector:@selector(enableTopButtons)]){
        NSLog(@"Responds");
        [parent performSelector:@selector(enableTopButtons)];
    }
    [UIView animateWithDuration:0.8f animations:^(void){
        [self.view setFrame:CGRectMake(0, 900, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished){
        if(finished){
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
    
    
    
}
@end
