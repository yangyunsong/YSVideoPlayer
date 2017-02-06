//
//  NSString+Tools.m
//  videopleyer
//
//  Created by yangyunsong on 17/1/12.
//  Copyright © 2017年 yangyunsong. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
-(NSString *)deleStringLastChar{
    
    NSMutableString *strM = [NSMutableString stringWithString:self];
    for (NSInteger i = 0; i < self.length ; i++) {
        
        if ([self characterAtIndex:i] == 'G') {
            [strM deleteCharactersInRange:NSMakeRange(i, self.length-i)];
            break;
        }
        
    }
    return strM;
}


@end
