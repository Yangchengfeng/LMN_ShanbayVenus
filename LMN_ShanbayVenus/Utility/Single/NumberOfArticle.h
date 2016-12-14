//
//  NumberOfArticle.h
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/11.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberOfArticle : NSObject

@property (nonatomic, assign) NSInteger numberOfUnit;
@property (nonatomic, assign) NSInteger numberOfArticle;
@property (nonatomic, strong) NSMutableArray *topicOfArticle;
@property (nonatomic, assign) NSInteger textLabelHeight;

+ (NumberOfArticle *)shareNumberOfArticle;

@end
