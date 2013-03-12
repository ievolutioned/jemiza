//
//  FileManager.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "FileManager.h"

NSString *const kFilename = @"data.json";

@implementation FileManager

-(NSArray *)loadInfoFromJsonFile
{
    NSData *fileContent = [NSData dataWithContentsOfFile:[self getFilePath]];
    return [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:nil];
}


-(void)loadInfoToJsonFile:(NSData *)jsonInfo
{
    [jsonInfo writeToFile:[self getFilePath] atomically:YES];
}

-(BOOL)checkIfJsonFileExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[self getFilePath]];
}

-(NSString *)getFilePath
{
    NSString *directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [NSString stringWithFormat:@"%@/%@",directoryPath, kFilename];
    return path;
}

@end
