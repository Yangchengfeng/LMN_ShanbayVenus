//
//  HighLightLabel.h
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/15.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HighLightLabel;

@protocol HighLightLabelDelegate <NSObject>

- (void)label:(HighLightLabel *)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (void)label:(HighLightLabel *)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (void)label:(HighLightLabel *)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
- (void)label:(HighLightLabel *)label didCancelTouch:(UITouch*)touch;

@end

@interface HighLightLabel : UILabel

@property(nonatomic, weak) id <HighLightLabelDelegate> delegate;

- (CFIndex)characterIndexAtPoint:(CGPoint)point;

@end
