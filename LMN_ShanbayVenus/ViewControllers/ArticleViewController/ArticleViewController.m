//
//  ArticleViewController.m
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/13.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "ArticleViewController.h"
#import "NumberOfArticle.h"
#import "ViewController.h"
#import "HighLightLabel.h"

@interface ArticleViewController () <UIScrollViewDelegate, HighLightLabelDelegate>

@property (nonatomic, strong) HighLightLabel *contentLabel;
@property (nonatomic) NSRange highlightedRange;
@property (nonatomic, strong) UIScrollView *scView;
@property (nonatomic, strong) NSMutableDictionary *words;
@property (nonatomic, strong) NSMutableArray *word;

@end

@implementation ArticleViewController

- (void)setContent:(NSString *)content {
    _content = content;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UISwitch *highlightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [highlightSwitch setOn:NO];
    [highlightSwitch addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:highlightSwitch];
    
    CGRect appRect = [UIScreen mainScreen].bounds;
    
    _contentLabel = [[HighLightLabel alloc] initWithFrame:CGRectMake(10, 0, appRect.size.width - 20, _contentHeight)];
    _contentLabel.delegate = self;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.text = self.content;
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    _contentLabel.userInteractionEnabled = YES;
    
    _scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, appRect.size.width, appRect.size.height)];
    _scView.delegate = self;
    _scView.scrollEnabled = YES;
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.showsVerticalScrollIndicator = NO;
    _scView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_scView];
    
    [_scView addSubview:_contentLabel];
    
    // 开启异步线程加载(待添加)
    [self saveWords];
}

- (void)changeSwitchState:(UISwitch *)sender {
    
    if(sender.isOn) {
        NSString *string = _contentLabel.text;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
        
        NSInteger numOfWords = _words.count;
        
        for(int i = 0; i<numOfWords; i++) {
            NSString *stringForColor = _word[i];
            
            NSMutableString * mutableString = [NSMutableString string];
            
            [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByWords usingBlock:
             ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
             {
                 [mutableString appendFormat:@"%@", substring];
                 if([substring isEqualToString:stringForColor]) {
                     //颜色 设置
                     
                     if([UIColor redColor] == nil) {
                         return;
                     } else {
                         [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:enclosingRange];
                     }
                  }
             }];
             _contentLabel.attributedText = str;
        }
        
       
        
    } else {
        _contentLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)saveWords {
    
    _words = [NSMutableDictionary dictionary];
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"nce4_words" ofType:nil];
    NSString *str=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    
    _word = [NSMutableArray array];
    
    for(int i = 1; i<arr.count-1; i++) {
        NSString *str1 = arr[i];
        NSArray *arr1 = [str1 componentsSeparatedByString:@"\t"];
        [_word addObject:arr1[0]];
        
        [_words setObject:arr1[1] forKey:arr1[0]];
    }
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect appRect = [UIScreen mainScreen].bounds;
    [super viewDidAppear:animated];
     _scView.contentSize = CGSizeMake(appRect.size.width, _contentHeight);
}

#pragma mark --

- (void)label:(HighLightLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightWordContainingCharacterAtIndex:charIndex];
}

- (void)label:(HighLightLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightWordContainingCharacterAtIndex:charIndex];
}

- (void)label:(HighLightLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self removeHighlight];
}

- (void)label:(HighLightLabel *)label didCancelTouch:(UITouch *)touch {
    
    [self removeHighlight];
}

#pragma mark --

- (void)highlightWordContainingCharacterAtIndex:(CFIndex)charIndex {
    
    if (charIndex==NSNotFound) {
        
        //user did nat click on any word
        [self removeHighlight];
        return;
    }
    
    NSString* string = self.contentLabel.text;
    
    //compute the positions of space characters next to the charIndex
    NSRange end = [string rangeOfString:@" " options:0 range:NSMakeRange(charIndex, string.length - charIndex)];
    NSRange front = [string rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0; //first word was selected
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length-1; //last word was selected
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location-front.location);
    
    if (front.location!=0) { //fix trimming
        wordRange.location += 1;
        wordRange.length -= 1;
    }
    
    if (wordRange.location == self.highlightedRange.location) {
        return; //this word is already highlighted
    }
    else {
        [self removeHighlight]; //remove highlight on previously selected word
    }
    
    self.highlightedRange = wordRange;
    
    //highlight selected word
    NSMutableAttributedString* attributedString = [self.contentLabel.attributedText mutableCopy];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:wordRange];
    self.contentLabel.attributedText = attributedString;
}

- (void)removeHighlight {
    
    if (self.highlightedRange.location != NSNotFound) {
        
        //remove highlight from previously selected word
        NSMutableAttributedString* attributedString = [self.contentLabel.attributedText mutableCopy];
        [attributedString removeAttribute:NSBackgroundColorAttributeName range:self.highlightedRange];
        self.contentLabel.attributedText = attributedString;
        
        self.highlightedRange = NSMakeRange(NSNotFound, 0);
    }
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
