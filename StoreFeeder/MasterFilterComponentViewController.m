//
//  MasterFilterComponentViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/15/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterFilterComponentViewController.h"
#import "FilteringDataCell.h"

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
        [((UITextField *)obj) setText:[self.filtersManager getValueForFilter:self.dataSource[idx]]];
    }];
    
    if(self.dataTable)
    {
        self.filteringData = [self.filtersManager getFilteringDataForNib:self.nibName];
        [self.dataTable reloadData];
        id obj;
        if((obj = [self.filtersManager getValueForFilter:self.dataSource[0]]) != nil)
        {
            [self.dataTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[obj intValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }

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

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteringData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(!cell)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[NSBundle mainBundle] loadNibNamed:@"FilteringDataCell-iPad" owner:self options:nil][0];
        else
            cell = [[NSBundle mainBundle] loadNibNamed:@"FilteringDataCell-iPhone" owner:self options:nil][0];
    }
    [((FilteringDataCell *)cell).infoLabel setText:self.filteringData[indexPath.row]];
    return cell;
}


#pragma mark - Table view data delegate

@end
