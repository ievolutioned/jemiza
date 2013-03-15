//
//  MasterController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController
@synthesize cachedInfo, filtersDataSource;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.restDataManager = [[RESTDataManager alloc] init];
        self.fileManager = [[FileManager alloc] init];
        self.filtersDataSource = @{@"DateFilter": @[@"from_date", @"to_date"]};
        self.filters = [NSMutableDictionary new];
    }
    return self;
}

-(void)loadProductListWithHandler:(void (^)(BOOL))handler
{
    
    if(![self.fileManager checkIfJsonFileExists])
    {
        [self resyncInfoWithHandler:^(BOOL result, ConnectionResult conResult) {
            if(result)
            {
                handler(result);
            }
        }];
    }
    else
    {
        [self loadingDataWithHandler:handler];
    }
}

-(void)loadingDataWithHandler:(void (^)(BOOL))handler
{
    [self.fileManager loadInfoFromJsonFileWithHandler:^(NSArray *result) {
        self.cachedInfo = result;
        handler(self.cachedInfo != nil);
    }];
}

-(void)resyncInfoWithHandler:(void (^)(BOOL, ConnectionResult))handler
{
    [self.restDataManager getInfoFromServiceToHandler:^(NSData *data, ConnectionResult connResult) {
        if(connResult == CR_SUCCESS)
            [self.fileManager loadInfoToJsonFile:data];
        handler(connResult == CR_SUCCESS, connResult);
    }];
}

-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(BOOL))handler
{
    [self.restDataManager loginWithUsername:username withPassword:password withHandler:^(NSDictionary *data) {
       if(![data[@"result"] isEqual: @NO])
       {
           NSMutableDictionary *info = [NSMutableDictionary new];
           [info setValue:username forKey:@"username"];
           [info setValue:password forKey:@"password"];
           [info setValue:data[@"profile"] forKey:@"profile"];
           
           if (![self.fileManager saveLoginInfo:info])
           {
               NSLog(@"Could not save file");
               handler(NO);
           }
           else
           {
               handler(YES);
           }
       }
       else
       {
           handler(NO);
       }
    }];
}

-(BOOL)checkLogin
{
    return [self.fileManager checkIfLoginInfoExists];
}

-(void)logout
{
    [self.fileManager logout];
    [self.navController popToRootViewControllerAnimated:YES];
}


-(NSString *)getProfileOfLoggedInUser
{
    return [self.fileManager getProfileOfLoggedInUser];
}

#pragma mark - Filter manager

-(NSArray *)getFilteredInfo
{
    return self.cachedInfo;
}

-(void)addFilter:(NSString *)filterName withValue:(id)filterValue
{
    [self.filters setValue:filterValue forKeyPath:filterName];
}

-(NSArray *)getDataSourceForNib:(NSString *)nibName
{
    NSString *realName = [nibName componentsSeparatedByString:@"-"][0];
    return [self.filtersDataSource valueForKeyPath:realName];
}

-(NSString *)getStringValueForFilter:(NSString *)filterName
{
    id obj;
    if((obj = [self.filters valueForKeyPath:filterName]))
    {
        if([[obj class] isSubclassOfClass:[NSDate class]])
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            return [formatter stringFromDate:obj];
        }
        else
        {
            return obj;
        }
    }
    return @"";
}

-(NSArray *)getComponentListForLoggedUser
{
    NSString *profile = [self getProfileOfLoggedInUser];
    NSMutableArray *componentList = [NSMutableArray new];
    [componentList addObject:@{@"nibName": @"DateFilter", @"title": @"Por fecha:"}];
    if(![profile isEqualToString:@"normal"])
    {
        [componentList addObject:@{@"nibName": @"CategoryFilter", @"title": @"Por categoria:"}];
        [componentList addObject:@{@"nibName": @"SubfamilyFilter", @"title": @"Por subfamilia:"}];
        [componentList addObject:@{@"nibName": @"WarehouseFilter", @"title": @"Por almacen:"}];
    }
    return componentList;
}

@end
