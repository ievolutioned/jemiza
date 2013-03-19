//
//  AppDelegate.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "AppDelegate.h"
#import "ProductTableViewController.h"
#import "TestFlight.h"


@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.masterController = [[[MasterController alloc] init] autorelease];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController-iPad" bundle:[NSBundle mainBundle]] autorelease];
    else
        self.loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController-iPhone" bundle:[NSBundle mainBundle]] autorelease];
    
    [self.loginViewController setDataManager:self.masterController];
    [self.loginViewController setFilterManager:self.masterController];
    UISwipeGestureRecognizer *logoutSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self.masterController action:@selector(logout)];
    [logoutSwipe setNumberOfTouchesRequired:1];
    [logoutSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    self.navController = [[[UINavigationController alloc] initWithRootViewController:self.loginViewController] autorelease];
    [self.navController.navigationBar addGestureRecognizer:logoutSwipe];
    
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:.658823529 green:0 blue:.101960784 alpha:1]];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.masterController setNavController:self.navController];
    
    [TestFlight takeOff:@"0f36bcf9-e6fc-4703-b724-59bbd3140139"];
    
    [self.window addSubview:self.navController.view];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Custom methods

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
