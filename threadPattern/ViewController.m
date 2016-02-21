//
//  ViewController.m
//  threadPattern
//
//  Created by ishikura keisuke on 2016/02/05.
//  Copyright © 2016年 ishikura keisuke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSString *str;
dispatch_queue_t synchronizedThread;
dispatch_queue_t synchronizedThread2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnMainThreadAsync:(id)sender {
    [self goMainThreadAsync];
}
- (IBAction)btnMainThreadSync:(id)sender {
    [self goMainThreadSync];
}
- (IBAction)btnPrivateThreadAsync:(id)sender {
    [self goPrivateThreadAsync];
}
- (IBAction)btnPrivateThreadSync:(id)sender {
    [self goPrivateThreadSync];
}
- (IBAction)btnGlobalThreadAsync:(id)sender {
    [self goGlobalThreadAsync];
}
- (IBAction)btnGlobalThreadSync:(id)sender {
    [self goGlobalThreadSync];
}
- (IBAction)btnPrivateMainThreadAsync:(id)sender {
    [self goPrivateMainThreadAsync];
}
- (IBAction)btnPrivateMainThreadSync:(id)sender {
    [self goPrivateMainThreadSync];
}
- (IBAction)btnPrivatePrivateThreadAsync:(id)sender {
    [self goPrivatePrivateThreadAsync];
}
- (IBAction)btnPrivatePrivateThreadSync:(id)sender {
    [self goPrivatePrivateThreadSync];
}
- (IBAction)btnPrivateGlobalThreadAsync:(id)sender {
    [self goPrivateGlobalThreadAsync];
}
- (IBAction)btnPrivateGlobalThreadSync:(id)sender {
    [self goPrivateGlobalThreadSync];
}
- (IBAction)btnGlobalMainThreadAsync:(id)sender {
    [self goGlobalMainThreadAsync];
}
- (IBAction)btnGlobalMainThreadSync:(id)sender {
    [self goGlobalMainThreadSync];
}
- (IBAction)btnGlobalOriginalThreadAsync:(id)sender {
    [self goGlobalOriginalThreadAsync];
}
- (IBAction)btnGlobalOriginalThreadSync:(id)sender {
    [self goGlobalOriginalThreadSync];
}
- (IBAction)btnGlobalGlobalThreadAsync:(id)sender {
    [self goGlobalGlobalThreadAsync];
}
- (IBAction)btnGlobalGlobalThreadSync:(id)sender {
    [self goGlobalGlobalThreadSync];
}

/*
 1.メインスキューにタスクを非同期でディスパッチする
 */
-(void)goMainThreadAsync {
    NSLog(@"1:goMainThreadAsync");
    dispatch_queue_t mainQuere = dispatch_get_main_queue();
    dispatch_queue_t mainQuere2 = dispatch_get_main_queue();
    dispatch_async(mainQuere, ^{
        dispatch_async(mainQuere2, ^{
            NSLog(@"pass3");
        });
        uint s = 2;sleep(s);
        NSLog(@"pass2");
    });
    uint t = 4;sleep(t);
    NSLog(@"pass1");
}

/*
 2.メインスキューにタスクを同期でディスパッチする
 */
-(void)goMainThreadSync {
    NSLog(@"2:goMainThreadSync");
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        NSLog(@"pass2");
    });
    NSLog(@"pass1");
}

/*
 3.プライベートキューにタスクを非同期でディスパッチする
 */
-(void)goPrivateThreadAsync {
    NSLog(@"3:goPrivateThreadAsync");
    dispatch_queue_t privateQueue = dispatch_queue_create("private",nil);
    dispatch_async(privateQueue, ^{
        NSLog(@"pass2");
    });
    uint t = 4;sleep(t);
    NSLog(@"pass1");
}

/*
 4.プライベートキューにタスクを同期でディスパッチする
 */
-(void)goPrivateThreadSync {
    NSLog(@"4:goPrivateThreadSync");
    dispatch_queue_t privateQueue = dispatch_queue_create("private",nil);
    dispatch_sync(privateQueue, ^{
        uint t = 4;sleep(t);
        NSLog(@"pass2");
    });
    NSLog(@"pass1");
}

/*
 5.グローバルキューにタスクを非同期でディスパッチする
 */
-(void)goGlobalThreadAsync {
    NSLog(@"5:goGlobalThreadAsync");
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalQueue, ^{
        uint t = 4;sleep(t);
        NSLog(@"pass2");
    });
    NSLog(@"pass1");
}

/*
 6.グローバルキューにタスクを同期でディスパッチする
 */
-(void)goGlobalThreadSync {
    NSLog(@"6:goGlobalThreadSync");
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_sync(globalQueue, ^{
        uint t = 4;sleep(t);
        NSLog(@"pass2");
    });
    NSLog(@"pass1");
}

/*
 7.プライベートキューからメインキューに非同期でディスパッチする
 */
-(void)goPrivateMainThreadAsync {
    NSLog(@"7:goPrivateMainThreadAsync");
    dispatch_queue_t privateQueue = dispatch_queue_create("private",nil);
    dispatch_async(privateQueue, ^{
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 8.プライベートキューからメインキューに同期でディスパッチする
 */
-(void)goPrivateMainThreadSync {
    NSLog(@"8:goPrivateMainThreadSync");
    dispatch_queue_t privateQueue = dispatch_queue_create("private",nil);
    dispatch_async(privateQueue, ^{
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 9.プライベートキューからプライベートキューに非同期でディスパッチする
 */
-(void)goPrivatePrivateThreadAsync {
    NSLog(@"9:goPrivatePrivateThreadAsync");
    dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
    dispatch_async(privateThread, ^{
        dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
        dispatch_async(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 10.プライベートキューからプライベートキューに同期でディスパッチする
 */
-(void)goPrivatePrivateThreadSync {
    NSLog(@"10:goPrivatePrivateThreadSync");
    dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
    dispatch_async(privateThread, ^{
        dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
        dispatch_sync(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 11.プライベートキューからグローバルキューに非同期でディスパッチする
 */
-(void)goPrivateGlobalThreadAsync {
    NSLog(@"11:goPrivateGlobalThreadAsync");
    dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
    dispatch_async(privateThread, ^{
        dispatch_queue_t privateThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 12.プライベートキューからグローバルキューに同期でディスパッチする
 */
-(void)goPrivateGlobalThreadSync {
    NSLog(@"12:goPrivateGlobalThreadSync");
    dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
    dispatch_async(privateThread, ^{
        dispatch_queue_t privateThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_sync(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 13.グローバルキューからメインキューに非同期でディスパッチする
 */
-(void)goGlobalMainThreadAsync {
    NSLog(@"13:goGlobalMainThreadAsync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_async(mainThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 14.グローバルからメインキューに同期でディスパッチする
 */
-(void)goGlobalMainThreadSync {
    NSLog(@"14:goGlobalMainThreadSync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_sync(mainThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 15.グローバルキューからプライベートキューに非同期でディスパッチする
 */
-(void)goGlobalOriginalThreadAsync {
    NSLog(@"15:goGlobalOriginalThreadAsync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
        dispatch_async(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 16.グローバルキューからプライベートキューに同期でディスパッチする
 */
-(void)goGlobalOriginalThreadSync {
    NSLog(@"16:goGlobalOriginalThreadSync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t privateThread = dispatch_queue_create("private",nil);
        dispatch_sync(privateThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 17.グローバルキューからグローバルキューに非同期でディスパッチする
 */
-(void)goGlobalGlobalThreadAsync {
    NSLog(@"17:goGlobalGlobalThreadAsync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(globalThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}

/*
 18.グローバルキューからグローバルキューに同期でディスパッチする
 */
-(void)goGlobalGlobalThreadSync {
    NSLog(@"18:goGlobalGlobalThreadSync");
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_sync(globalThread, ^{
            uint t = 4;sleep(t);
            NSLog(@"pass2");
        });
        NSLog(@"pass1");
    });
}


@end
