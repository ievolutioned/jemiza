//
//  ProductDetailViewController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProductDetailViewController : UIViewController
{
    NSArray *_dataMapping;
    NSArray *_quantitiesMapping;
    NSArray *_datesMapping;
}

@property(nonatomic, retain) IBOutletCollection(UILabel) NSArray *productDetailLabels;
@property(nonatomic, retain) IBOutletCollection(UIView) NSArray *viewAreas;
@property(nonatomic, retain) IBOutletCollection(UILabel) NSArray *productQuantitiesLabels;
@property(nonatomic, retain) IBOutletCollection(UILabel) NSArray *productDatesLabels;
@property(nonatomic, assign) NSDictionary *productData;

- (NSString *)stripDoubleSpaceFrom:(NSString *)str;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithData:(NSDictionary *)data;
-(void)loadProductDataIntoView;

@end
