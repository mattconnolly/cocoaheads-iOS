//
//  CHMainViewController.h
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHMainViewController : UIViewController

@property (nonatomic,retain) UILabel* statusLabel;

- (IBAction)testMeetup:(id)sender;
- (IBAction)meetupLogOut:(id)sender;
- (IBAction)meetupLogIn:(id)sender;

@end
