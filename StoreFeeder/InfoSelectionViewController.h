//
//  InfoSelectionViewController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDataManager.h"
#import "IFiltersManager.h"

@interface InfoSelectionViewController : UIViewController

@property(nonatomic, retain) UITableViewController *tableViewController;
@property(nonatomic, assign) id<IDataManager> dataManager;
@property(nonatomic, assign) id<IFiltersManager> filterManager;

@end
