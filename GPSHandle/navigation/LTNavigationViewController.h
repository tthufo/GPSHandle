//
//  LTNavigationViewController.h
//  Lotto
//
//  Created by thanhhaitran on 2/14/15.
//  Copyright (c) 2015 libreteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationDelegate <NSObject>

@optional

- (void)navigationDidFinish:(NSDictionary *)dict;

@end

@interface LTNavigationViewController : UINavigationController

@property(nonatomic,assign) id <NavigationDelegate> delegateNavigation;

@end
