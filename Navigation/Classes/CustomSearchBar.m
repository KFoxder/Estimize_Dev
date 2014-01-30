//
//  CustomSearchBar.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/24/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    UITextField *searchField;
    UIButton * cancelButton;
    
    
    NSUInteger numViews = [self.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            
            searchField = [self.subviews objectAtIndex:i];
            
        }
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UIButton class]]){
            cancelButton = [self.subviews objectAtIndex:i];
        }
    }
    if((cancelButton != nil)){
        
        [cancelButton setBackgroundColor:[UIColor whiteColor]];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelButton setTitleEdgeInsets:UIEdgeInsetsZero];
        [cancelButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
     
        
    }
    if((searchField != nil)) {
        
        searchField.textColor = [UIColor blackColor];
        [searchField setBackgroundColor: [UIColor whiteColor]];
        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
        
    }
    [self clearSearchBarBg];
    [super layoutSubviews];
}

//to clear searchbar backgraound
- (void) clearSearchBarBg
{
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            
            [subview removeFromSuperview];
            break;
        }
    }
}


@end
