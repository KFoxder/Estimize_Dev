//
//  LeftPanelViewController.m
//  SlideoutNavigation
//
//  Created by Tammy Coron on 1/10/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//


NSString * const HOME_ICON_NAME = @"house_icon.png";
NSString * const WATCHLIST_ICON_NAME = @"star_icon.png";
NSString * const ESTIMATES_ICON_NAME = @"estimates_icon.png";
NSString * const RANKINGS_ICON_NAME = @"rank_icon.png";
NSString * const DEFAULT_PROFILE_ICON_NAME = @"defaultProfile_icon.png";
NSString * const CALENDAR_ICON_NAME = @"calendar_icon.png";
NSString * const SECTORS_ICON_NAME = @"sector_icon.png";
NSString * const LOGOUT_ICON_NAME = @"logout_icon.png";
NSString * const SETTINGS_ICON_NAME = @"gear_icon.png";

#define MAIN_CELL_HEIGHT 34
#define PROFILE_CELL_HEIGHT 60
#define NUMBER_SECTIONS 3


#import "LeftPanelViewController.h"
#import "LeftPanelItem.h"

@interface LeftPanelViewController ()

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellMain;
@property (nonatomic, weak) IBOutlet UITableViewCell *cellProfile;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@property (nonatomic, strong) NSMutableArray *arrayOfItems;

@property (nonatomic, strong) NSMutableArray *arrayOfBottomItems;

@end

@implementation LeftPanelViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLeftPanelItems];
}

- (void)viewDidUnload
{
    [self setTopBarView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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
#pragma mark Array Setup

- (void)setupLeftPanelItems
{

    LeftPanelItem * home = [[LeftPanelItem alloc] initWithTitle:@"Home" Icon:[UIImage imageNamed:HOME_ICON_NAME] andLink:@"Home"];
    LeftPanelItem * watchList = [[LeftPanelItem alloc] initWithTitle:@"Watchlist" Icon:[UIImage imageNamed:WATCHLIST_ICON_NAME] andLink:@"Watchlist"];
    LeftPanelItem * estimates = [[LeftPanelItem alloc] initWithTitle:@"Estimates" Icon:[UIImage imageNamed:ESTIMATES_ICON_NAME] andLink:@"Estimates"];
    LeftPanelItem * rankings = [[LeftPanelItem alloc] initWithTitle:@"Rankings" Icon:[UIImage imageNamed:RANKINGS_ICON_NAME] andLink:@"Rankings"];
    LeftPanelItem * calendar = [[LeftPanelItem alloc] initWithTitle:@"Calendar" Icon:[UIImage imageNamed:CALENDAR_ICON_NAME] andLink:@"Calendar"];
     LeftPanelItem * sectors = [[LeftPanelItem alloc] initWithTitle:@"Sectors" Icon:[UIImage imageNamed:SECTORS_ICON_NAME] andLink:@"Sectors"];
    
    
    LeftPanelItem * logout = [[LeftPanelItem alloc] initWithTitle:@"Logout" Icon:[UIImage imageNamed:LOGOUT_ICON_NAME] andLink:@"Logout"];
    LeftPanelItem * settings = [[LeftPanelItem alloc] initWithTitle:@"Settings" Icon:[UIImage imageNamed:SETTINGS_ICON_NAME] andLink:@"Settings"];
    
    NSArray * items = [NSArray arrayWithObjects: home,calendar,watchList,estimates,rankings,sectors, nil];
    
    _arrayOfItems = [NSMutableArray arrayWithArray:items];
    _arrayOfBottomItems = [NSMutableArray arrayWithObjects:settings,logout, nil];
}

#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1){
        UIView *view = [[UIView alloc] init];
        CGRect frame = CGRectMake(0, 0, 320, 200);
        [view setFrame:frame];
        return view;
    }else{
        UIView *view = [[UIView alloc] init];
        return view;
    }
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == tableView.numberOfSections - 2) {
        CGFloat totalCellHeight = PROFILE_CELL_HEIGHT + (MAIN_CELL_HEIGHT *[_arrayOfItems count]);
        CGFloat tableHeight = tableView.bounds.size.height;
        CGFloat inset = (tableHeight - totalCellHeight) - (MAIN_CELL_HEIGHT*[_arrayOfBottomItems count]);
        return inset;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:{
            return 1;
            break;
        }
            
        case 1:{
            return [_arrayOfItems count];
            break;
        }
        case 2:{
            return [_arrayOfBottomItems count];
            break;
        }
        default:{
            return 0;
        }
        
    }
   // return [_arrayOfItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section > 0){
        return MAIN_CELL_HEIGHT;
    }else{
        return PROFILE_CELL_HEIGHT;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 1){
        
    
        static NSString *cellMainNibID = @"cellMain";
        
        _cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (_cellMain == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"MainCellLeft" owner:self options:nil];
        }
        
        
        UILabel * title = (UILabel *) [_cellMain viewWithTag:2];
        UIImageView * image = (UIImageView *) [_cellMain viewWithTag:1];
        
        LeftPanelItem * item = [_arrayOfItems objectAtIndex:indexPath.row];
        
        [title setText:[item title]];
        [image setImage:[item icon]];

        
        return _cellMain;
    }else if(indexPath.section == 2){
        
        static NSString *cellMainNibID = @"cellMain";
        
        _cellMain = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (_cellMain == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"MainCellLeft" owner:self options:nil];
        }
        
        
        UILabel * title = (UILabel *) [_cellMain viewWithTag:2];
        UIImageView * image = (UIImageView *) [_cellMain viewWithTag:1];
        
        LeftPanelItem * item = [_arrayOfBottomItems objectAtIndex:indexPath.row];
        
        [title setText:[item title]];
        [image setImage:[item icon]];
        
        
        return _cellMain;

    
    }else{
        
        static NSString *cellProfileNibID = @"cellProfile";
        
        _cellProfile = [tableView dequeueReusableCellWithIdentifier:cellProfileNibID];
        if (_cellProfile == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ProfileCellLeft" owner:self options:nil];
        }
        
        
        UILabel * title = (UILabel *) [_cellProfile viewWithTag:2];
         UILabel * description = (UILabel *) [_cellProfile viewWithTag:3];
        UIImageView * profileImage = (UIImageView *) [_cellProfile viewWithTag:1];
        
        //Get User Object and set lables and images
        
        [title setText:@"Kevin Fox"];
        [description setText:@"Tech Analyst at Goldman Sachs"];
        
        //check if images exist or use defualt
        if(1==2){
            
        }else{
            [profileImage setImage:[UIImage imageNamed:DEFAULT_PROFILE_ICON_NAME]];
        }
        
        
        
        return _cellProfile;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    // Return Data to delegate when user selects left panel item
    
    LeftPanelItem * item = [_arrayOfItems objectAtIndex:indexPath.row];
    if(_delegate){
        [_delegate itemSelected:item];
    }else{
        NSLog(@"Error Left panel has no delegate");
    }
    
    
    
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
