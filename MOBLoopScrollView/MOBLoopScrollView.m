//
//  MOBLoopScrollView.m
//  MOBLoopScrollView
//
//  Created by 王慕博 on 2016/10/27.
//  Copyright © 2016年 mob. All rights reserved.
//

#import "MOBLoopScrollView.h"

@interface MOBLoopScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation MOBLoopScrollView


/**
 创建轮播器

 @return 轮播器
 */
+ (MOBLoopScrollView *)loopScrollView
{
   return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

# pragma mark - 一些初始化操作
- (void)setup
{
    // 开启翻页
    self.scrollView.pagingEnabled = YES;
    // 隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理以监听滚动
    self.scrollView.delegate = self;
    
    // 开启定时器
    [self startTimer];
}

// 使用xib创建调用
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

// 使用代码创建时调用
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

# pragma mark - 设置frame
/**
 设置frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置scrollView
    self.scrollView.frame = self.bounds;
    
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat scrollH = self.scrollView.frame.size.height;
    
    // 设置contentSize
    self.scrollView.contentSize = CGSizeMake(self.images.count * scrollW, 0);
    
    for (int i = 0; i < self.images.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.frame = CGRectMake(scrollW * i, 0, scrollW, scrollH);
    }

    // 设置pageControl
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
}

# pragma mark - 填充数据
/**
 重写setter,给scroolView 添加 imageView

 @param images 传入的图片数组
 */
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    // 清空  防止多次对scrollView赋值造成多余数据
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger count = images.count;
    
    for (int i = 0; i < count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = images[i];
        [self.scrollView addSubview:imageView];
        
    }
    
    self.pageControl.numberOfPages = count;
}

# pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 监听滚动的幅度判断页面指示器
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
}


# pragma mark - 定时器
- (void)startTimer
{
    // 创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];

    // 防止其他控件干扰
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}


/**
 offset.x = 页数 * scrollView的宽度
 注意到最后一张需要回到第一张
 */
- (void)nextPage
{
    NSUInteger index = self.pageControl.currentPage + 1;
    
    // 如果是最后一页则回到第一页
    if (index == self.pageControl.numberOfPages) {
        index = 0;
    }
    
    // 对象的结构体属性的值不可以直接修改,需要先赋值给另外一个结构体修改后重新赋值回来
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.scrollView.frame.size.width * index;
    [self.scrollView setContentOffset:offset animated: YES];
    
}
@end
