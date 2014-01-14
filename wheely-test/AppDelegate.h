//
//  AppDelegate.h
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MasterViewController.h"
#import "ServerCommunication.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NetworkSessionSource>

@property (nonatomic) UIWindow* window;
@property (nonatomic) NSURLSession* session;

@property (weak, nonatomic) MasterViewController* masterViewController;

@end
