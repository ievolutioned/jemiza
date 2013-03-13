//
//  LoginViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "LoginViewController.h"
#import <MBProgressHUD.h>
#import "ProductTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"Inicio de sesión";
    
    if([self.dataManager checkLogin])
       [self completeLogin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Ingresando...";
    
    NSString *username = ((UILabel *)self.loginTextFields[0]).text;
    NSString *password = ((UILabel *)self.loginTextFields[1]).text;
    
    [self.dataManager loginWithUsername:username withPassword:password withHandler:^(BOOL result) {
        [hud hide:YES];
        if(result)
        {
            [self completeLogin];
            [self.loginTextFields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [((UITextField *)obj) resignFirstResponder];
                [((UITextField *)obj) setText:@""];
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo iniciar sesión." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}

-(void)completeLogin
{
    self.tableViewController = [[ProductTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [((ProductTableViewController *)self.tableViewController) setDataManager:self.dataManager];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

#pragma mark - TextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.loginTextFields[0])
    {
        [((UITextField *)self.loginTextFields[1]) becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self login:nil];
    }
    return NO;
}

@end