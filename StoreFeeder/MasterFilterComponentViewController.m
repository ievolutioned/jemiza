//
//  MasterFilterComponentViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/15/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterFilterComponentViewController.h"

@interface MasterFilterComponentViewController ()

@end

@implementation MasterFilterComponentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataSource = [self.filtersManager getDataSourceForNib:self.nibName];
    [self.dateTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UITextField *)obj) setInputView:self.datePicker];
        [((UITextField *)obj) setText:[self.filtersManager getStringValueForFilter:self.dataSource[idx]]];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)datePickerValueChanged:(id)sender
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [self.dateTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([((UITextField *)obj) isFirstResponder])
        {
            [self.filtersManager addFilter:self.dataSource[idx] withValue:[sender date]];
            [((UITextField *)obj) setText:[formatter stringFromDate:[sender date]]];
            *stop = YES;
        }
    }];
}

-(IBAction)datePickerDonePressed
{
    [self.dateTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([((UITextField *)obj) isFirstResponder])
        {
            [((UITextField *)obj) resignFirstResponder];
            *stop = YES;
        }
    }];
}

@end
