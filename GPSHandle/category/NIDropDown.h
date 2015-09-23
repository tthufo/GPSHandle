//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
@property (nonatomic, retain) NSDictionary *selectedDetails;
@property (nonatomic, retain) UIColor * bgColor;
@property(nonatomic, strong) UIButton *btnSender;


- (void)hideDropDown;//:(UIButton *)b;
//- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction;
- (id)showDropDown:(CGRect )b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction:(UIView*)view:(UIColor*)color:(UIButton*)host:(int)preselected;

@end
