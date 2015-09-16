//
//  UINavigationController+login.m
//  99closets
//
//  Created by Binh Nguyen Xuan on 11/13/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import "UINavigationController+login.h"
#import "GPSMapViewController.h"

@implementation UINavigationController (login)

- (void)loginWithInformation:(NSDictionary *)information andTransition:(BOOL)enable
{
    LTNavigationViewController *rootview = [[LTNavigationViewController alloc] initWithRootViewController:[GPSMapViewController new]];
    rootview.accessibilityLabel = @"2nd";
    [rootview setNavigationBarHidden:YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.9;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self presentViewController:rootview animated:enable completion:^{
        
    }];
}

-(void)didDissmissAndLogOut
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
