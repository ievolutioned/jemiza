//
//  InfoSelectionViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "InfoSelectionViewController.h"
#import "ProductTableViewController.h"

@interface InfoSelectionViewController ()

@end

@implementation InfoSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
    self.title = @"Selección de producto";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)enterSaleView
{
    self.tableViewController = [[ProductTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [((ProductTableViewController *)self.tableViewController) setDataManager:self.dataManager];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

-(IBAction)enterAdminView
{
    
}

@end
