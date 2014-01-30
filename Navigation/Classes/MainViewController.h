//
//  MainViewController.h
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"

@class LeftPanelViewController;

@interface MainViewController : UIViewController <CenterViewControllerDelegate, UIGestureRecognizerDelegate>
{
    UIImageView *coverImageView;
    UIImageView *coverImageViewTitle;
}


@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) CenterViewController *centerViewController;
@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, strong) UIPanGestureRecognizer * swipeGesture;
@property (nonatomic, strong) UITapGestureRecognizer * tapToMoveCenterRight;

@property (nonatomic, assign) BOOL showingLeftPanel;


@end
