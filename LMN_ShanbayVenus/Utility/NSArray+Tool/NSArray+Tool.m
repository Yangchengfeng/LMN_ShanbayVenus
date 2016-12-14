//
//  NSArray+Tool.m
//  ReadTxt
//
//  Created by 阳丞枫 on 16/12/12.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "NSArray+Tool.h"

@implementation NSArray (Tool)

- (NSString *)descriptionWithLocale:(id)locale

{
    
    NSMutableString *string=[[NSMutableString alloc]init];
    
    for (id obj in self) {
        
        [string appendFormat:@"\n\t%@",obj];
        
    }
    
    return string;
    
}



@end
