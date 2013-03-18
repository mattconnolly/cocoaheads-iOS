//
//  CHMenuViewController.h
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHMenuViewController;

@protocol CHMenuViewControllerDelegate <NSObject>

- (void)menuViewController:(CHMenuViewController *)menuViewController didSelectRowAtIndex:(int)index;

@end


@interface CHMenuViewController : UITableViewController

@property (nonatomic, strong) id<CHMenuViewControllerDelegate> delegate;

@end


