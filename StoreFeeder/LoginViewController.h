//
//  LoginViewController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDataManager.h"
#import "IFiltersManager.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, retain) IBOutletCollection(UITextField) NSArray *loginTextFields;
@property(nonatomic, retain) UIViewController *mainViewController;
@property(nonatomic, assign) id<IDataManager> dataManager;
@property(nonatomic, assign) id<IFiltersManager> filterManager;
-(IBAction)login:(id)sender;

@end
