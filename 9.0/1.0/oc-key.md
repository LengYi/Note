# OC 缓存Key处理方案
###场景：

+ Url带中文
+ 无参数纯Url
+ 带参数Url

###方案：

+ Url Encode
+ AFNetWork参数转query方法

~~~
+ (NSString *)cacheKey:(NSString *)key
            parameters:(nullable NSDictionary *)dict {
    if (key == nil) {
        return @"";
    }
    
    NSString *query = @"";
    if (dict != nil) {
        query = AFQueryStringFromParameters(dict);
    }
    
    NSURL *url = [NSURL URLWithString:[key encodeUrlString]];
    NSURL *newUrl = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:url.query ? @"&%@" : @"?%@", query]];
    
    return newUrl.absoluteString;
}

- (NSString *)encodeUrlString {
    NSString *encodeString = @"";
    if (self) {
        CFStringRef originalString = (__bridge CFStringRef)self;
        CFStringRef charactersToLeaveUnescaped = NULL;
        CFStringRef legalURLCharactersToBeEscaped = (CFStringRef)@"!*'();@&=+$,#[]";
        CFStringEncoding encoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        
        CFStringRef createString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, originalString, charactersToLeaveUnescaped, legalURLCharactersToBeEscaped, encoding);
        
        NSString *newString = (__bridge NSString *)createString;
        
        if (newString) {
            encodeString = [[NSString alloc] initWithString: newString];
            CFRelease(createString);
        }
    }
    
    return encodeString;
}

~~~

###测试用例：

~~~
+ (void)cache {
    NSString *string1 = [VVUniteCacheManager cacheKey:@"http://www.baidu.com" parameters:@{@"key1":@"value1",@"key2":@"value2"}];
    NSString *string2 = [VVUniteCacheManager cacheKey:@"http://www.baidu.com2?name=china" parameters:@{@"key1":@"value1",@"key2":@"value2"}];
    NSString *string3 = [VVUniteCacheManager cacheKey:@"http://www.baidu.com2?name=中国&num=100" parameters:nil];
    
    NSLog(@"\n %@ \n %@ \n %@ \n",string1,string2,string3);
}
~~~

###测试结果：

~~~
 http://www.baidu.com?key1=value1&key2=value2 
 http://www.baidu.com2?name%3Dchina&key1=value1&key2=value2 
 http://www.baidu.com2?name%3D%E4%B8%AD%E5%9B%BD%26num%3D100&
~~~