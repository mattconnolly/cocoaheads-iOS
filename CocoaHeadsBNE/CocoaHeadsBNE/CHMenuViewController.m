//
//  CHMenuViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHMenuViewController.h"
#import "CHMainViewController.h"
#import <ECSlidingViewController.h>

@interface MenuItem : NSObject

@property (nonatomic, readonly, copy) NSString *label;
@property (nonatomic, readonly, copy) NSString *storyboardId;
@property (nonatomic, readonly) BOOL keepInMemory;
// Probably add an icon as well.

- (id)initWithLabel:(NSString *)label storyboardID:(NSString *)storyboardID keepInMemory:(BOOL)keep;

@end

@implementation MenuItem

- (id)initWithLabel:(NSString *)label storyboardID:(NSString *)storyboardID keepInMemory:(BOOL)keep
{
    self = [super init];
    if (self) {
        _label = label;
        _storyboardId = storyboardID;
        _keepInMemory = keep;
    }
    return self;
}

@end


@interface CHMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSMutableDictionary *viewControllers;

- (void)switchToMenuItem:(MenuItem *)menuItem;

@end


@implementation CHMenuViewController

- (void)awakeFromNib
{
    self.viewControllers = [@{} mutableCopy];

    MenuItem *homeMenuItem = [[MenuItem alloc] initWithLabel:@"Home" storyboardID:@"MainViewController" keepInMemory:YES];
    MenuItem *aboutMenuItem = [[MenuItem alloc] initWithLabel:@"About" storyboardID:@"AboutViewController" keepInMemory:NO];
    self.menuItems = @[homeMenuItem, aboutMenuItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-bg"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    [self switchToMenuItem:self.menuItems[0]];
    self.slidingViewController.anchorRightRevealAmount = 280.0;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

- (void)switchToMenuItem:(MenuItem *)menuItem
{
    UIViewController *newViewController = self.viewControllers[menuItem.storyboardId];
    if (newViewController == nil) {
        newViewController = [self.storyboard instantiateViewControllerWithIdentifier:menuItem.storyboardId];
        if (menuItem.keepInMemory) {
            self.viewControllers[menuItem.storyboardId] = newViewController;
        }
    }
    self.slidingViewController.topViewController = newViewController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    MenuItem *menuItem = self.menuItems[indexPath.row];
    cell.textLabel.text = menuItem.label;
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    cell.textLabel.shadowColor = [UIColor colorWithRed:0.4 green:0 blue:0 alpha:0.5];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menu-selected"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        [self switchToMenuItem:self.menuItems[indexPath.row]];
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *img = [[UIImage imageNamed:@"menu-separator"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    cell.backgroundView = imgView;
}

@end
