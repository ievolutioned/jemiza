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

@end
