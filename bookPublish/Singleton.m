//
//  singleton.cpp
//  bookPublish
//
//  Created by duyong on 2017/6/12.
//  Copyright © 2017年 duyong. All rights reserved.
//

#include "Singleton.h"

static Singleton * sharedInstance = nil;

@implementation Singleton

//获取单例
+(Singleton *)sharedInstanceMethod
{
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

//唯一一次alloc单例，之后均返回nil
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
#if 0
//retain返回单例本身
- (id)retain
{
    return self;
}

//引用计数总是为1
- (unsigned)retainCount
{
    return 1;
}

//release不做任何处理
- (void)release
{
    
}

//autorelease返回单例本身
- (id)autorelease
{
    return self;
}

//
-(void)dealloc
{
    [super dealloc];
}
#endif
@end
