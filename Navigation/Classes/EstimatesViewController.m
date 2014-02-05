//
//  EstimatesViewController.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "EstimatesViewController.h"
#import "EstimatesCell.h"
#import "EstimateItem.h"
#import "EstimatesStore.h"
#import "TickerItem.h"
#import "TickerItemStore.h"
#import "DetailTickerViewController.h"

@interface EstimatesViewController ()

@end

@implementation EstimatesViewController
@synthesize estimatesTableView;

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
    // Do any additional setup after loading the view from its nib.
    [self loadEstimates];
    [self setupTableView];
    
    
}
-(void)setupTableView
{
    
    UINib * nib = [UINib nibWithNibName:@"EstimatesCell" bundle:nil];
    
    estimatesTableView = [[UITableView alloc] init];
    [estimatesTableView setDelegate:self];
    [estimatesTableView setDataSource:self];
    CGRect frame = CGRectInset(self.view.frame, 10, 10);
    [estimatesTableView setFrame:frame];
    [estimatesTableView registerNib:nib forCellReuseIdentifier:@"EstimateCell"];

    [self.view addSubview:estimatesTableView];
}

-(void) loadEstimates
{
    EstimatesStore * store = [[EstimatesStore alloc] init];
    NSArray * allEstimates = [store allItems];
    self.estimates = [NSMutableArray arrayWithArray:allEstimates];
    
}

///////////////////////////////////////
//                                   //
//  TableDataSource Protocol Methods //
//                                   //
///////////////////////////////////////

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.estimates){
        return [self.estimates count];
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"EstimateCell";
    
    EstimatesCell *cell = (EstimatesCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    EstimateItem * estimate = [self.estimates objectAtIndex:indexPath.row];
    [cell.tickerFQ setText:estimate.estimateFQ];
    [cell.tickerSymbol setText:estimate.tickerSymbol];
    [cell.tickerReleaseType setText:estimate.tickerReleaseType];
    [cell.tickerCompanyName setText:estimate.tickerCompanyName];
    [cell.userFullName setText:estimate.userFullName];
    [cell.userHandle setText:estimate.userHandle];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return cell;
}
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



///////////////////////////////////////
//                                   //
//  TableDelegate Protocol Methods   //
//                                   //
///////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    EstimateItem * estimate = [self.estimates objectAtIndex:indexPath.row];
    TickerItem * ticker = [[TickerItemStore defaultStore] getTickerWithSymbol:estimate.tickerSymbol];
    
    if(ticker){
        DetailTickerViewController * dvc = [[DetailTickerViewController alloc] initWithTicker:ticker];
        [[self navigationController] pushViewController:dvc animated:YES];
        
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
