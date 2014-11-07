//
//  RESTDataManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionResults.h"

@interface RESTDataManager : NSObject

-(void)getInfoFromServiceWithAccessToken:(NSString *)accessToken ToHandler:(void (^)(NSData *, ConnectionResult))handler;
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void(^)(NSDictionary *))handler;




-(void)getPrudutcsByPageFromServiceWithAccessToken:(NSString *)accessToken withPage:(int)Page ToHandler:(void (^)(NSData *, ConnectionResult))handler;
@end
