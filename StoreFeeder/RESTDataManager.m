//
//  RESTDataManager.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "RESTDataManager.h"

@implementation RESTDataManager

-(void)getInfoFromServiceToHandler:(void (^)(NSData *))handler
{
    NSURL *url = [NSURL URLWithString:@"http://jemiza.herokuapp.com/admin/products.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(!error)
        {
            handler(data);
        }
    }];
}

-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(NSDictionary *))handler
{
    NSDictionary *data = @{@"result": @YES, @"profile": @"normal"};
    handler(data);
}

@end
