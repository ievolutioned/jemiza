//
//  RESTDataManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RESTDataManager : NSObject

-(void)getInfoFromServiceToHandler:(void(^)(NSData*))handler;
-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void(^)(NSDictionary *))handler;

@end
