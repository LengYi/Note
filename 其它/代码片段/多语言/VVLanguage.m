//
//  VVLanguage.m
//  VVLife
//
//  Created by ice on 2019/3/7.
//  Copyright © 2019 vv. All rights reserved.
//

#import "VVLanguage.h"

NSString * kLanguageResourceFileName = @"LanguageResourceFileName";    // 当前使用的多语言资源文件

@implementation VVLanguage
+ (NSString *)string:(NSString *)key {
    return [VVLanguage string:key comment:@""];
}

+ (NSString *)string:(NSString *)key comment:(NSString *)comment {
    NSString *path = [[NSBundle mainBundle] pathForResource:[VVLanguage currentLanguageFile] ofType:@"lproj"];
    NSBundle *resourceBundle = [[NSBundle alloc] initWithPath:path];
    return [resourceBundle localizedStringForKey:key value:@"" table:nil];
}

#pragma mark - Private Methods
+ (NSString *)currentLanguageFile {
    NSString *fileName = [[NSUserDefaults standardUserDefaults] stringForKey: kLanguageResourceFileName];
    if (fileName) {
        return fileName;
    }
    
    fileName = [VVLanguage configLanguageResourceFileName];
    [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:kLanguageResourceFileName];
    return fileName;
}

+ (NSString *)configLanguageResourceFileName {
    NSString *systemLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if (!systemLanguage || systemLanguage.length <= 0) return @"en";
    
    NSArray *enArr = @[@"en-US", @"en-CN"];
    NSArray *cnArr = @[@"zh-Hans-US", @"zh-Hans-CN", @"zh-Hant-CN", @"zh-TW", @"zh-HK", @"zh-Hans"];
    
    if ([enArr containsObject:systemLanguage]) {
        return @"en";
    } else if ([cnArr containsObject:systemLanguage]) {
        return @"zh-Hans";
    } else {
        return @"en";
    }
}

@end
