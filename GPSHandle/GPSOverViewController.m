//
//  GPSOverViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/16/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSOverViewController.h"
#import "GPSMenuViewController.h"
#import "GPSChartViewController.h"
#import "GPSSummaryViewController.h"

@interface GPSOverViewController ()

@end

@implementation GPSOverViewController

@synthesize page;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GPSChartViewController * chart = [GPSChartViewController new];
    chart.title = @"Chart";
    
    GPSSummaryViewController * summary = [GPSSummaryViewController new];
    summary.title = @"Summary";
    
    page = [[HBPageViewController alloc] initWithParentViewController:self];
    page.staticPicker = YES;
    page.enablePickerChin = YES;
    page.viewControllers = @[chart, summary];
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
