//
//  CHMenuViewController.m
//  CocoaHeadsBNE
//
//  Created by Yann Bodson on 18/03/13.
//  Copyright (c) 2013 CocoaHeads Brisbane. All rights reserved.
//

#import "CHMenuViewController.h"

@interface CHMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end


@implementation CHMenuViewController

- (void)awakeFromNib
{
    self.menuItems = @[@"Home", @"Resources", @"Settings", @"About", @"#cocoaheadsbne"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu-bg"]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    cell.textLabel.text = self.menuItems[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0, -1);
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menu-selected"] resizableImageWithCapInsets:UIEdgeInsetsZero]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuViewController:self didSelectRowAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *img = [[UIImage imageNamed:@"menu-separator"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    cell.backgroundView = imgView;
}

@end
