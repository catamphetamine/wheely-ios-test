//
//  DynamicRowHeightTableViewController.h
//  Sociopathy
//
//  Created by Admin on 13.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicRowHeightTableViewController : UIViewController
- (void) purgeCachedRowHeightFor: (id) dataSetItem;
- (void) purgeCache;
@end
