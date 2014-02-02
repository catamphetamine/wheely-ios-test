//
//  NoteCell.h
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Note.h"

#import "DynamicRowHeightTableViewCell.h"

@interface NoteCell : UITableViewCell <DynamicRowHeightTableViewCell>

- (void) note: (Note*) note;

@end
