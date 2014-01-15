//
//  DetailViewController.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+TopBarAndBottomBarSpacing.h"
#import "UIView+SectionStyle.h"

@interface DetailViewController ()
@end

@implementation DetailViewController
{
    IBOutlet UIScrollView *scrollView;
    
    __weak IBOutlet UIView *containingView;
    
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIView *textView;
    
    __weak IBOutlet UILabel *noteTitle;
    __weak IBOutlet UILabel *text;
}

#pragma mark - Managing the detail item

- (void) viewDidLoad
{
    [super viewDidLoad];
	
    noteTitle.text = self.note.title;
    text.text = self.note.text;
    
    self.title = self.note.title;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [titleView stylize];
    [textView stylize];
    
    scrollView.contentInset = UIEdgeInsetsZero;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(containingView, scrollView);
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[containingView(==scrollView)]" options:0 metrics:0 views:views]];
}

- (void) updateNote: (Note*) note
{
    if (![self.note.text isEqualToString:note.text])
        text.text = note.text;
    
    self.note = note;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
