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

@property(nonatomic, strong) IBOutletCollection(UITextField) NSArray *dateTextFields;
@property(nonatomic, strong) IBOutlet UIView *datePicker;
@property(nonatomic, weak) id<IFiltersManager> filtersManager;
@property(nonatomic, strong) NSArray *dataSource;

@property(nonatomic, strong) IBOutlet UITableView *dataTable;
@property(nonatomic, weak) NSArray *filteringData;


-(IBAction)datePickerValueChanged:(id)sender;
-(IBAction)datePickerDonePressed;

@end
