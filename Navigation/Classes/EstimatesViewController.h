//
//  EstimatesViewController.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimatesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * estimatesTableView;
@property (nonatomic,strong) NSMutableArray * estimates;

@end
