//
//  MasterController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController
@synthesize cachedInfo, filtersDataSource, chosenOption;

-(void)dealloc
{
    [super dealloc];
    self.filtersDataSource = nil;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.restDataManager = [[[RESTDataManager alloc] init] autorelease];
        self.fileManager = [[[FileManager alloc] init] autorelease];
        self.filtersDataSource = @{@"DateFilter": @[@"from_date", @"to_date"]
                                   , @"CategoryFilter": @[@"category"]
                                   , @"SubfamilyFilter": @[@"subfamily"]
                                   , @"WarehouseFilter": @[@"warehouse"]};
        self.filters = [[[NSMutableDictionary alloc] init] autorelease];
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
        self.filtered = self.cachedInfo;
        handler(self.cachedInfo != nil);
    }];
}

-(void)resyncInfoWithHandler:(void (^)(BOOL, ConnectionResult))handler
{
    if(!self.accessToken)
    {
       self.accessToken = [self.fileManager getAccessTokenOfLoggedInUser];
    }
    [self.restDataManager getInfoFromServiceWithAccessToken:self.accessToken ToHandler:^(NSData *data, ConnectionResult connResult) {
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
           if (![self.fileManager saveLoginInfo:data])
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

-(void)goBack
{
    if(self.navController.viewControllers.count > 1)
    {
        if(self.navController.viewControllers.count == 2)
            [self.fileManager logout];
       [self.navController popViewControllerAnimated:YES];
    }
}


-(NSString *)getProfileOfLoggedInUser
{
    return [self.fileManager getProfileOfLoggedInUser];
}

#pragma mark - Filter manager

-(NSArray *)getFilteredInfo
{
    return self.filtered;
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

-(NSArray *)getFilteringDataForNib:(NSString *)nibName
{
    NSString *realName = [nibName componentsSeparatedByString:@"-"][0];
    if([realName isEqualToString:@"CategoryFilter"])
    {
        return self.categories;
    }
    else if([realName isEqualToString:@"SubfamilyFilter"])
    {
        return self.subfamilies;
    }
    else
    {
        return self.warehouses;
    }
}

-(id)getValueForFilter:(NSString *)filterName forNibName:(NSString *)nibName
{
    id obj;
    if((obj = [self.filters valueForKeyPath:filterName]))
    {
        if([[obj class] isSubclassOfClass:[NSDate class]])
        {
            NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"dd/MM/yyyy"];
            return [formatter stringFromDate:obj];
        }
        return obj;
    }
    return @"";
}

-(NSArray *)getComponentListForLoggedUser
{
    NSString *profile = [self getProfileOfLoggedInUser];
    NSMutableArray *componentList = [[NSMutableArray new] autorelease];
    [componentList addObject:@{@"nibName": @"DateFilter", @"title": @"Por fecha:"}];
    if(![profile isEqualToString:@"normal"])
    {
        [componentList addObject:@{@"nibName": @"CategoryFilter", @"title": @"Por categoria:"}];
        [componentList addObject:@{@"nibName": @"SubfamilyFilter", @"title": @"Por subfamilia:"}];
        [componentList addObject:@{@"nibName": @"WarehouseFilter", @"title": @"Por almacen:"}];
    }
    return componentList;
}

-(void)loadFilteringDataWithHandler:(void (^)(BOOL))handler
{
    [self.fileManager loadFilterInfo:@"category" toHandler:^(NSArray *filteredCategories) {
        self.categories = filteredCategories;
        
       [self.fileManager loadFilterInfo:@"subfamily" toHandler:^(NSArray *filteredSubfamilies) {
           self.subfamilies = filteredSubfamilies;
           
          [self.fileManager loadFilterInfo:@"warehouse" toHandler:^(NSArray *filteredWarehouses) {
              self.warehouses = filteredWarehouses;
              
              handler(YES);
          }];
       }];
    }];
}

-(BOOL)checkIfFilteringDataIsLoaded
{
    return (self.categories != nil && self.subfamilies != nil && self.warehouses != nil);
}

-(void)applyFilters
{
    __block BOOL firstTime = YES;
    [self.filters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSPredicate *predicate = nil;
        NSString *valueFromList = nil;
        if([key isEqualToString:@"category"])
        {
            valueFromList = self.categories[[obj intValue]];
            predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"description_category", valueFromList];
        }
        if([key isEqualToString:@"warehouse"])
        {
            valueFromList = self.warehouses[[obj intValue]];
            predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"warehouse", valueFromList];
        }
        if([key isEqualToString:@"subfamily"])
        {
            valueFromList = self.subfamilies[[obj intValue]];
            predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"description_sub_family", valueFromList];
        }
        if([key isEqualToString:@"from_date"])
        {
            predicate = [NSPredicate predicateWithFormat:@"%K >= %@", @"updated_at", obj];
        }
        if([key isEqualToString:@"to_date"])
        {
            predicate = [NSPredicate predicateWithFormat:@"%K <= %@", @"updated_at", obj];
        }
        NSArray *filteredCopy;
        if(firstTime)
            filteredCopy = [[self.cachedInfo copy] autorelease];
        else
            filteredCopy = [[self.filtered copy] autorelease];
        firstTime = NO;
        self.filtered = [filteredCopy filteredArrayUsingPredicate:predicate];
        NSLog(@"Obtenidos %d objectos filtrados de %d originalmente con filtro %@", [self.filtered count], [filteredCopy count], obj);
    }];
}

@end
