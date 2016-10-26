//
//  ViewController.m
//  MOBLoopScrollView
//
//  Created by 王慕博 on 2016/10/27.
//  Copyright © 2016年 mob. All rights reserved.
//

#import "ViewController.h"
#import "MOBLoopScrollView.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建轮播器
    MOBLoopScrollView *looper = [MOBLoopScrollView loopScrollView];
    
    // 设置轮播frame
    looper.frame = CGRectMake(50, 50, 350, 200);
    looper.images = self.images;
    [self.view addSubview:looper];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 懒加载
 @return 图片数组
 */
- (NSMutableArray *)images
{
    if (_images == nil) {
        
        self.images = [NSMutableArray array];
        
        for (int i = 0; i < 5 ; i++) {
            NSString *name = [NSString stringWithFormat:@"img_0%d.png", i];
            [self.images addObject:[UIImage imageNamed:name]];
        }
    }
    
    return _images;
}

@end
