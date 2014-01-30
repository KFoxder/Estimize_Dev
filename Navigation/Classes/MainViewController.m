//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "MainViewController.h"
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

NSString * const SPLASH_BACKGROUND_IMAGE = @"splashScreenBackground.png";

NSString * const SPLASH_BACKGROUND_LOGO_IMAGE = @"estimize_splash_background_Logo_v1.png";

@interface MainViewController () 


@end

@implementation MainViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self setupGestures];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Set Splash Screen background image to frame of window
    UIImage *backgroundImage = [UIImage imageNamed:SPLASH_BACKGROUND_IMAGE];
    coverImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [coverImageView setFrame:[[UIScreen mainScreen] bounds]];
    
    //Set Splash Screen Logo Image
    UIImage *logoImage = [UIImage imageNamed:SPLASH_BACKGROUND_LOGO_IMAGE];
    coverImageViewTitle = [[UIImageView alloc] initWithImage:logoImage];
    CGRect rect = CGRectMake( 112, 178, 96, 104);
    [coverImageViewTitle setFrame:rect];
    
    
    
   [self.view addSubview:coverImageView];
   [self.view addSubview:coverImageViewTitle];
    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    
    //Animate Splash Screen
    [UIView animateWithDuration:0.5f delay:1.0f options:nil animations:^(void) {
        [coverImageView setAlpha:0.0];
        [coverImageViewTitle setAlpha:0.5];
        coverImageViewTitle.frame = CGRectMake(11, 4, 24, 26);
        
    } completion:^(BOOL finished){
        [coverImageView removeFromSuperview];
        [coverImageViewTitle removeFromSuperview];
    }];

}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

- (void)setupView
{

    self.centerViewController = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    _navController = [[UINavigationController alloc] initWithRootViewController:_centerViewController];
    [_navController setNavigationBarHidden:YES];
    [self.view addSubview:_navController.view];
    [self addChildViewController:_navController];
    
    [_navController didMoveToParentViewController:self];
    /*
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:_centerViewController];
    
    [_centerViewController didMoveToParentViewController:self];
     */
     
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value)
    {
        [_navController.view.layer setCornerRadius:CORNER_RADIUS];
        [_navController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_navController.view.layer setShadowOpacity:0.8];
        [_navController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [_navController.view.layer setCornerRadius:0.0f];
        [_navController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (_leftPanelViewController != nil)
    {
        NSLog(@"Released left Panel View Controller");
        [self.leftPanelViewController.view removeFromSuperview];
        [self.leftPanelViewController removeFromParentViewController];
        self.leftPanelViewController = nil;
        
        _centerViewController.leftButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
    
    // Enable the swipeRight function to show panel
    [_swipeGesture setEnabled:YES];
    
    //Disable the swipeLeft and tap function to remove panel
    [_tapToMoveCenterRight setEnabled:NO];
}

- (UIView *)getLeftView
{    
    // init view if it doesn't already exist
    if (self.leftPanelViewController == nil)
    {
        NSLog(@"Left Panel View Controller didn't exist");
        // this is where you define the view for the left panel
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_PANEL_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:self.leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    // Return LeftPanelViewController View
    return self.leftPanelViewController.view;
   
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures
{
    
    //Setup right swip gesture for center view (Enabled initially)
    
    _swipeGesture = [[UIPanGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(swiped:)];
    [_swipeGesture setDelegate:self];
    [self.centerViewController.view addGestureRecognizer:_swipeGesture];

    //Setup tap gesture for center view when you want to pull it back (Not Enabled initially)
    
    _tapToMoveCenterRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToMoveLeft:)];
    [_tapToMoveCenterRight setDelegate:self];
    [_tapToMoveCenterRight setEnabled:NO];
    [self.centerViewController.view addGestureRecognizer:_tapToMoveCenterRight];

}

#pragma mark SwipedRight is called when pan gesture is noticed
-(void)swiped:(UIPanGestureRecognizer *) sender
{
    CGPoint vel = [sender velocityInView:self.view];
    if (vel.x > 0)
    {
        // user dragged towards the right
        NSLog(@"Swiped Right");
        if(sender.state == UIGestureRecognizerStateBegan){
            if(!self.showingLeftPanel){
                NSLog(@"Swiped Right Begin");
                [self movePanelRight];
            }
        }else if(sender.state == UIGestureRecognizerStateEnded){
            NSLog(@"Swiped Right Ended!");
            //[sender setEnabled:NO];
        }
    }else if(vel.x <0){
        // user dragged towards the left
        NSLog(@"Swiped left");
        if(sender.state == UIGestureRecognizerStateBegan){
            if(self.showingLeftPanel){
                NSLog(@"Swiped Left Begin");
                [self movePanelToOriginalPosition];
            }
        }else if(sender.state == UIGestureRecognizerStateEnded){
            NSLog(@"Swiped Left Ended!");
            //[sender setEnabled:NO];
        }

    }
    
            
}


#pragma mark SwipedRight is called when pan gesture is noticed
-(void)tapToMoveLeft:(UITapGestureRecognizer *) sender
{
    if(sender){
        [self movePanelToOriginalPosition];
        [sender setEnabled:NO];
    }
    
}

///////////////////////////////////////
//                                   //
//  UIGestureRecognizer Delegate     //
//                                   //
///////////////////////////////////////

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer isEqual:self.swipeGesture]){
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark Delegate Actions


- (void)movePanelRight // to show left panel
{
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             _centerViewController.leftButton.tag = 0;
                             [_tapToMoveCenterRight setEnabled:YES];
                         }
                     }];
}

- (void)movePanelToOriginalPosition
{
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _navController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                         }
                     }];
}

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
