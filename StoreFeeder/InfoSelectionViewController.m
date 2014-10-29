//
//  InfoSelectionViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "InfoSelectionViewController.h"
#import "ProductTableViewController.h"
#import <JGProgressHUD.h>

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

-(void)loadTableview
{
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = kLoadingInfoText;
    [hud showInView:self.view];
    void(^loadHandler)(BOOL) = ^(BOOL result) {
        [hud dismiss];
        self.tableViewController = [[[ProductTableViewController alloc] initWithStyle:UITableViewStylePlain withDataManager:self.dataManager withFilterManager:self.filterManager] autorelease];
        [self.navigationController pushViewController:self.tableViewController animated:YES];
    };
    
    if(self.dataManager.cachedInfo == nil)
        [self.dataManager loadProductListWithHandler:loadHandler];
    else
        loadHandler(YES);
}

-(IBAction)enterSaleView
{
    [self.dataManager setChosenOption:Normal];
    [self loadTableview];
}

-(IBAction)enterAdminView
{
    [self.dataManager setChosenOption:Admin];
    [self loadTableview];
}

@end
