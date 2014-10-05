//
//  HabitFormerAppDelegate.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 6/3/14.
//  Copyright (c) 2014 Charlie Moorhead. All rights reserved.
//

#import "HabitFormerAppDelegate.h"
#import "MainViewController.h"

@implementation HabitFormerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    /*
    MainViewController *viewController = [[MainViewController alloc] init];
    self.window.rootViewController = viewController;
    */
    
    //testing navigation controller
    MainViewController *viewController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [nav setDelegate:viewController];
    viewController.title = @"Habits";
    
    self.window.rootViewController = nav;
    //end testing nav
    
    [self.window makeKeyAndVisible];
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
    [self saveDataToDisk];
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
    [self saveDataToDisk];
}

- (NSString *)pathForDataFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"HabitFormer.HabitStore"];
    
    return file;
}


-(void)saveDataToDisk
{
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    MainViewController *viewController = (MainViewController*)navigationController.topViewController;
    
    NSString *folder = [self pathForDataFile];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    if (viewController.habits != nil)
    {
        [data setObject:viewController.habits forKey:@"habits"];
    }
    if (viewController.resetTime != nil)
    {
        [data setObject:viewController.resetTime forKey:@"resetTime"];
    }
    
    if ([NSKeyedArchiver archiveRootObject:data toFile:folder]) {
        //viewController.label.text = @"saved";
    }
    else
    {
        //viewController.label.text = [folder substringFromIndex:110];
    }
}


@end
