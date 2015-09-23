//
//  GPSChartViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/22/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSChartViewController.h"
#import "PNChartDelegate.h"
#import "PNChart.h"

@interface GPSChartViewController ()<PNChartDelegate>
{
    PNPieChart *pieChart;
}

@end

@implementation GPSChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen description:@"Other"],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                       ];
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50, 50, screenWidth - 100, screenWidth - 100) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    pieChart.showAbsoluteValues = NO;
    pieChart.showOnlyValues = NO;
    [pieChart strokeChart];
    
    pieChart.legendStyle = PNLegendItemStyleStacked;
    
    UIView *legend = [pieChart getLegendWithMaxWidth:200];
    legend.backgroundColor = [UIColor redColor];
    [legend setFrame:CGRectMake(130, 60 + screenWidth - 140 + 55, legend.frame.size.width, legend.frame.size.height)];
    //[self.view addSubview:legend];
    
    [self.view addSubview:pieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
