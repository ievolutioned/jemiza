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

@interface MasterController : NSObject<IDataManager, IFiltersManager>

@property(nonatomic, retain)RESTDataManager *restDataManager;
@property(nonatomic, retain)FileManager *fileManager;
@property(nonatomic, assign)UINavigationController *navController;

@end
