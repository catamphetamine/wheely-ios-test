//
//  MasterViewController.h
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServerCommunication.h"
#import "DynamicRowHeightTableViewController.h"

@interface MasterViewController : DynamicRowHeightTableViewController <UITableViewDelegate, UITableViewDataSource, ServerCommunicationDelegate>

- (void) fetchNotes;
- (void) startRefreshTimer;
- (void) stopRefreshTimer;

@end
