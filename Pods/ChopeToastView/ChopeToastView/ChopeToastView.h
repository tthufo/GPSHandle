//
//  ChopeToastView.h
//  ChopeLibrary
//
//  Created by Chope on 2014. 1. 16..
//  Copyright (c) 2014년 Chope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChopeToastView : UIView

@property (nonatomic, retain) UIFont *font UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIEdgeInsets margin UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat roundRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSTextAlignment textAlignment UI_APPEARANCE_SELECTOR;

@property (nonatomic, retain) NSString *message;

@property (nonatomic) CGFloat backgroundAlpha DEPRECATED_ATTRIBUTE;


+ (instancetype)ToastViewWithMessage:(NSString*)message __attribute__ ((deprecated));
+ (instancetype)toastViewWithMessage:(NSString*)message;

- (void)showWithAnimation:(void (^)(ChopeToastView *toastView))animation;
- (void)showWithDuration:(NSTimeInterval)time;
- (void)show;

- (void)hide;

@end
