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

typedef enum ChosenUserOption
{
    Admin,
    Normal    
} ChosenUserOption;

@property(nonatomic, retain) NSArray *cachedInfo;
@property(nonatomic, assign) ChosenUserOption chosenOption;

-(void)loadProductListWithHandler:(void(^)(BOOL))handler;
-(void)resyncInfoWithHandler:(void (^)(BOOL, ConnectionResult))handler;
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(BOOL))handler;
-(BOOL)checkLogin;
-(void)goBack;
-(NSString *)getProfileOfLoggedInUser;

-(void)pageProductsWithHandler:(int)page withhandler:(void (^)(NSArray *, ConnectionResult))handler;

@end
