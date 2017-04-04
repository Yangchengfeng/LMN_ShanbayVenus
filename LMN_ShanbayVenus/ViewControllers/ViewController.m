//
//  ViewController.m
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/10.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "ViewController.h"
#import "NumberOfArticle.h"
#import "ArticleViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor greenColor]];
    _mainView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    [self.view addSubview:_mainView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [NumberOfArticle shareNumberOfArticle].numberOfArticle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = [NSString stringWithFormat:@"Lesson %ld  %@", (long)indexPath.row+1, [NumberOfArticle shareNumberOfArticle].topicOfArticle[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showArticleWithLineNumber:indexPath.row];
}

- (void)showArticleWithLineNumber:(NSInteger)lineNumber {
    
    NSMutableArray *text = [NSMutableArray array];
    NSMutableArray *articles = [NSMutableArray array];
    
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"新概念英语第4册" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    NSUInteger lineCount = arr.count;
    for(int i = 0; i<lineCount; i++) {
        NSString *lineContent = arr[i];
        if([lineContent rangeOfString:@"Unit"].location == NSNotFound) {
            if([lineContent rangeOfString:@"Lesson"].location == NSNotFound) {
                
                [text addObject:lineContent];
                
                if(i == lineCount-1) { // 文件结束
                    
                    NSString *article = [NSString stringWithFormat:@"%@", text];
                    [articles addObject:article];
                }
                
                
            } else {
                if(text.count != 0) {
                
                    NSString *article = [NSString stringWithFormat:@"%@", text];
                    [articles addObject:article];
                    
                    // 清空
                    [text removeAllObjects];
                }
            }
        }
        
        
        
    }
    
    NSString *content = [articles objectAtIndex:lineNumber];
    
    CGRect appRect = [UIScreen mainScreen].bounds;
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.text = content;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 0;
    CGRect textFrame = _contentLabel.frame;
    CGSize size = CGSizeMake(appRect.size.width - 20, 2 * appRect.size.height);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_contentLabel.font, NSFontAttributeName, nil];
    textFrame.size.height = [_contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    
    ArticleViewController *vc = [[ArticleViewController alloc] init];
    vc.content = [articles objectAtIndex:lineNumber];
    vc.contentHeight = ceil(textFrame.size.height);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
