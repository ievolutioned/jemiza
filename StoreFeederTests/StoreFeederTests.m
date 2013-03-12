//
//  StoreFeederTests.m
//  StoreFeederTests
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "StoreFeederTests.h"

@implementation StoreFeederTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSearch
{
    NSArray *products = @[ @{@"id": @"ABC1",
                             @"description": @"Bla bla bla bla bla1",
                             @"quantity": @"123"},
                           @{@"id": @"CDE2",
                             @"description": @"Bla bla bla bla bla2",
                             @"quantity": @"456"},
                           @{@"id": @"FGH3",
                             @"description": @"Bla bla bla bla bla3",
                             @"quantity": @"789"}
                           ];
    
    //NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:keyPath] rightExpression:[NSExpression expressionForConstantValue:@"bla"] modifier:NSDirectPredicateModifier type:NSLikePredicateOperatorType options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY FUNCTION(SELF, 'allValues') contains[cd] %@", @"FG"];
    NSArray *result = [products filteredArrayUsingPredicate:predicate];
    NSLog(@"%@",result);
    STAssertTrue([result count] == 1, @"Resulting array different size for search function");
}

@end
