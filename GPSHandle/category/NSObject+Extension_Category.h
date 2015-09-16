//
//  NSObject+Extension_Category.h
//  GPSHandle
//
//  Created by thanhhaitran on 9/15/15.
//  Copyright (c) 2015 lingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <UIKit/UIKit.h>

@interface NSObject (Extension_Category) <CLLocationManagerDelegate>

- (void)addValue:(NSString*)value andKey:(NSString*)key;
- (NSString*)getValue:(NSString*)key;
- (void)removeValue:(NSString*)key;
- (void)alert:(NSString *)title message:(NSString *)message;
- (MBProgressHUD *)showHUD:(NSString *)string;
- (void)hideHUD;
- (void)initLocation;
- (NSDictionary *)currentLocation;
@end

@interface NSDictionary (name)
- (NSMutableDictionary*)reFormat;
- (BOOL)responseForKey:(NSString *)name;
- (NSString*)responseForKind:(NSString*)name;
- (NSString*)getValueFromKey:(NSString *)name;
- (NSString*)responseForKind:(NSString*)name andOption:(NSString*)placeHolder;
- (NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
- (BOOL)responseForKindOfClass:(NSString *)name andTarget:(NSString*)target;
- (NSDictionary*)dictionaryWithPlist:(NSString*)pList;
@end

@interface NSNotificationCenter (UniqueNotif)
- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;
@end

@interface UILabel (UILabelDynamicHeight)
- (CGSize)sizeOfMultiLineLabel;
- (void)withAttribute:(NSString*)html withStrike:(BOOL)strike;
@end

@interface NSMutableArray (utility)
- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end

@interface NSArray (OrderedDuplicateElimination)
- (NSArray *)arrayByEliminatingDuplicatesMaintainingOrder;
- (NSMutableArray*)arrayByMergeAndDeduplication:(NSArray*)total;
- (NSString *)bv_jsonStringWithPrettyPrint:(BOOL)prettyPrint;
- (NSArray*)arrayWithPlist:(NSString*)name;
- (NSArray*)arrayWithMutable;
@end

@interface UIView (Border)

- (UIView *)withBorder:(NSDictionary *)dict;
- (UIView*)withShadow;
- (UIView*)withShadow:(UIColor*)hext;
- (void)setHeight:(CGFloat)height animated:(BOOL)animate;
- (void)bounce:(float)bounceFactor;
@end

@interface UIImage (Scale)

- (UIImage *)imageScaledToQuarter;
- (UIImage *)imageScaledToHalf;
- (UIImage *)imageScaledToScale:(CGFloat)scale;
- (UIImage *)imageScaledToScale:(CGFloat)scale
       withInterpolationQuality:(CGInterpolationQuality)quality;
- (UIImage*) imageWithBrightness:(CGFloat)brightnessFactor;
@end

@interface NSString (Contains)

- (BOOL)myContainsString:(NSString*)other;
- (NSString*)specialDateFromTimeStamp;
- (NSString*)specialDateAndTimeFromTimeStamp;
- (NSString*)dateFromTimeStamp;
- (NSString*)dateAndTimeFromTimeStamp;
- (NSString*)dateFromTimeStamp:(NSString*)format;
- (NSString*)normalizeDateTime:(int)position;

@end

@interface NSMutableDictionary (Additions)
- (void)removeObjectForKeyPath: (NSString *)keyPath;
@end

@interface UITableView (extras)
- (void)reloadDataWithAnimation:(BOOL)animate;
@end

@interface NSDate (extension)

- (NSString *)stringWithFormat:(NSString *)format;
- (BOOL)isPastTime:(NSString*)theDate;
@end

