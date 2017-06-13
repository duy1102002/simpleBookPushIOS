//
//  singleton.h
//  bookPublish
//
//  Created by duyong on 2017/6/12.
//  Copyright © 2017年 duyong. All rights reserved.
//

#ifndef singleton_h
#define singleton_h


#import <Foundation/Foundation.h>


@interface Singleton : NSObject {
}

//   服务器配置地址
@property(nonatomic, strong) NSString * serverIpAddr;

+(Singleton *)sharedInstanceMethod;

@end
#endif /* singleton_h */
