//
//  GPSAdminViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/16/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSAdminViewController.h"
#import "GPSMenuViewController.h"
#import "GPSAccountViewController.h"


@interface GPSAdminViewController ()

@end

@implementation GPSAdminViewController

@synthesize page;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray * arr = [NSMutableArray new];
    for(NSDictionary * dict in [[NSArray new] arrayWithPlist:@"GPSAdminList"])
    {
        id controller = [NSClassFromString(dict[@"control"]) new];
        ((UIViewController*)controller).title = dict[@"title"];
        [arr addObject:controller];
    }
    
    page = [[HBPageViewController alloc] initWithParentViewController:self];
    page.staticPicker = YES;
    page.enablePickerChin = YES;
    page.viewControllers = arr;
    [self.view addSubview:page.view];
}

-(IBAction)didPressMenu:(id)sender
{
    LTNavigationViewController * nav = [[LTNavigationViewController alloc] initWithRootViewController:[GPSMenuViewController new]];
    nav.accessibilityLabel = @"3rd";
    [self presentPopupViewController:nav animationType:6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
