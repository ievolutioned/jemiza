//
//  ProductDetailView.m
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "LineDrawProductDetail.h"

@implementation LineDrawProductDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        CGContextSetLineWidth(context, 1.0);
    
        CGContextMoveToPoint(context, self.center.x,0); //start at this point
        CGContextAddLineToPoint(context, CGContextGetPathCurrentPoint(context).x,
                                CGContextGetPathCurrentPoint(context).y + 268); //draw to this point
        
        CGPoint startingPoint = CGPointMake(0, 62);
        
        for(int i = 0;i<3;i++)
        {
            CGContextMoveToPoint(context, startingPoint.x ,startingPoint.y); //start at this point
            CGContextAddLineToPoint(context, CGContextGetPathCurrentPoint(context).x + self.frame.size.width,
                                    CGContextGetPathCurrentPoint(context).y); //draw to this point
            startingPoint.y += 64;
        }
    
        // and now draw the Path!
        CGContextStrokePath(context);
    }
}

@end
