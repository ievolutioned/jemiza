//
//  ProductTableViewController-iPad.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDataManager.h"
#import "IFiltersManager.h"
#import "MBProgressHUD.h"

extern NSString *const kLoadingInfoText;
typedef void(^InfoLoadedBlock)(BOOL);
typedef void(^ResyncInfoBlock)(BOOL, ConnectionResult);
@interface ProductTableViewController : UITableViewController<UISearchBarDelegate>

@property(nonatomic, assign) id<IDataManager> dataManager;
@property(nonatomic, assign) id<IFiltersManager> filterManager;
@property(nonatomic, retain) NSArray *filteredProducts;
@property(nonatomic, copy) InfoLoadedBlock loadHandler;
@property(nonatomic, copy) ResyncInfoBlock resyncHandler;
@property(nonatomic, assign) MBProgressHUD *hud;
- (id)initWithStyle:(UITableViewStyle)style withDataManager:(id<IDataManager>)theDataManager withFilterManager:(id<IFiltersManager>)theFilterManager;

@end
