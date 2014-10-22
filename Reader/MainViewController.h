//
//  MainViewController.h
//  Events
//
//  Created by Brian Huynh
//  Copyright (c) 2014 Brian Huynh. All rights reserved.

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "KMXMLParser.h"


@interface MainViewController : UITableViewController <KMXMLParserDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *parseResults;
@property(nonatomic) BOOL mediaPlaybackAllowsAirPlay;



@end
