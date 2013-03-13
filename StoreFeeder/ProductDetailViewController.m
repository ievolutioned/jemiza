//
//  ProductDetailViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProductDetailViewController ()
{
    NSArray *_dataMapping;
}

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithData:(NSDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productData = data;
        _dataMapping = @[@"product_code", @"description", @"p_1", @"p_2", @"p_3", @"p_4", @"stock"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Información de producto";
    _dataMapping = @[@"product_code", @"description", @"p_1", @"p_2", @"p_3", @"p_4", @"stock"];
    [self.productDetailLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UILabel *)obj) setText:[NSString stringWithFormat:@"%@", self.productData[_dataMapping[idx]]]];
    }];
    
    [self.viewAreas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).layer.cornerRadius = 5.0;
        ((UIView *)obj).layer.masksToBounds = YES;
        ((UIView *)obj).layer.borderColor = [[UIColor grayColor] CGColor];
        ((UIView *)obj).layer.borderWidth = 2;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
