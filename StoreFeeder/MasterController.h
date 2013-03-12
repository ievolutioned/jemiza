//
//  MasterController.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDataManager.h"

@interface MasterController : NSObject<IDataManager>
{
    NSArray *_cachedInfo;
}

@end
