//
//  ProductCell.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/12/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString *)reuseIdentifier
{
    return @"ProductCellIPad";
}

-(void)loadData:(NSDictionary *)data
{
    if(!self.dataMapping)
    {
        self.dataMapping = @[@"id", @"description", @"quantity"];
    }
    [self.productInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UILabel *)obj) setText:data[self.dataMapping[idx]]];
    }];
}

@end
