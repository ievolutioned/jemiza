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
        [((UITextField *)obj) setText:[self.filtersManager getValueForFilter:self.dataSource[idx] forNibName:self.nibName]];
    }];
    
    if(self.dataTable)
    {
        self.filteringData = [self.filtersManager getFilteringDataForNib:self.nibName];
        [self.dataTable reloadData];
        NSNumber *obj;
        if([[(obj = [self.filtersManager getValueForFilter:self.dataSource[0] forNibName:self.nibName]) class] isSubclassOfClass:[NSNumber class]])
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
            NSDate *date = [sender date];
            NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            if(idx == 0)
            {
                [components setHour:00];
                [components setMinute:00];
                [components setSecond:00];
            }
            else
            {
                [components setHour:23];
                [components setMinute:59];
                [components setSecond:59];
            }
            NSDate *finalDate = [calendar dateFromComponents:components];
            [self.filtersManager addFilter:self.dataSource[idx] withValue:finalDate];
            [((UITextField *)obj) setText:[formatter stringFromDate:finalDate]];
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
    [((FilteringDataCell *)cell).infoLabel setText:[NSString stringWithFormat:@"%@", self.filteringData[indexPath.row]]];
    return cell;
}


#pragma mark - Table view data delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.filtersManager addFilter:self.dataSource[0] withValue:[NSNumber numberWithInt:indexPath.row]];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj;
    if([[(obj = [self.filtersManager getValueForFilter:self.dataSource[0] forNibName:self.nibName]) class] isSubclassOfClass:[NSNumber class]])
    {
        if([obj intValue] == indexPath.row)
        {
            [cell setSelected:YES];
        }
    }
}

@end
