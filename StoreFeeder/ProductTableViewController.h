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
#import <JGProgressHUD.h>
#import <CHOrderedDictionary.h>
#import "MNMBottomPullToRefreshManager.h"

extern NSString *const kLoadingInfoText;
typedef void(^InfoLoadedBlock)(BOOL);
typedef void(^ResyncInfoBlock)(BOOL, ConnectionResult);
@interface ProductTableViewController : UITableViewController<UISearchBarDelegate,MNMBottomPullToRefreshManagerClient,UIScrollViewDelegate>
{
    /**
     * Pull to refresh manager
     */
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    /**
     * Reloads (for testing purposes)
     */
    NSUInteger reloads_;
    int Page;

}
@property(nonatomic, retain) CHOrderedDictionary *tableStructure;
@property(nonatomic, assign) id<IDataManager> dataManager;
@property(nonatomic, assign) id<IFiltersManager> filterManager;
@property(nonatomic, retain) NSArray *filteredProducts;
@property(nonatomic, copy) InfoLoadedBlock loadHandler;
@property(nonatomic, copy) ResyncInfoBlock resyncHandler;
@property(nonatomic, copy) ResyncInfoBlock PagecHandler;
@property (nonatomic, strong) JGProgressHUD * HUDJMProgress;
- (id)initWithStyle:(UITableViewStyle)style withDataManager:(id<IDataManager>)theDataManager withFilterManager:(id<IFiltersManager>)theFilterManager;

@end
