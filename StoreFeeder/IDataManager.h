//
//  IDataManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionResults.h"

@protocol IDataManager <NSObject>

@property(nonatomic, retain) NSArray *cachedInfo;


-(void)loadProductListWithHandler:(void(^)(BOOL))handler;
-(void)resyncInfoWithHandler:(void (^)(BOOL, ConnectionResult))handler;
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(BOOL))handler;
-(BOOL)checkLogin;
-(void)logout;
-(NSString *)getProfileOfLoggedInUser;


@end
