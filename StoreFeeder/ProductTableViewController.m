//
//  ProductTableViewController-iPad.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "ProductTableViewController.h"
#import  "ProductCell.h"
#import "ProductDetailViewController.h"

@interface ProductTableViewController ()

@end

@implementation ProductTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Productos de abarrote";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    __block UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:self.view.center];
    [self.view addSubview:activity];
    [activity startAnimating];
    
    [self.dataManager loadProductListWithHandler:^(BOOL loaded) {
         [activity stopAnimating];
         [activity removeFromSuperview];
         if(loaded)
         {
             self.filteredProducts = self.dataManager.cachedInfo;
             [self.tableView reloadData];
             [self loadSearchBar];
         }
    }];
}

-(void)loadSearchBar
{
    if(!self.searchDisplayController)
    {
        int width, height;
        width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768 : 320;
        height = 44;
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [searchBar setDelegate:self];
        [self.tableView setTableHeaderView:searchBar];
        
        self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.filteredProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCellIPad";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            cell = [[NSBundle mainBundle] loadNibNamed:@"ProductCell-iPad" owner:self options:nil][0];
        else
            cell = [[NSBundle mainBundle] loadNibNamed:@"ProductCell-iPhone" owner:self options:nil][0];
    }
    
    [cell loadData:self.filteredProducts[indexPath.row]];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 50.0;
    else
        return 100.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *detailViewController;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController-iPad" bundle:[NSBundle mainBundle] WithData:self.filteredProducts[indexPath.row]];
    else
        detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController-iPhone" bundle:[NSBundle mainBundle] WithData:self.filteredProducts[indexPath.row]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - SearchBar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] != 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(FUNCTION(SELF, 'allValues'), $k, SELF[$k].stringValue contains[cd] %@).@count > 0", searchText];
        
        self.filteredProducts = [[self.dataManager cachedInfo] filteredArrayUsingPredicate:predicate];
    }
    else
    {
        self.filteredProducts = [self.dataManager cachedInfo];
    }
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
