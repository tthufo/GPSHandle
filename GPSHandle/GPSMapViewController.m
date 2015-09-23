//
//  GPSMapViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/15/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSMapViewController.h"
#import "GPSMenuViewController.h"
#import <MapKit/MapKit.h>

@interface GPSMapViewController ()<NIDropDownDelegate>
{
    IBOutlet MKMapView * mapView;
    NIDropDown *dropDown;
}

@end

@implementation GPSMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction)didGotoUserLocation:(id)sender
{
    [self mapView:mapView didUpdateUserLocation:mapView.userLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self didGotoUserLocation:nil];
}

-(IBAction)didPressMenu:(id)sender
{
    LTNavigationViewController * nav = [[LTNavigationViewController alloc] initWithRootViewController:[GPSMenuViewController new]];
    nav.accessibilityLabel = @"3rd";
    [self presentPopupViewController:nav animationType:6];
}

-(IBAction)didPressOptions:(id)sender
{
    UIButton * cover = [UIButton buttonWithType:UIButtonTypeCustom];
    cover.tag = 99909;
    cover.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [cover addTarget:self action:@selector(didPressCover:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cover];
    if(dropDown == nil)
    {
        CGFloat f = 140;
        dropDown = [[NIDropDown alloc] showDropDown:((UIButton*)sender).frame :&f :[[NSArray new] arrayWithPlist:@"GPSOptionList"] :@[] :@"down" :self.view : [UIColor redColor]:sender : 0];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown];
        dropDown = nil;
    }
}

- (void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    [self didPressCover:sender.btnSender];
    [dropDown hideDropDown];
    dropDown = nil;
}

-(void)didPressCover:(UIButton*)sender
{
    [[self.view viewWithTag:99909] removeFromSuperview];
    [dropDown hideDropDown];
    dropDown = nil;
}


- (void)mapView:(MKMapView *)_mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
}

-(MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
