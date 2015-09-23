//
//  GPSMenuViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/16/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSMenuViewController.h"

@interface GPSMenuViewController ()
{
    IBOutlet UITableView * tableView;
    NSMutableArray * dataList;
    int currentTab;
    BOOL isExpand;
}
@end

@implementation GPSMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    isExpand = YES;
    dataList = [[NSMutableArray alloc] initWithArray:[[NSArray new] arrayWithPlist:@"MenuList"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isExpand ? (dataList.count + 1) : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return indexPath.row == 0 ? 181 : 65;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indexPath.row == 0 ? @"headerCell" : @"menu"];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GPSMenuCell" owner:nil options:nil][indexPath.row == 0 ? 0 : 1];
    }
    if(indexPath.row == 0)
    {
        [self didSetupHeaderCell:cell];
    }
    else
    {
        [self didSetupMenuCell:cell andIndexPath:indexPath];
    }
    return cell;
}

-(void)didSetupHeaderCell:(UITableViewCell*)cell
{
    UIImageView * avatar = (UIImageView*)[cell viewWithTag:11];
    [avatar setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kAvatar options:SDWebImageCacheMemoryOnly usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [avatar withBorder:@{@"Bcorner":@(avatar.frame.size.width / 2),@"Bwidth":@(1)}];
    
    ((UILabel*)[cell viewWithTag:12]).text = @"uname";
    ((UILabel*)[cell viewWithTag:14]).text = @"email";
    
    [((UIButton *)[cell viewWithTag:16]) addTarget:self action:@selector(didPressArrow:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)didSetupMenuCell:(UITableViewCell*)cell andIndexPath:(NSIndexPath*)indexPath
{
    UIImageView * image = (UIImageView*)[cell viewWithTag:11];
    image.image = [UIImage imageNamed:dataList[indexPath.row - 1][@"image"]];
    ((UILabel*)[cell viewWithTag:12]).text = dataList[indexPath.row - 1][@"title"];
    if(!isExpand)
    {
        [image setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kAvatar options:SDWebImageCacheMemoryOnly usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [image withBorder:@{@"Bcorner":@(image.frame.size.width / 2),@"Bwidth":@(1)}];
        ((UILabel*)[cell viewWithTag:12]).text = @"email";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) return;
    [self dismissPopupViewControllerWithanimationType:6];
    if(!isExpand) return;
    [self didPushView:(int)(indexPath.row - 1)];
}

-(void)didPressArrow:(id)sender
{
    isExpand =! isExpand;
    [tableView reloadDataWithAnimation:YES];
}

-(void)didPushView:(int)index
{
    if([NSStringFromClass([[self topViewController] class]) isEqualToString:dataList[index][@"view"]]) return;

    UIViewController * cons = [[NSClassFromString(dataList[index][@"view"]) alloc] initWithNibName:dataList[index][@"view"] bundle:nil];
    
    switch (index)
    {
        case 0:
        case 1:
        case 2:
            [[self topViewController].navigationController pushViewController:cons animated:YES];
            break;
        case 3:
            [self performSelector:@selector(didDismiss) withObject:nil afterDelay:0.5];
            break;
        default:
            break;
    }
}

-(void)didDismiss
{
    [[self topViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
