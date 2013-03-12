//
//  ProductTableViewController-iPad.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDataManager.h"

@interface ProductTableViewController : UITableViewController<UISearchBarDelegate>

@property(nonatomic, assign) id<IDataManager> dataManager;
@property(nonatomic, retain) NSArray *products;

@end
