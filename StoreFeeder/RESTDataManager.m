//
//  RESTDataManager.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "RESTDataManager.h"

@implementation RESTDataManager

-(void)getInfoFromServiceWithAccessToken:(NSString *)accessToken ToHandler:(void (^)(NSData *, ConnectionResult))handler
{
    
    
    NSLog(@"Comenzando bajado de info con token %@", accessToken);
    
    // NSURL *urlOld = [NSURL URLWithString:[NSString stringWithFormat:@"http://jemiza.herokuapp.com/admin/products.json?access_token=%@", accessToken]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jemiza.herokuapp.com/admin/products.json?access_token=%@", accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    [request addValue:@"1" forHTTPHeaderField:@"page"];
    
    
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


-(void)getPrudutcsByPageFromServiceWithAccessToken:(NSString *)accessToken withPage:(int )Page ToHandler:(void (^)(NSData *, ConnectionResult))handler
{
    
    
    NSLog(@"Comenzando bajado de info con token %@", accessToken);
    
    // NSURL *urlOld = [NSURL URLWithString:[NSString stringWithFormat:@"http://jemiza.herokuapp.com/admin/products.json?access_token=%@", accessToken]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jemiza.herokuapp.com/admin/products.json?access_token=%@", accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    [request addValue:[NSString stringWithFormat:@"%d",Page] forHTTPHeaderField:@"page"];
    
    
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
    NSURL *url = [NSURL URLWithString:@"http://jemiza.herokuapp.com/admin/login.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSDictionary *jsonDict = @{@"admin_user": @{@"email": username, @"password": password}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Terminado login");
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSDictionary *result = nil;
        if(!error && [responseJson[@"success"] boolValue])
        {
            NSLog(@"Access token retrieved: %@", responseJson[@"user"][@"access_token"]);
            result =  @{@"result": @YES, @"profile": responseJson[@"user"][@"role"], @"accessToken": responseJson[@"user"][@"access_token"]};
        }
        else
        {
            result = @{@"result": @NO};
        }
        handler(result);
    }];
}

@end
