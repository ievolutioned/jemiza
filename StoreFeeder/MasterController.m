//
//  MasterController.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "MasterController.h"

@implementation MasterController
@synthesize cachedInfo;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.restDataManager = [[RESTDataManager alloc] init];
        self.fileManager = [[FileManager alloc] init];
    }
    return self;
}

-(void)loadProductListWithHandler:(void (^)(BOOL))handler
{
    
    if(![self.fileManager checkIfJsonFileExists])
    {
        [self resyncInfoWithHandler:handler];
    }
    else
    {
        self.cachedInfo = [self.fileManager loadInfoFromJsonFile];
        handler(self.cachedInfo != nil);
    }
}

-(void)resyncInfoWithHandler:(void (^)(BOOL))handler
{
    [self.restDataManager getInfoFromServiceToHandler:^(NSData *data) {
        [self.fileManager loadInfoToJsonFile:data];
        self.cachedInfo = [self.fileManager loadInfoFromJsonFile];
        handler(self.cachedInfo != nil);
    }];
}

-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(BOOL))handler
{
    [self.restDataManager loginWithUsername:username withPassword:password withHandler:^(NSDictionary *data) {
       if(data[@"result"])
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

@end
