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
    return [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:nil];
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

@end
