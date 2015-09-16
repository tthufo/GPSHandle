//
//  GPSLogInViewController.m
//  GPSHandle
//
//  Created by thanhhaitran on 9/15/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import "GPSLogInViewController.h"

@interface GPSLogInViewController ()

@end

@implementation GPSLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLocation];
    [self.navigationController loginWithInformation:@{} andTransition:YES];

}

- (IBAction)didPressLogIn:(id)sender
{
    [self.navigationController loginWithInformation:@{} andTransition:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
