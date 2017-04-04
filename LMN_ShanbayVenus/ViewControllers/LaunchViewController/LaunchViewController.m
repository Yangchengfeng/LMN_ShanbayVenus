//
//  LaunchViewController.m
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/11.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "LaunchViewController.h"
#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "UINavigationController+FDFullscreenPopGesture.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LaunchViewController ()

@property (nonatomic, strong) UIImageView *launchView;
@property (nonatomic, strong) UIView *displayView;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawLaunchView];
}

- (void)drawLaunchView {
    
    _launchView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_launchView setImage:[UIImage imageNamed:@"LaunchImage"]];
    [self.view addSubview:_launchView];
    
    _displayView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/3.0*2.0 - 30, kScreenWidth, kScreenHeight/3.0-30)];
    [self.view addSubview:_displayView];
    [self drawCharater];
}

- (void)drawCharater {
    [self.displayView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
   
    UIBezierPath *bezierPath = [self transformToBezierPath:@"ShanbayVenus"];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGPathGetBoundingBox(bezierPath.CGPath);
    layer.position = CGPointMake(self.view.bounds.size.width/2, 50);
    layer.geometryFlipped = YES;
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = layer.bounds.size.width/35;
    [layer addAnimation:animation forKey:nil];
    [self.displayView.layer addSublayer:layer];
    
    
    UIImage *penImage = [UIImage imageNamed:@"pencil.png"];
    CALayer *penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
    [layer addSublayer:penLayer];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = animation.duration;
    penAnimation.path = layer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.removedOnCompletion = NO;
    penAnimation.fillMode = kCAFillModeForwards;
    [penLayer addAnimation:penAnimation forKey:@"position"];
    
    [penLayer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:penAnimation.duration];
    [self performSelector:@selector(pushToViewController) withObject:nil afterDelay:penAnimation.duration+1.0];
    
}

- (void)pushToViewController {
    UINavigationController *homePageNaviVC = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.view.window.rootViewController = homePageNaviVC;
}

- (UIBezierPath *)transformToBezierPath:(NSString *)string {
    CGMutablePathRef paths = CGPathCreateMutable();
    CFStringRef fontNameRef = CFSTR("SnellRoundhand");
    CTFontRef fontRef = CTFontCreateWithName(fontNameRef, 44, nil);
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{(__bridge NSString *)kCTFontAttributeName: (__bridge UIFont *)fontRef}];
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArrRef = CTLineGetGlyphRuns(lineRef);
    
    for (int runIndex = 0; runIndex < CFArrayGetCount(runArrRef); runIndex++) {
        const void *run = CFArrayGetValueAtIndex(runArrRef, runIndex);
        CTRunRef runb = (CTRunRef)run;
        
        const void *CTFontName = kCTFontAttributeName;
        
        const void *runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb), CTFontName);
        CTFontRef runFontS = (CTFontRef)runFontC;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        int temp = 0;
        CGFloat offset = .0;
        
        for (int i = 0; i < CTRunGetGlyphCount(runb); i++) {
            CFRange range = CFRangeMake(i, 1);
            CGGlyph glyph = 0;
            CTRunGetGlyphs(runb, range, &glyph);
            CGPoint position = CGPointZero;
            CTRunGetPositions(runb, range, &position);
            
            CGFloat temp3 = position.x;
            int temp2 = (int)temp3/width;
            CGFloat temp1 = 0;
            
            if (temp2 > temp1) {
                temp = temp2;
                offset = position.x - (CGFloat)temp;
            }
            
            CGPathRef path = CTFontCreatePathForGlyph(runFontS, glyph, nil);
            CGFloat x = position.x - (CGFloat)temp*width - offset;
            CGFloat y = position.y - (CGFloat)temp * 80;
            CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
            CGPathAddPath(paths, &transform, path);
            
            CGPathRelease(path);
        }
        CFRelease(runb);
        CFRelease(runFontS);
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
    
    CGPathRelease(paths);
    CFRelease(fontNameRef);
    CFRelease(fontRef);
    
    return bezierPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
