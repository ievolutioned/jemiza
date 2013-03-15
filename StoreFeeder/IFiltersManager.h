//
//  IFiltersManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFiltersManager <NSObject>

-(NSArray *)getFilteredInfo;
-(void)addFilter:(NSString *)filterName withValue:(id)filterValue;
-(NSArray *)getDataSourceForNib:(NSString *)nibName;
-(id)getValueForFilter:(NSString *)filterName forNibName:(NSString *)nibName;
-(NSArray *)getComponentListForLoggedUser;
-(NSArray *)getFilteringDataForNib:(NSString *)nibName;
-(void)loadFilteringDataWithHandler:(void(^)(BOOL))handler;
-(BOOL)checkIfFilteringDataIsLoaded;

@property(nonatomic, retain)NSDictionary *filtersDataSource;

@end
