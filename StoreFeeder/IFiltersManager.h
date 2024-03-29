//
//  IFiltersManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IFiltersManager <NSObject>

-(int)getActiveFilter;
-(NSArray *)getFilteredInfo;
-(void)addFilter:(NSString *)filterName withValue:(id)filterValue;
-(NSArray *)getDataSourceForNib:(NSString *)nibName;
-(id)getValueForFilter:(NSString *)filterName forNibName:(NSString *)nibName;
-(NSArray *)getComponentListForLoggedUser;
-(NSArray *)getFilteringDataForNib:(NSString *)nibName;
-(void)loadFilteringDataWithHandler:(void(^)(BOOL))handler;
-(BOOL)checkIfFilteringDataIsLoaded;
-(void)applyFilters;
-(void)markToDeleteFilters;
-(void)createFilterBackup;
-(void)cancelFilteringOperation;

@property(nonatomic, retain)NSDictionary *filtersDataSource;

@end
