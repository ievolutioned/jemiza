//
//  ProductDetailStandardViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/18/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "ProductDetailStandardViewController.h"

@interface ProductDetailStandardViewController ()

@end

@implementation ProductDetailStandardViewController

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
	// Do any additional setup after loading the view.
    _dataMapping = @[@"description"];
    _quantitiesMapping = @[@"p_1", @"p_2", @"p_3", @"p_4", @"p_u_1", @"p_u_2", @"p_u_3", @"p_u_4", @"stock"];
    _datesMapping = @[@"updated_at"];
    [super loadProductDataIntoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
