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
#import <UAModalPanel.h>
#import "FilterViewiPhoneModal.h"

NSString *const kLoadingInfoText = @"Cargando datos...";
NSString *const kSyncInfoText = @"Sincronizando info...";

@interface ProductTableViewController ()

@end

@implementation ProductTableViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        [self setLoadHandler:^(BOOL loaded)
         {
             self.tableView.userInteractionEnabled = YES;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if(loaded)
             {
                 self.filteredProducts = self.dataManager.cachedInfo;
                 [self.tableView reloadData];
                 [self loadSearchBar];
             }
         }];
        
        [self setResyncHandler:^(BOOL resynched, ConnectionResult result)
         {
             [self.hud hide:YES];
             if(result == CR_SUCCESS)
                 [self loadInfo];
             else
                 [self showErrorMessage:result];
         }];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style withDataManager:(id<IDataManager>)theDataManager withFilterManager:(id<IFiltersManager>)theFilterManager
{
    self = [self initWithStyle:style];
    if (self) {
        self.dataManager = theDataManager;
        self.filterManager = theFilterManager;
    }
    return self;
}

-(void)showErrorMessage:(ConnectionResult)err
{
    NSString *message;
    if(err == CR_TIMEOUT)
        message = @"Error al bajar el archivo, intentelo mas tarde.";
    else if(err == CR_NOTFOUND)
        message = @"Error en servidor, favor de reportarlo al equipo de desarrollo.";
    else
        message = @"Error al bajar el archivo.";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFilterView)];
    [tapRecognizer setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:tapRecognizer];

    self.title = @"Productos de abarrote";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if([[self.dataManager getProfileOfLoggedInUser] isEqualToString:@"normal"])
    {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncData)]];
    
    [self loadHud:kLoadingInfoText];
    if(self.dataManager.cachedInfo == nil)
        [self loadInfo];
    else
        self.loadHandler(YES);
}

-(void)loadInfo
{
    [self loadHud:kLoadingInfoText];
    [self.dataManager loadProductListWithHandler:self.loadHandler];
}

-(void)syncData
{
    [self loadHud:kSyncInfoText];
    [self.dataManager resyncInfoWithHandler:self.resyncHandler];
}

-(void)loadHud:(NSString *)text
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = text;
    self.tableView.userInteractionEnabled = NO;
}

-(void)loadSearchBar
{
    if(!self.searchDisplayController)
    {
        int width, height;
        width = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 768 : 320;
        height = 44;
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [searchBar setTintColor:[UIColor blackColor]];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:.874509804 green:.874509804 blue:.866666667 alpha:1]];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 50.0;
    else
        return 78;
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
    NSDictionary *product = self.filteredProducts[indexPath.row];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController-iPad" bundle:[NSBundle mainBundle] WithData:product];
    else
        detailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController-iPhone" bundle:[NSBundle mainBundle] WithData:product];
    
    UIScrollView *mainScrollView = [[[UIScrollView alloc] initWithFrame:self.view.frame] autorelease];
    [mainScrollView addSubview:detailViewController.view];
    [mainScrollView setContentSize:detailViewController.view.frame.size];
    [mainScrollView setBackgroundColor:[UIColor colorWithRed:.941176471 green:.937254902 blue:.929411765 alpha:0]];
    [detailViewController release];
    
    UIViewController *mainController = [UIViewController new];
    [mainController setView:mainScrollView];
    mainController.title = [NSString stringWithFormat:@"Identificador - %@", product[@"product_code"]];

    [self.navigationController pushViewController:mainController animated:YES];
}

#pragma mark - SearchBar delegate

-(NSArray *)applyGlobalFilters
{
    return [self.filterManager getFilteredInfo];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] != 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"description", searchText];
        self.filteredProducts = [[self applyGlobalFilters] filteredArrayUsingPredicate:predicate];
    }
    else
    {
        self.filteredProducts = [self applyGlobalFilters];
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

#pragma mark - Tap Gesture Recognizer implementation

-(void)openFilterView
{
    FilterViewiPhoneModal *modalPanel = [[[FilterViewiPhoneModal alloc] initWithFrame:self.navigationController.view.bounds] autorelease];
    [modalPanel setFiltersManager:self.filterManager];
    [modalPanel loadView];
    [self.navigationController.view addSubview:modalPanel];
    
    modalPanel.onClosePressed = ^(UAModalPanel *panel)
    {
        [self.filterManager applyFilters];
        [panel hideWithOnComplete:^(BOOL finished) {
            [self searchBar:nil textDidChange:((UISearchBar *)self.tableView.tableHeaderView).text];
        }];
    };
    
    [modalPanel show];
}

@end
