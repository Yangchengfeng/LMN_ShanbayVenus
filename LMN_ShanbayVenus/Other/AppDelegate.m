//
//  AppDelegate.m
//  LMN_ShanbayVenus
//
//  Created by 阳丞枫 on 16/12/10.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "NumberOfArticle.h"

static NSInteger numberOfArticle = 0;
static NSInteger numberOfUnit = 0;

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *topicArr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]; // 删除了main.storyboard,所以需要初始化
    
    LaunchViewController *vc = [[LaunchViewController alloc] init]; // 启动页
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
    });
    
    return YES;
}

- (void)getData {
    _topicArr = [NSMutableArray array];
    // 加载数据
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"新概念英语第4册"ofType:@"txt"];
        NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];// 将文件读取到内存
        NSArray *arr = [str componentsSeparatedByString:@"\n"];
        NSUInteger lineCount = arr.count;
        
        int topicLine = 0;
        for(int i = 0; i<lineCount; i++) {
            NSString *lineContent = arr[i];
            if([lineContent rangeOfString:@"Unit"].location != NSNotFound) {
                numberOfUnit++;
            }
            if([lineContent rangeOfString:@"Lesson"].location != NSNotFound) {
                numberOfArticle++;
                topicLine = i+1;
                NSString *str = arr[topicLine];
                NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet]; // 去除空格
                [_topicArr addObject:[str stringByTrimmingCharactersInSet:whitespaces]];
            }
        }
        [[NumberOfArticle shareNumberOfArticle] setNumberOfUnit:numberOfUnit];
        [[NumberOfArticle shareNumberOfArticle] setNumberOfArticle:numberOfArticle];
        [[NumberOfArticle shareNumberOfArticle] setTopicOfArticle:_topicArr];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
