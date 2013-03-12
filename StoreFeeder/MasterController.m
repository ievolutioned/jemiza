//
//  MasterController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController

-(void)getProductListToHandler:(void (^)(NSArray *))handler
{
    NSArray *products = @[ @{@"id": @"ABC1",
                             @"description": @"Bla bla bla bla bla",
                             @"quantity": @"123"},
                           @{@"id": @"CDE2",
                             @"description": @"Bla bla bla bla bla",
                             @"quantity": @"456"},
                           @{@"id": @"FGH3",
                             @"description": @"Bla bla bla bla bla",
                             @"quantity": @"789"}
                          ];
    
    handler(products);
}

@end
