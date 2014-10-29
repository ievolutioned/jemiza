//
//  MasterFilterComponentViewController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/15/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFiltersManager.h"

@interface MasterFilterComponentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) IBOutletCollection(UITextField) NSArray *dateTextFields;
@property(nonatomic, retain) IBOutlet UIView *datePicker;
@property(nonatomic, assign) id<IFiltersManager> filtersManager;
@property(nonatomic, retain) NSArray *dataSource;

@property(nonatomic, retain) IBOutlet UITableView *dataTable;
@property(nonatomic, assign) NSArray *filteringData;


-(IBAction)datePickerValueChanged:(id)sender;
-(IBAction)datePickerDonePressed;

@end
