//
//  UIViewController+TopBarAndBottomBarSpacing.m
//  Sociopathy
//
//  Created by Admin on 09.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import "UIViewController+TopBarAndBottomBarSpacing.h"

@implementation UIViewController (TopBarAndBottomBarSpacing)

- (UIEdgeInsets) addExtraInset: (UIEdgeInsets) extraInset
                            to: (UIEdgeInsets) to
{
    return UIEdgeInsetsMake(to.top + extraInset.top, to.left + extraInset.left, to.bottom + extraInset.bottom, to.right + extraInset.right);
}

- (void) fixInsetsOnTopAndBottom: (UIView*) subview
{
    UIEdgeInsets extraInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    
    //NSLog(@"Extra inset: %@", NSStringFromUIEdgeInsets(extraInset));
    
    if ([subview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* scrollView = (UIScrollView*) subview;
        scrollView.contentInset = extraInset; //[self addExtraInset:extraInset to:scrollView.contentInset];
    }
    else if ([subview isKindOfClass:[UIWebView class]])
    {
        UIWebView* webView = (UIWebView*) subview;
        webView.scrollView.contentInset = extraInset; //[self addExtraInset:extraInset to:webView.scrollView.contentInset];
    }
}

/*
- (void) insetOnTopAndBottom: (UIView*) subview
{
    UIEdgeInsets inset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    
    if ([subview isKindOfClass:[UIScrollView class]])
    {
        UIScrollView* scrollView = (UIScrollView*) subview;
        scrollView.contentInset = inset;
    }
    else if ([subview isKindOfClass:[UIWebView class]])
    {
        UIWebView* webView = (UIWebView*) subview;
        webView.scrollView.contentInset = inset;
    }
 }
 */
@end
