//
//  VVLanguage.h
//  VVLife
//
//  Created by ice on 2019/3/7.
//  Copyright © 2019 vv. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VVLanguage : NSObject

+ (NSString *)string:(NSString *)key;

+ (NSString *)string:(NSString *)key comment:(NSString *)comment;

@end

NS_ASSUME_NONNULL_END
