//
//  UINavigationController+login.h
//  99closets
//
//  Created by Binh Nguyen Xuan on 11/13/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (login)

- (void)loginWithInformation:(NSDictionary *)information andTransition:(BOOL)enable;

- (void)didDissmissAndLogOut;

@end
