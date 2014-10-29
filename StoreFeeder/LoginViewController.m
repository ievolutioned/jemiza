//
//  LoginViewController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/13/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "LoginViewController.h"
#import <JGProgressHUD.h>
#import "ProductTableViewController.h"
#import "InfoSelectionViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@interface LoginViewController ()
{
    CGFloat animatedDistance;
}

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
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    self.title = @"Inicio de sesión";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    if([self.dataManager checkLogin])
       [self completeLogin];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender
{
    NSString *username = ((UILabel *)self.loginTextFields[0]).text;
    NSString *password = ((UILabel *)self.loginTextFields[1]).text;
    if((!username && !password) || ([username isEqual:@""]))
        return;
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    hud.textLabel.text = @"Ingresando...";
    [hud showInView:self.view];

    [self.dataManager loginWithUsername:username withPassword:password withHandler:^(BOOL result) {
        [hud dismiss];
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
    if([[self.dataManager getProfileOfLoggedInUser] isEqualToString:@"normal"])
    {
        self.mainViewController = [[[ProductTableViewController alloc] initWithStyle:UITableViewStylePlain withDataManager:self.dataManager withFilterManager:self.filterManager] autorelease];
        [self.dataManager setChosenOption:Normal];
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.mainViewController = [[[InfoSelectionViewController alloc] initWithNibName:@"InfoSelectionViewController-iPad" bundle:[NSBundle mainBundle]] autorelease];
        }
        else
        {
            self.mainViewController = [[[InfoSelectionViewController alloc] initWithNibName:@"InfoSelectionViewController-iPhone" bundle:[NSBundle mainBundle]] autorelease];
        }
        [((InfoSelectionViewController *)self.mainViewController) setDataManager:self.dataManager];
        [((InfoSelectionViewController *)self.mainViewController) setFilterManager:self.filterManager];
    }
    [self.navigationController pushViewController:self.mainViewController animated:YES];
}

#pragma mark - TextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.loginTextFields[0])
    {
        [((UITextField *)self.loginTextFields[1]) becomeFirstResponder];
    }
    else
    {
        [self login:nil];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midLine = textFieldRect.origin.y + (0.5 * textFieldRect.size.height);
    CGFloat numerator = midLine - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
@end
