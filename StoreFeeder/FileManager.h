//
//  FileManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

-(void)loadInfoToJsonFile:(NSData *)jsonInfo;
-(BOOL)saveLoginInfo:(NSDictionary *)loginInfo;
-(BOOL)checkIfJsonFileExists;
-(void)loadInfoFromJsonFileWithHandler:(void(^)(NSArray *))handler;
-(BOOL)checkIfLoginInfoExists;
-(void)logout;
-(NSString *)getProfileOfLoggedInUser;
-(void)loadFilterInfo:(NSString *)filter toHandler:(void(^)(NSArray *))handler;

@end
