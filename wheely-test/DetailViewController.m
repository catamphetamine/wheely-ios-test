//
//  DetailViewController.m
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+TopBarAndBottomBarSpacing.h"

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
    
    __weak IBOutlet NSLayoutConstraint *dummyWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *dummyHeightConstraint;
}

#pragma mark - Managing the detail item

- (void) viewDidLoad
{
    [super viewDidLoad];
	
    noteTitle.text = self.note.title;
    text.text = self.note.text;
    
    self.title = self.note.title;

    // хз, как он догадался в interface builder-е, что нужно для containingView нужно сверху отступить, чтобы вылезти из-под navigation bar-а
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(containingView, scrollView);
    
    // remove dummy constraints for width and height
    [containingView removeConstraint:dummyWidthConstraint];
    [containingView removeConstraint:dummyHeightConstraint];
    
    // add real constrants
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[containingView(==scrollView)]" options:0 metrics:0 views:views]];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    scrollView.scrollIndicatorInsets = [self guidedInsets];
}

- (void) updateNote: (Note*) note
{
    if (![self.note.text isEqualToString:note.text])
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ text.alpha = 0; }
                         completion:^(BOOL finished)
        {
            if (!finished)
                return;
            
            text.text = note.text;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn
                             animations:^{ text.alpha = 1; }
                             completion:nil];
        }];
    }
    
    self.note = note;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
