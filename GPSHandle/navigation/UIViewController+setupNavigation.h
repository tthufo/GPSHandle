//
//  UIViewController+setupNavigation.h
//  99closets
//
//  Created by Binh Nguyen Xuan on 11/4/14.
//  Copyright (c) 2014 LIBRETeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (setupNavigation)

- (void)registerForKeyboardNotifications:(BOOL)isRegister andSelector:(NSArray*)selectors;

- (UIViewController*)topViewController;
@end
