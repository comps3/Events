//
//  WebViewController.m
//  Events
//
//  Created by Brian Huynh
//  Copyright (c) 2014 Brian Huynh. All rights reserved.

#import "MainViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"


@interface WebViewController ()

@end

@implementation WebViewController

@synthesize url = _url, webView = _webView, canGoBack = _canGoBack, canGoForward = _canGoForward;


- (id)initWithURL:(NSString *)postURL title:(NSString *)postTitle
{
    self = [super init];
    
    if (self) {
        _url = postURL;
        self.title = @"Event";

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.url = [self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  
    NSURL *newURL = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:newURL]];
    
    
    _webView.delegate = self;

    // Add Pinch to Zoom
    _webView.scalesPageToFit = YES;
    _webView.autoresizesSubviews = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;

    // More Options
    _keyboardDisplayRequiresUserAction = YES;
    _mediaPlaybackAllowsAirPlay = YES;
    
    // Removes text behind navigation bar back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Set the navigation bar color to white
    self.navigationController.navigationBar.tintColor =  [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
    
    // Allows users to share the events
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(shareButtonTouched)];
    shareButton.tintColor = [UIColor colorWithRed:0/255.0 green:48/255.0 blue:75/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = shareButton;
    
 
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//Called whenever the view finished loading something
- (void)webViewDidFinishLoad:(UIWebView *)webView_ {
    
    //[self.navigationController finishSGProgress];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)shareButtonTouched
{
    // Shortening url with TinyURL API
    NSString *apiEndpoint = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@",self.url];
    NSString *shortURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiEndpoint]
                                                  encoding:NSASCIIStringEncoding
                                                     error:nil];

    NSString * shareString =  [NSString stringWithFormat:@"%@ - %@", self.title, shortURL];
    NSArray * shareArray = [NSArray arrayWithObject:shareString];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:shareArray applicationActivities:nil];
    
    // Excluding a few irrelevant services
    controller.excludedActivityTypes= @[UIActivityTypePostToFlickr, UIActivityTypeCopyToPasteboard, UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
   
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
   
    // Release memory once Web View is finished
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [_webView stringByEvaluatingJavaScriptFromString:@"var body=document.getElementsByTagName('body')[0];body.style.backgroundColor=(body.style.backgroundColor=='')?'white':'';"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
    _webView = nil;
    // Release any retained subviews of the main view.
}

// Orientation lock
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
