//
//  ChopeToastView.m
//  ChopeLibrary
//
//  Created by Chope on 2014. 1. 16..
//  Copyright (c) 2014년 Chope. All rights reserved.
//

#import "ChopeToastView.h"

@implementation ChopeToastView

- (id)init
{
    self = [super init];
    if (self) {
        [self setFrame:[self window].bounds];
        [self setUserInteractionEnabled:NO];
    }
    
    return self;
}


#pragma mark - Getter
- (UIWindow*)window
{
    return [[UIApplication sharedApplication].windows lastObject];
}

- (UIFont*)font
{
    return _font ? _font : [UIFont systemFontOfSize:14.0];
}

- (UIColor*)textColor
{
    return _textColor ? _textColor : [UIColor whiteColor];
}

- (UIEdgeInsets)padding
{
    return UIEdgeInsetsEqualToEdgeInsets(_padding, UIEdgeInsetsZero) ? UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) : _padding;
}

- (UIEdgeInsets)margin
{
    return UIEdgeInsetsEqualToEdgeInsets(_margin, UIEdgeInsetsZero) ? UIEdgeInsetsMake(10.0, 10.0, 80.0, 10.0) : _margin;
}

- (CGFloat)roundRadius
{
    return _roundRadius > 0 ? _roundRadius : 10.0;
}


#pragma mark - Draw
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize = [self boundingSizeForMessage];
    CGRect frame = CGRectMake((self.window.frame.size.width - textSize.width - self.padding.left - self.padding.right) / 2.0,
                              self.window.frame.size.height - textSize.height - self.padding.top - self.padding.bottom - self.margin.bottom,
                              textSize.width + self.padding.left + self.padding.right,
                              textSize.height + self.padding.top + self.padding.bottom);
    [self setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    CGSize textSize = [self boundingSizeForMessage];

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:self.textAlignment];

    NSMutableDictionary *attr = [NSMutableDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName];
    [attr setObject:self.textColor forKey:NSForegroundColorAttributeName];
    [attr setObject:self.font forKey:NSFontAttributeName];

    [self.message drawInRect:CGRectMake(self.padding.left, self.padding.top, textSize.width, textSize.height)
              withAttributes:attr];
    
    self.layer.cornerRadius = self.roundRadius;
    self.layer.masksToBounds = YES;
}

- (CGSize)boundingSizeForMessage
{
    CGSize size = CGSizeMake(self.window.frame.size.width - self.margin.left - self.margin.right - self.padding.left - self.padding.right,
                             CGFLOAT_MAX);
    
    CGSize resultSize;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#
#ifdef __IPHONE_7_0
    // for simulator
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        resultSize = [self.message boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{ NSFontAttributeName:self.font }
                                                context:nil].size;
    }
    else {
        resultSize = [self.message sizeWithFont:self.font
                              constrainedToSize:size
                                  lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    resultSize = [self.message sizeWithFont:self.font
                          constrainedToSize:size
                              lineBreakMode:NSLineBreakByWordWrapping];
#endif
#
#pragma clang diagnostic pop
    
    resultSize.width = ceil(resultSize.width);
    resultSize.height = ceil(resultSize.height);
    
    return resultSize;
}


#pragma mark - Default cretate
+ (instancetype)ToastViewWithMessage:(NSString*)message
{
    return [ChopeToastView toastViewWithMessage:message];
}

+ (instancetype)toastViewWithMessage:(NSString*)message
{
    ChopeToastView *toastView = [[ChopeToastView alloc] init];
    [toastView setMessage:message];
    return toastView;
}


#pragma mark - Show method
- (void)showWithAnimation:(void (^)(ChopeToastView *toastView))animation
{
    [self.window addSubview:self];
    
    if (animation) {
        animation(self);
    }
}

- (void)showWithDuration:(NSTimeInterval)time
{
    [self showWithAnimation:^(ChopeToastView *toastView){
        self.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5
                                                   delay:time
                                                 options:UIViewAnimationOptionTransitionNone
                                              animations:^{
                                                  self.alpha = 0.0;
                                              }
                                              completion:^(BOOL finished) {
                                                  [self hide];
                                              }];
                         }];
    }];
}

- (void)show
{
    [self showWithDuration:3.0];
}

- (void)hide
{
    [self removeFromSuperview];
}


#pragma mark - Deprecated method
- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    if (self.backgroundColor) {
        const CGFloat* components = CGColorGetComponents(self.backgroundColor.CGColor);
        [super setBackgroundColor:[UIColor colorWithRed:components[0]
                                                  green:components[1]
                                                   blue:components[2]
                                                  alpha:backgroundAlpha]];
    }
    else {
        [super setBackgroundColor:[UIColor colorWithRed:0
                                                  green:0
                                                   blue:0
                                                  alpha:backgroundAlpha]];
    }
}


@end
