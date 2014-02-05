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

@property (nonatomic,strong) UITableView *watchlistTableView;
@end
