//
//  NumberOfArticle.m
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/11.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "NumberOfArticle.h"

@implementation NumberOfArticle

- (instancetype)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

+ (NumberOfArticle *)shareNumberOfArticle {
    static NumberOfArticle *shareNumberOfArticle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNumberOfArticle = [[self alloc] init];
    });
    return shareNumberOfArticle;
}

@end
