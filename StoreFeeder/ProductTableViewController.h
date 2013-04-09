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
#import <CHOrderedDictionary.h>

extern NSString *const kLoadingInfoText;
typedef void(^InfoLoadedBlock)(BOOL);
typedef void(^ResyncInfoBlock)(BOOL, ConnectionResult);
@interface ProductTableViewController : UITableViewController<UISearchBarDelegate>

@property(nonatomic, strong) CHOrderedDictionary *tableStructure;
@property(nonatomic, weak) id<IDataManager> dataManager;
@property(nonatomic, weak) id<IFiltersManager> filterManager;
@property(nonatomic, strong) NSArray *filteredProducts;
@property(nonatomic, copy) InfoLoadedBlock loadHandler;
@property(nonatomic, copy) ResyncInfoBlock resyncHandler;
@property(nonatomic, weak) MBProgressHUD *hud;
- (id)initWithStyle:(UITableViewStyle)style withDataManager:(id<IDataManager>)theDataManager withFilterManager:(id<IFiltersManager>)theFilterManager;

@end
