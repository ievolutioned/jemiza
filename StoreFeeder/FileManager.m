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

-(void)loadInfoFromJsonFileWithHandler:(void(^)(NSArray *))handler
{
    NSData *fileContent = [NSData dataWithContentsOfFile:[self getFilePath:kDataFilename]];
    [self parseDates:[NSJSONSerialization JSONObjectWithData:fileContent options:NSJSONReadingMutableContainers error:nil] toHandler:handler];
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

-(void)parseDates:(NSMutableArray *)json toHandler:(void(^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSArray *mapping = @[@"created_at", @"updated_at"];
        for(NSMutableDictionary *item in json)
        {
            [mapping enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if([item valueForKeyPath:obj] != [NSNull null])
                {
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                    
                    NSDate *date = [formatter dateFromString:[item valueForKeyPath:obj]];
                    [item setValue:date forKeyPath:obj];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(json);
        });
    });
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

-(void)loadFilterInfo:(NSString *)filter toHandler:(void(^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *filteredInfo = nil;
        if([fileManager fileExistsAtPath:[self getFilePath:[NSString stringWithFormat:@"%@.json", filter]]])
        {
            NSData *fileContent = [NSData dataWithContentsOfFile:[self getFilePath:kDataFilename]];
            filteredInfo = [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:nil];
        }
        else
        {
            filteredInfo = [self filterValuesForFilter:filter];
            [filteredInfo writeToFile:[self getFilePath:[NSString stringWithFormat:@"%@.json", filter]] atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(filteredInfo);
        });
    });
}

-(NSArray *)filterValuesForFilter:(NSString *)filter
{
    NSData *fileContent = [NSData dataWithContentsOfFile:[self getFilePath:kDataFilename]];
    NSArray *jsonInfo = [NSJSONSerialization JSONObjectWithData:fileContent options:NSJSONReadingMutableContainers error:nil];
    
    NSString *keyToSearch;
    if([filter isEqualToString:@"category"])
    {
        keyToSearch = @"description_category";
    }
    else if([filter isEqualToString:@"subfamily"])
    {
        keyToSearch = @"description_sub_family";
    }
    else //warehouse
    {
        keyToSearch = @"warehouse";
    }

    NSMutableArray *valueList = [NSMutableArray new];
    [jsonInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(![valueList containsObject:obj[keyToSearch]])
        {
            [valueList addObject:obj[keyToSearch]];
        }
    }];

    return valueList;
}

@end
