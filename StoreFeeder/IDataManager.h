//
//  IDataManager.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IDataManager <NSObject>

@property(nonatomic, readonly) NSArray *cachedInfo;
-(void)loadProductListWithHandler:(void(^)(BOOL))handler;


@end
