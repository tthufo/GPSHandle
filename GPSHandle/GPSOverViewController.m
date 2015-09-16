//
//  GPSOverViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/16/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSOverViewController.h"
#import "GPSMenuViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface GPSOverViewController ()<PNChartDelegate>
{
    PNPieChart *pieChart;
}
@end

@implementation GPSOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen description:@"Other"],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                       ];
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(screenWidth /2.0 - 100, 135, 200.0, 200.0) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = NO;
    [pieChart strokeChart];
    
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:pieChart];
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
