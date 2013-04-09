//
//  FilterViewModal.h
//  StoreFeeder
//
//  Created by Victor Valenzuela on 3/14/13.
//  Copyright (c) 2013 Victor Valenzuela. All rights reserved.
//

#import "UATitledModalPanel.h"
#import "AccordionView.h"
#import "IFiltersManager.h"

@interface FilterViewModal : UAModalPanel

@property(nonatomic, weak) id<IFiltersManager> filtersManager;

-(void)loadView;

@end
