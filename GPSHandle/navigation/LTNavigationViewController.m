//
//  LTNavigationViewController.m
//  Lotto
//
//  Created by thanhhaitran on 2/14/15.
//  Copyright (c) 2015 libreteam. All rights reserved.
//

#import "LTNavigationViewController.h"

@interface LTNavigationViewController ()

@end

@implementation LTNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
