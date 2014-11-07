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
        if(self.cellType == NORMALCELL)
            self.dataMapping = @[@"product_code", @"description", @"stock"];
        else
            self.dataMapping = @[@"product_code", @"description", @"last_cost"];
    }
    NSLog(@"start");
    [self.productInfoList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
            if(data[self.dataMapping[idx]] != [NSNull null])
            {
                if([[data[self.dataMapping[idx]] class] isSubclassOfClass:[NSNumber class]])
                {
                    float value = [data[self.dataMapping[idx]] floatValue];
                    if(self.cellType == NORMALCELL)
                        [((UILabel *)obj) setText:[NSString stringWithFormat:@"%.2f", value]];
                    else
                        [((UILabel *)obj) setText:[NSString stringWithFormat:@"$ %.2f", value]];
                }
                else
                {
                    NSString *str = [NSString stringWithFormat:@"%@", data[self.dataMapping[idx]]];
                    [((UILabel *)obj) setText:str];
                }
            }
            else
            {
                [((UILabel *)obj) setText:@""];
            }
            NSLog([NSString stringWithFormat:@"%lu",(unsigned long)idx]);
    }];
    NSLog(@"fin");
}

@end
