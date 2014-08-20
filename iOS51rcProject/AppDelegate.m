//
//  AppDelegate.m
//  iOS51rcProject
//
//  Created by Lucifer on 14-8-13.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //将字典存入到document内
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"dictionary.db"];
    NSFileManager *file = [NSFileManager defaultManager];
    if ([file fileExistsAtPath:dbPath]) {
        
    }
    else {
        NSString *originDbPath = [[NSBundle mainBundle] pathForResource:@"dictionary.db" ofType:nil];
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:originDbPath];
        [file createFileAtPath:dbPath contents:mainBundleFile attributes:nil];
    }
    
    //判断当前设备屏幕尺寸
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    UIStoryboard *mainStoryboard = nil;
    if (iOSDeviceScreenSize.height == 568) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    }
    else{
        mainStoryboard = self.window.rootViewController.storyboard;
    }
    
    MenuViewController *menuC = (MenuViewController*)[mainStoryboard
                                                      instantiateViewControllerWithIdentifier: @"MenuViewController"];
	
	[SlideNavigationController sharedInstance].rightMenu = menuC;
	[SlideNavigationController sharedInstance].leftMenu = menuC;

    //设置欢迎界面
    [NSThread sleepForTimeInterval:1.0];
    //获得是否是第一次登录
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger logCount = [userDefaults integerForKey:@"loginCount"];
    if (logCount == 0) {
        //NSLog(@"the first login");
        //如果是第一次登录，则显示四个欢迎图片
        self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        WelcomeViewController * startView = [[WelcomeViewController alloc]init];
        self.window.rootViewController = startView;
        [startView release];
    }
    else{
        //NSLog(@"not the first login");
    }
    [self.window makeKeyAndVisible];
    logCount ++;
    [userDefaults setInteger:logCount forKey:@"loginCount"];
    [userDefaults synchronize];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
