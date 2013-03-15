//
//  RESTDataManager.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "RESTDataManager.h"

@implementation RESTDataManager

-(void)getInfoFromServiceToHandler:(void (^)(NSData *, ConnectionResult))handler
{
    NSLog(@"Comenzando bajado de info");
    NSURL *url = [NSURL URLWithString:@"http://jemiza.herokuapp.com/admin/products.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Terminado bajado de info");
        if(!error)
        {
            handler(data, CR_SUCCESS);
        }
        else
        {
            if(error.code == kCFURLErrorTimedOut)
            {
                handler(nil, CR_TIMEOUT);
            }
            else if(error.code == kCFURLErrorBadURL)
            {
                handler(nil, CR_NOTFOUND);
            }
            else
            {
                handler(nil, CR_ERROR);
            }
        }
    }];
}

-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password withHandler:(void (^)(NSDictionary *))handler
{
    NSDictionary *data = @{@"result": @YES, @"profile": @"admin"};
    handler(data);
}

@end
