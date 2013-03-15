//
//  FilterViewiPhoneModal.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "FilterViewiPhoneModal.h"
#import "MasterFilterComponentViewController.h"

@implementation FilterViewiPhoneModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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

-(void)loadView
{
    [super loadView];
    self.margin = UIEdgeInsetsMake(40, 20, 20, 20);
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 230, 300)];
    [self.contentView addSubview:scroll];
    
    AccordionView *accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 0, 230, 420)];
    [scroll addSubview:accordion];
    
    NSArray *filterComponents = [self.filtersManager getComponentListForLoggedUser];
    NSString *deviceSugar = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"-iPad" : @"-iPhone";
    
    [filterComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Only height is taken into account, so other parameters are just dummy
        UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        [header setTitle:obj[@"title"] forState:UIControlStateNormal];
        
        MasterFilterComponentViewController *content = [[MasterFilterComponentViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@", obj[@"nibName"], deviceSugar] bundle:[NSBundle mainBundle]];
        [content setFiltersManager:self.filtersManager];
        
        [accordion addHeader:header withView:content.view];
    }];
    
    
    // ... add more panels
    
    [accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [accordion setAllowsMultipleSelection:NO];
    [self.actionButton setTitle:@"Guardar" forState:UIControlStateNormal];
}

@end
