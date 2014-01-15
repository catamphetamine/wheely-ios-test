//
//  DetailViewController.h
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Note.h"

@interface DetailViewController : UIViewController

@property (nonatomic) Note* note;

- (void) updateNote: (Note*) note;

@end
