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

@end

@implementation ProductDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithData:(NSDictionary *)data
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSString *)stripDoubleSpaceFrom:(id)str {
    if(![[str class] isSubclassOfClass:[NSString class]])
        str = [str stringValue];
    while ([str rangeOfString:@"  "].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadProductDataIntoView
{
    [self.productDetailLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(self.productData[_dataMapping[idx]] != [NSNull null])
        {
            NSString *detail = [self stripDoubleSpaceFrom:self.productData[_dataMapping[idx]]];
            [((UILabel *)obj) setText:detail];
        }
        else
        {
            [((UILabel *)obj) setText:@""];
        }
    }];
    
    [self.productQuantitiesLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(self.productData[_quantitiesMapping[idx]] != [NSNull null])
        {
            float value = [self.productData[_quantitiesMapping[idx]] floatValue];
            [((UILabel *)obj) setText:[NSString stringWithFormat:@"%.2f", value]];
        }
        else
        {
            [((UILabel *)obj) setText:@""];
        }
    }];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [self.productDatesLabels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *dateString = [formatter stringFromDate:self.productData[_datesMapping[idx]]];
        [((UILabel *)obj) setText:dateString];
    }];
    
    [self.viewAreas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ((UIView *)obj).layer.cornerRadius = 5.0;
        ((UIView *)obj).layer.masksToBounds = YES;
        ((UIView *)obj).layer.borderColor = [[UIColor grayColor] CGColor];
        ((UIView *)obj).layer.borderWidth = 2;
    }];
}

@end
