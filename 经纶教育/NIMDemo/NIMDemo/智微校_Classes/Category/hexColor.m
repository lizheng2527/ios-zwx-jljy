//
//  hexColor.m
//  NIM
//
//  Created by 中电和讯 on 2019/4/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "hexColor.h"

@implementation hexColor


+ (UIColor *) colorWithHex:(NSString *)hex {
    
    NSString *string = [NSString stringWithFormat:@"0x00%@",hex];

    
    unsigned long hexColorNum = strtoul([string UTF8String],0,16);
    float r = (hexColorNum & 0xff000000) >> 24;
    float g = (hexColorNum & 0x00ff0000) >> 16;
    float b = (hexColorNum & 0x0000ff00) >> 8;
    float a = (hexColorNum & 0x000000ff);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}


@end
