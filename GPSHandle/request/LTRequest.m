//
//  LTRequest.m
//  Lotto
//
//  Created by thanhhaitran on 3/3/15.
//  Copyright (c) 2015 libreteam. All rights reserved.
//

#import "LTRequest.h"

#import "MBProgressHUD.h"

#import "Reachability.h"

#import <ASIHTTPRequest/ASINetworkQueue.h>
#import <ASIFormDataRequest.h>

static LTRequest *__sharedLTRequest = nil;

@implementation LTRequest

+ (LTRequest *)sharedInstance
{
    if (!__sharedLTRequest)
    {
        __sharedLTRequest = [[LTRequest alloc] init];
    }
    return __sharedLTRequest;
}

- (void)didRequestUserInfo:(RequestCompletion)completion andShow:(UIViewController*)host
{
    if(!kToken) return;
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    
    if(host)
    {
        dict[@"host"] = host;
    }
    
    [dict addEntriesFromDictionary:@{@"token":kToken,@"method":@"GET",@"url":@"userinfo"}];
    
    [[LTRequest sharedInstance] didRequestInfo:dict
     andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
                  
         if(isValidated)
         {
             NSDictionary * result = [responseString objectFromJSONString];
             
             //[Setting addDataValue:result[@"data"] andKey:@"userinfo"];
             [self addValue:result[@"data"] andKey:@"userinfo"];
             completion(responseString, nil, [self didRespond:result andHost:host]);
         }
     }];
}

- (void)didRequestInfo:(NSDictionary*)dict andCompletion:(RequestCompletion)completion
{
    NSMutableDictionary * data = [dict mutableCopy];
    
    data[@"completion"] = completion;
    
    [self initRequest:data];
}

-(MBProgressHUD*)progressHUD:(BOOL)isImage andHost:(UIViewController*)host
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:host.view animated:YES];
    
    hud.mode = MBProgressHUDModeDeterminate;
    
    //hud.labelText = isImage ? XBText(@"Uploading", @"editprofileScreen") : XBText(@"Gathering information", @"loginScreen");
    
    [hud show:YES];
    
    return hud;
}

- (void)didUploadImages:(NSArray*)images andHost:(UIViewController*)host
{
    if(![self isConnectionAvailable])
    {
        [self alert:kAttention message:@"Check your internet connection"];
        
        if(host)
        {
            [host hideHUD];
        }
        
        return;
    }
    
    self.uploadImage = [NSMutableArray new];
    
    self.hud = [self progressHUD:YES andHost:host];
    
    if(images.count == 1)
        self.hud.mode = MBProgressHUDModeIndeterminate;
    
    ASINetworkQueue *  myQueue = [ASINetworkQueue queue];
    
    [myQueue cancelAllOperations];
    
    [myQueue setDelegate:self];
    
    [myQueue setDownloadProgressDelegate:self.hud];
    
    [myQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    
    myQueue.maxConcurrentOperationCount = 5;
    
    for (NSDictionary * dict in images)
    {
        int type = [dict responseForKey:@"image"] ? 0 : [dict responseForKey:@"media"] ? 1 : 2;
        
        NSString * url = [dict responseForKey:@"image"] ? @"addphoto" : [dict responseForKey:@"media"] ? @"upload_media" : @"upload_by_url";
        
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kGallery,url]]];
        
        request.timeOutSeconds = 60;
        
        switch (type)
        {
            case 0:
            {
                [request setData:UIImageJPEGRepresentation(dict[@"image"],1) withFileName:@"img.jpg" andContentType:@"image/jpg" forKey:@"uploadimg"];
            }
                break;
            case 1:
            {
                if([dict responseForKey:@"isVideo"])
                {
                    [request setData:[[NSData alloc] initWithContentsOfURL:dict[@"media"]] withFileName:@"video.MOV"  andContentType:@"video/quicktime" forKey:@"media"];
                    
                    [request setPostValue:@1 forKey:@"media_type"];
                }
                if([dict responseForKey:@"isAudio"])
                {
                    NSArray *nameArr = [dict[@"audio"] componentsSeparatedByString:@"/"];
                    
                    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:dict[@"url"]];
                    
                    NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:fileURL];
                    
                    [request setData:dataToSend withFileName:[nameArr lastObject]  andContentType:@"audio/m4a" forKey:@"media"];
                    
                    [request setPostValue:@0 forKey:@"media_type"];
                }
            }
                break;
            case 2:
            {
                [request setPostValue:dict[@"url"] forKey:@"url"];
            }
                break;
            default:
                break;
        }
        
        BOOL isMedia = [dict responseForKey:@"isVideo"] || [dict responseForKey:@"isAudio"];
        
        __block ASIFormDataRequest *_request = request;
        
        _request.tag = [images indexOfObjectIdenticalTo:dict];
        
        [request setCompletionBlock:^{
            
            NSDictionary * dict = [_request.responseString objectFromJSONString];;
            
            if([dict responseForKindOfClass:@"code" andTarget:@"200"])
            {
                [self.uploadImage addObject:@{isMedia ? @"media_id" : @"photo_id":dict[isMedia ? @"media_id" : @"photo_id"],@"order":@(_request.tag)}];
            }
            else
            {
                [self.hud removeFromSuperview];
                
                [myQueue cancelAllOperations];
                
                [self didRespond:dict andHost:host];
            }
        }];
        [request setFailedBlock:^
         {
             [self.hud removeFromSuperview];
             
             [myQueue cancelAllOperations];
             
             [self didRespond:nil andHost:host];
         }];
        
        [myQueue addOperation:request];
    }
    [myQueue go];
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
    [self.hud removeFromSuperview];
    
    NSMutableArray * arr = [NSMutableArray new];
    
    for(int i = 0; i< self.uploadImage.count; i++)
    {
        for(NSDictionary * dict in self.uploadImage)
        {
            if([dict responseForKindOfClass:@"order" andTarget:[NSString stringWithFormat:@"%i",i]])
            {
                [arr addObject: [dict responseForKey:@"photo_id"] ? dict[@"photo_id"] : dict[@"media_id"]];
            }
        }
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishUploadImage:)])
    {
        [self.delegate didFinishUploadImage:@{@"id":arr}];
    }
    [self.uploadImage removeAllObjects];
    
    self.uploadImage = nil;
    
    self.hud = nil;
}

- (BOOL)didRespond:(NSDictionary*)dict andHost:(UIViewController*)host
{
    NSLog(@"+___+%@",dict);
    
    [host hideHUD];
    
    if(!dict)
    {
        [host alert:kAttention message:@"Server error"];
        
        return NO;
    }
    if([dict responseForKindOfClass:@"code" andTarget:@"403"])
    {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishLogOut:)])
        {
            [self.delegate didFinishLogOut:@{@"reset":@"LTLogInViewController"}];
        }
        
        return NO;
    }
    
    if([dict responseForKindOfClass:@"code" andTarget:@"8"])
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFinishCloseShop:)])
        {
            [self.delegate didFinishCloseShop:@{}];
        }
    }
    
    if([dict responseForKindOfClass:@"code" andTarget:@"200"])
    {
        if([dict responseForKey:@"checkmark"] && host)
        {
            [self didAddCheckMark:dict andHost:host];
        }
        return YES;
    }
    
//    [host alert:kAttention message:[dict responseForKey:@"code"] ? XBText([Setting errorDescription:dict], @"request")  ? XBText([Setting errorDescription:dict], @"request") : @"Response Code not exsited" : XBText(@"Something went wrong, try again later", @"request")];
    
    return NO;
}

-(RequestCompletion)initRequest:(NSDictionary*)dict
{
    if([dict responseForKey:@"host"])
    {
        [dict[@"host"] showHUD:@""];
    }
    
    ASIFormDataRequest * request;
    
    if([dict responseForKey:@"method"])
    {
        NSString * url = [NSString stringWithFormat:@"%@?%@",dict[@"url"],[self returnGetUrl:dict]];
        
        request = service(url);
        
        [request setRequestMethod:dict[@"method"]];
    }
    else
    {
        request = service(dict[@"url"]);
        
        for(NSString * key in dict.allKeys)
        {
            if([key isEqualToString:@"host"] || [key isEqualToString:@"url"] || [key isEqualToString:@"completion"] || [key isEqualToString:@"method"])
            {
                continue;
            }
            [request setPostValue:dict[key] forKey:key];
        }
    }

    __block ASIFormDataRequest *_request = request;
    [_request setFailedBlock:^{
        
        if(![self isConnectionAvailable])
        {
            if([dict responseForKey:@"host"])
            {
                [self alert:kAttention message:@"Please check internet connection"];
                [(UIViewController*)dict[@"host"] hideHUD];
            }
            
            ((RequestCompletion)dict[@"completion"])(nil, request.error, NO);
        }
        else
        {
            ((RequestCompletion)dict[@"completion"])(nil, request.error, [self didRespond:[request.responseString objectFromJSONString] andHost:dict[@"host"]]);
        }
        
    }];
    
    [_request setCompletionBlock:^{
                
        NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:[request.responseString objectFromJSONString]];
        
        if([dict responseForKey:@"checkmark"])
        {
            [result addEntriesFromDictionary:@{@"checkmark":dict[@"checkmark"]}];
        }
        
        ((RequestCompletion)dict[@"completion"])(request.responseString, nil, [self didRespond:result andHost:dict[@"host"]]);
    }];
    
    [request startAsynchronous];
    
    return nil;
}

-(NSString*)returnGetUrl:(NSDictionary*)dict
{
    NSString * getUrl = @"" ;
    
    for(NSString * key in dict.allKeys)
    {
        if([key isEqualToString:@"host"] || [key isEqualToString:@"url"] || [key isEqualToString:@"completion"] || [key isEqualToString:@"method"])
        {
            continue;
        }
        getUrl = [NSString stringWithFormat:@"%@%@=%@&",getUrl,key,dict[key]];
    }

    return [getUrl substringToIndex:getUrl.length-(getUrl.length>0)];
}

-(void)didAddCheckMark:(NSDictionary*)dict andHost:(UIViewController*)host
{
    MBProgressHUD* done = [MBProgressHUD showHUDAddedTo:host.view animated:YES];
    
    done.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickP.png"]];
    
    done.mode = MBProgressHUDModeCustomView;
    
    done.labelText = dict[@"checkmark"];
    
    [done show:YES];
    
    [done hide:YES afterDelay:2];
}

-(BOOL)isConnectionAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        return NO;
    }
    else if (status == ReachableViaWiFi)
    {
        return YES;
    }
    else if (status == ReachableViaWWAN)
    {
        return YES;
    }
    return YES;
}

@end
