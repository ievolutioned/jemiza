//
//  ProductDetailAdminViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/18/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "ProductDetailAdminViewController.h"

@interface ProductDetailAdminViewController ()

@end

@implementation ProductDetailAdminViewController

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
    _dataMapping = @[@"description", @"barcode", @"warehouse", @"last_purchase", @"last_sale", @"description_category", @"description_sub_family"];
    _quantitiesMapping = @[@"stock", @"last_cost", @"regular_stock", @"last_cost_net", @"sales_factor", @"purchase_iva", @"sales_iva"];
    [super loadProductDataIntoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
