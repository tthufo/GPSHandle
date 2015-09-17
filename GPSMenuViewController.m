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
}
@end

@implementation GPSMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataList = [[NSMutableArray alloc] initWithArray:[[NSArray new] arrayWithPlist:@"MenuList"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu"] ;
    }
    
    cell.textLabel.text = dataList[indexPath.row][@"title"];
    return cell;
}

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissPopupViewControllerWithanimationType:6];
    [self didPushView:indexPath.row];
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
