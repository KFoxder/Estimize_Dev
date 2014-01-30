//
//  WatchlistViewController.h
//  Navigation
//
//  Created by Richard Fox on 1/22/14.
//  Copyright (c) 2014 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchlistViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
   
}

@property (weak, nonatomic) IBOutlet UITableView *watchlistTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@end
