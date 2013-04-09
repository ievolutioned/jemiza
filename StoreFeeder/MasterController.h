//
//  MasterController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDataManager.h"
#import "RESTDataManager.h"
#import "FileManager.h"
#import "IFiltersManager.h"

@interface MasterController : NSObject<IDataManager, IFiltersManager, UIAlertViewDelegate>

@property(nonatomic, strong)RESTDataManager *restDataManager;
@property(nonatomic, strong)FileManager *fileManager;
@property(nonatomic, weak)UINavigationController *navController;
@property(nonatomic, strong)NSMutableDictionary *filters;
@property(nonatomic, strong)NSMutableDictionary *filtersBackup;
@property(nonatomic, strong)NSArray *categories;
@property(nonatomic, strong)NSArray *subfamilies;
@property(nonatomic, strong)NSArray *warehouses;
@property(nonatomic, strong)NSString *accessToken;
@property(nonatomic, strong)NSArray *filtered;
@property(nonatomic, assign)BOOL ignoreFilters;

@end
