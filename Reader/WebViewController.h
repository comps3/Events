//
//  WebViewController.h
//  Events
//
//  Created by Brian Huynh
//  Copyright (c) 2014 Brian Huynh. All rights reserved.


#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate> {
    
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic, copy) NSArray *rightBarButtonItems;
@property(nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property(nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property(nonatomic) BOOL keyboardDisplayRequiresUserAction;
@property(nonatomic, readonly, getter=isLoading) BOOL loading;
@property(nonatomic) BOOL mediaPlaybackAllowsAirPlay;


- (id)initWithURL:(NSString *)postURL title:(NSString *)postTitle;


@end
