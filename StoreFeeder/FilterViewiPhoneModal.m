//
//  FilterViewiPhoneModal.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "FilterViewiPhoneModal.h"
#import "MasterFilterComponentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD.h>

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

-(void)loadAccordionView
{
    self.headers = [[[NSMutableArray alloc] init] autorelease];
    self.margin = UIEdgeInsetsMake(40, 20, 20, 20);
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 230, 380)];
    [self.contentView addSubview:scroll];
    
    AccordionView *accordion = [[[AccordionView alloc] initWithFrame:CGRectMake(0, 0, 230, 370)] autorelease];
    [scroll addSubview:accordion];
    
    NSArray *filterComponents = [self.filtersManager getComponentListForLoggedUser];
    NSString *deviceSugar = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"-iPad" : @"-iPhone";
    
    [filterComponents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Only height is taken into account, so other parameters are just dummy
        UIButton *header = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)] autorelease];
        [header setBackgroundColor:[UIColor grayColor]];
        header.layer.cornerRadius = 8;
        header.layer.masksToBounds = YES;
        [header setTitle:obj[@"title"] forState:UIControlStateNormal];
        [self.headers addObject:header];
        
        MasterFilterComponentViewController *content = [[MasterFilterComponentViewController alloc] initWithNibName:[NSString stringWithFormat:@"%@%@", obj[@"nibName"], deviceSugar] bundle:[NSBundle mainBundle]];
        content.view.layer.cornerRadius = 6;
        content.view.layer.masksToBounds = YES;
        [content setFiltersManager:self.filtersManager];
        
        [accordion addHeader:header withView:content.view];
    }];
    int activeFilter;
    if((activeFilter = [self.filtersManager getActiveFilter]) != 0)
    {
        [accordion setSelectedIndex:activeFilter];
    }
    // ... add more panels
    
    [accordion setNeedsLayout];
    
    // Set this if you want to allow multiple selection
    [accordion setAllowsMultipleSelection:NO];
    
    [self loadButtons];
    
    self.closeButton.hidden = YES;
}

-(void)loadButtons
{
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, 330, 100, 60)];
    save.layer.cornerRadius = 5;
    save.layer.masksToBounds = YES;
    [save setContentMode:UIViewContentModeScaleAspectFit];
    [save setTitle:@"Filtrar" forState:UIControlStateNormal];
    [save setBackgroundColor:[UIColor colorWithRed:0 green:.188235294 blue:.635294118 alpha:1]];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(130, 330, 100, 60)];
    delete.layer.cornerRadius = 5;
    delete.layer.masksToBounds = YES;
    [delete.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [delete setContentMode:UIViewContentModeScaleToFill];
    [delete setTitle:@"Eliminar filtros" forState:UIControlStateNormal];
    [delete setBackgroundColor:[UIColor colorWithRed:.658823529 green:0 blue:.101960784 alpha:1]];
    
    [self.contentView addSubview:save];
    [self.contentView addSubview:delete];
}

-(void)loadView
{
    [super loadView];
    
    if(![self.filtersManager checkIfFilteringDataIsLoaded])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.labelText = @"Cargando información de filtrado...";
        [self.filtersManager loadFilteringDataWithHandler:^(BOOL loaded) {
            [hud hide:YES];
            [self loadAccordionView];
        }];
    }
    else
    {
        [self loadAccordionView];
    }
}

@end
