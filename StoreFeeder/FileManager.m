//
//  FileManager.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "FileManager.h"

NSString *const kDataFilename = @"data.json";
NSString *const kLoginFilename = @"login.info";

@implementation FileManager

-(NSArray *)loadInfoFromJsonFile
{
    NSData *fileContent = [NSData dataWithContentsOfFile:[self getFilePath:kDataFilename]];
    return [self parseDates:[NSJSONSerialization JSONObjectWithData:fileContent options:NSJSONReadingMutableContainers error:nil]];
}


-(void)loadInfoToJsonFile:(NSData *)jsonInfo
{
    [jsonInfo writeToFile:[self getFilePath:kDataFilename] atomically:YES];
}

-(BOOL)checkIfJsonFileExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self getFilePath:kDataFilename]];
}

-(NSMutableArray *)parseDates:(NSMutableArray *)json
{
    NSArray *mapping = @[];
    return nil;
}

-(NSString *)getFilePath:(NSString *)filename
{
    NSString *directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath, filename];
    return path;
}

-(BOOL)saveLoginInfo:(NSDictionary *)loginInfo
{
    return [NSKeyedArchiver archiveRootObject:loginInfo toFile:[self getFilePath:kLoginFilename]];
}

-(BOOL)checkIfLoginInfoExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self getFilePath:kLoginFilename]];
}

-(void)logout
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exists = [fm fileExistsAtPath:[self getFilePath:kLoginFilename]];
    if(exists == YES) [fm removeItemAtPath:[self getFilePath:kLoginFilename] error:nil];
}

-(NSString *)getProfileOfLoggedInUser
{
    if([self checkIfLoginInfoExists])
    {
        @try {
            NSMutableDictionary *appState = [NSKeyedUnarchiver unarchiveObjectWithFile: [self getFilePath:kLoginFilename]];
            return appState[@"profile"];
        }
        @catch (NSException *exception) {
            return nil;
        }
    }
    return nil;
}

@end
