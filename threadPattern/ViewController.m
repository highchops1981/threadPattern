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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mainThreadAsyngButton:(id)sender {
    [self goMainThreadAsync];
}
- (IBAction)mainThreadSyncButton:(id)sender {
    [self goMainThreadSync];
}
- (IBAction)otasync:(id)sender {
    [self goOriginalThreadAsync];
}
- (IBAction)otsync:(id)sender {
    [self goOriginalThreadSync];
}
- (IBAction)gtasync:(id)sender {
    [self goGlobalThreadAsync];
}
- (IBAction)gtsync:(id)sender {
    [self goGlobalThreadSync];
}
- (IBAction)omtasync:(id)sender {
    [self goOriginalMainThreadAsync];
}
- (IBAction)omtaync:(id)sender {
    [self goOriginalMainThreadSync];
}
- (IBAction)ootasync:(id)sender {
    [self goOriginalOriginalThreadAsync];
}
- (IBAction)ootsync:(id)sender {
    [self goOriginalOriginalThreadSync];
}
- (IBAction)ogtasync:(id)sender {
    [self goOriginalGlobalThreadAsync];
}
- (IBAction)ogtsync:(id)sender {
    [self goOriginalGlobalThreadSync];
}
- (IBAction)gmtasync:(id)sender {
    [self goGlobalMainThreadAsync];
}
- (IBAction)gmtaync:(id)sender {
    [self goGlobalMainThreadSync];
}
- (IBAction)gotasync:(id)sender {
    [self goGlobalOriginalThreadAsync];
}
- (IBAction)gotsync:(id)sender {
    [self goGlobalOriginalThreadSync];
}
- (IBAction)ggtasync:(id)sender {
    [self goGlobalGlobalThreadAsync];
}
- (IBAction)ggtsync:(id)sender {
    [self goGlobalGlobalThreadSync];
}

/*
 #1 main thread
  #1 main thread
   #5 dispatch_async
   #6 dispatch_sync
  #2 original thread
   #5 dispatch_async
   #6 dispatch_sync
  #3 global thread
   #5 dispatch_async
   #6 dispatch_sync
 #2 original thread
  #1 main thread
   #5 dispatch_async
   #6 dispatch_sync
  #2 original thread
   #5 dispatch_async
   #6 dispatch_sync
  #3 global thread
   #5 dispatch_async
   #6 dispatch_sync
 #3 global thread
  #1 main thread
   #5 dispatch_async
   #6 dispatch_sync
  #2 original thread
   #5 dispatch_async
   #6 dispatch_sync
  #3 global thread
   #5 dispatch_async
   #6 dispatch_sync
 
 thread label 変数の使い方でthreadの挙動はどうなるか
 */

/*
 元：global
 先：global
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goGlobalGlobalThreadAsync {
    // #3#3#5
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(globalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：global
 先：global
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同
 */
-(void)goGlobalGlobalThreadSync {
    // #3#3#6
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_sync(globalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    //uint t = 10;sleep(t);
}

/*
 元：global
 先：original
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goGlobalOriginalThreadAsync {
    // #3#2#5
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t originalThread = dispatch_queue_create("#3#2#5",nil);
        dispatch_async(originalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：global
 先：original
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同
 */
-(void)goGlobalOriginalThreadSync {
    // #3#2#6
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t originalThread = dispatch_queue_create("#3#2#6",nil);
        dispatch_sync(originalThread, ^{
        //    uint t = 4;sleep(t);
        });
        uint t = 4;sleep(t);
    });
    //uint t = 10;sleep(t);
}

/*
 元：global
 先：main
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goGlobalMainThreadAsync {
    // #3#1#5
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_async(mainThread, ^{
           uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    //uint t = 10;sleep(t);
}

/*
 元：global
 先：main
 方法：async
 開始：即
 割込：あり
 追越：あり
 thread NO：別
 */
-(void)goGlobalMainThreadSync {
    // #3#1#6
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_sync(mainThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：original
 先：global
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goOriginalGlobalThreadAsync {
    // #2#3#5
    dispatch_queue_t originalThread = dispatch_queue_create("#2#3#5",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t originalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(originalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：original
 先：global
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同
 */
-(void)goOriginalGlobalThreadSync {
    // #2#3#5
    dispatch_queue_t originalThread = dispatch_queue_create("#2#3#5",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t originalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_sync(originalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}


/*
 元：original
 先：original
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goOriginalOriginalThreadAsync {
    // #2#2#5
    dispatch_queue_t originalThread = dispatch_queue_create("#2#2#5",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t originalThread = dispatch_queue_create("#2#2#5",nil);
        dispatch_async(originalThread, ^{
            //uint t = 4;sleep(t);
        });
        uint t = 4;sleep(t);
    });
    //uint t = 10;sleep(t);
}

/*
 元：original
 先：original
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同
 */
-(void)goOriginalOriginalThreadSync {
    // #2#2#6
    dispatch_queue_t originalThread = dispatch_queue_create("#2#2#6-1",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t originalThread = dispatch_queue_create("#2#2#6-2",nil);
        dispatch_sync(originalThread, ^{
            uint t = 4;sleep(t);
        });
        //uint t = 4;sleep(t);
    });
    //uint t = 10;sleep(t);
}

/*
 元：original
 先：main
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goOriginalMainThreadAsync {
    // #2#1#5
    dispatch_queue_t originalThread = dispatch_queue_create("#2#1#5",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_async(mainThread, ^{
        });
        uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：original
 先：main
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：別
 */
-(void)goOriginalMainThreadSync {
    // #2#1#5
    dispatch_queue_t originalThread = dispatch_queue_create("#2#1#5",nil);
    dispatch_async(originalThread, ^{
        dispatch_queue_t mainThread = dispatch_get_main_queue();
        dispatch_sync(mainThread, ^{
            uint t = 4;sleep(t);
        });
       // uint t = 4;sleep(t);
    });
    uint t = 10;sleep(t);
}

/*
 元：main
 先：global
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goGlobalThreadAsync {
    // #1#3#5
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalThread, ^{
        uint t = 4;sleep(t);
    });
}

/*
 元：main
 先：global
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同
 */
-(void)goGlobalThreadSync {
    // #1#3#6
    dispatch_queue_t globalThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_sync(globalThread, ^{
        uint t = 4;sleep(t);
    });
}

/*
元：main
先：main
方法：async
開始：待(FIFO 直列)
割込：なし
追越：なし
thread NO：同じ
 */
-(void)goMainThreadAsync {
    // #1#1#5
    dispatch_queue_t mainThread = dispatch_get_main_queue();
    dispatch_queue_t mainThread2 = dispatch_get_main_queue();
    dispatch_async(mainThread, ^{
        dispatch_async(mainThread2, ^{
        });
        //uint s = 4;sleep(s);
    });
    uint t = 4;sleep(t);
}

/*
 元：main
 先：main
 方法：sync
 開始：帰ってこない
 割込：-
 追越：-
 thread NO：-
 */
-(void)goMainThreadSync {
    // #1#1#6
    dispatch_queue_t mainThread = dispatch_get_main_queue();
    dispatch_sync(mainThread, ^{
    });
}

/*
 元：main
 先：original
 方法：async
 開始：即
 割込：なし
 追越：あり
 thread NO：別
 */
-(void)goOriginalThreadAsync {
    // #1#2#5
    dispatch_queue_t originalThread = dispatch_queue_create("#1#2#5",nil);
    dispatch_async(originalThread, ^{
    });
    uint t = 4;sleep(t);
}

/*
 元：main
 先：original
 方法：sync
 開始：即
 割込：あり
 追越：あり
 thread NO：同じ
 */
-(void)goOriginalThreadSync {
    // #1#2#6
    dispatch_queue_t originalThread = dispatch_queue_create("#1#2#6",nil);
    dispatch_sync(originalThread, ^{
        uint t = 4;sleep(t);
    });
    
    dispatch_queue_t originalThread2 = dispatch_queue_create("#1#2#62",nil);
    dispatch_sync(originalThread2, ^{
    });
    uint t = 4;sleep(t);
}



@end
