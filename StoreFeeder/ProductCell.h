//
//  ProductCell.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property(nonatomic, retain) IBOutletCollection(UILabel) NSArray *productInfoList;
@property(nonatomic, retain) NSArray *dataMapping;
-(void)loadData:(NSDictionary *)data;

@end
