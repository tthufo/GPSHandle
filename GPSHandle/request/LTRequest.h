//
//  LTRequest.h
//  Lotto
//
//  Created by thanhhaitran on 3/3/15.
//  Copyright (c) 2015 libreteam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

typedef void (^RequestCompletion)(NSString * responseString, NSError * error, BOOL isValidated);

@protocol RequestDelegate <NSObject>

@optional

-(void)didFinishUploadImage:(NSDictionary*)dict;

-(void)didFinishLogOut:(NSDictionary*)dict;

-(void)didFinishCloseShop:(NSDictionary*)dict;

@end

@interface LTRequest : NSObject

@property(nonatomic,copy) RequestCompletion completion;

+ (LTRequest*)sharedInstance;

- (void)didRequestInfo:(NSDictionary*)dict andCompletion:(RequestCompletion)completion;

- (void)didUploadImages:(NSArray*)images andHost:(UIViewController*)host;

- (void)didRequestUserInfo:(RequestCompletion)completion andShow:(UIViewController*)host;

@property(nonatomic,weak) MBProgressHUD * hud;

@property(nonatomic,retain) NSMutableArray * uploadImage;

@property(nonatomic,assign) id<RequestDelegate> delegate;

@end
