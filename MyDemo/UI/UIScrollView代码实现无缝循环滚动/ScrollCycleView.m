//
//  WHScrollAndPageView.m
//  ChinaExpress
//
//  Created by Perry on 15/8/6.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import "ScrollCycleView.h"
@interface ScrollCycleView ()
{
    NSTimer *autoScrollTimer;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    BOOL needRollingCycle;
}

@end

@implementation ScrollCycleView

@synthesize showItemArray;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        needRollingCycle = NO;
        
        [self initSubControls];
        [self layoutSubControls];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        needRollingCycle = YES;
        
        [self initSubControls];
        [self layoutSubControls];
    }
    return self;
}

- (void) initSubControls {
    //设置scrollview
    scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:scrollView];
    
    //设置分页
    pageControl = [[UIPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    pageControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pageControl];
}

- (void)layoutSubControls {
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(scrollView, pageControl);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollView(>=0)]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:viewDict]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollView(>=0)]-(==-20)-[pageControl(==20)]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:viewDict]];
}

-(void)layoutScrollView {
    if (showItemArray.count <= 0) {
        return;
    }
    NSMutableDictionary* viewDict = [[NSMutableDictionary alloc]init];
    NSString* formatString = @"H:|-0-";
    NSInteger totalCount = needRollingCycle ? showItemArray.count + 2 : showItemArray.count;
    for (int i = 0; i < totalCount; i++) {
        NSInteger tag = i;
        if (needRollingCycle) {
            if (i == 0) {
                tag = showItemArray.count - 1;
            } else if (i == showItemArray.count + 1) {
                tag = 0;
            } else {
                tag = i - 1;
            }
        }
        UIImageView* pageView = [[UIImageView alloc]init];
        pageView.tag = tag;
        pageView.image = showItemArray[tag];
        pageView.userInteractionEnabled = YES;
        [pageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [scrollView addSubview:pageView];
        
        if (needRollingCycle) {// || i == totalCount - 1
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [pageView addGestureRecognizer:tap];
        }
        NSString* key = [NSString stringWithFormat:@"pageView_%d", i];
        [viewDict setObject:pageView forKeyedSubscript:key];
        formatString = [formatString stringByAppendingFormat:@"[%@(width)]-0-", key];
    }
    formatString = [formatString stringByAppendingString:@"|"];
    CGFloat height = scrollView.bounds.size.height;
    CGFloat width = scrollView.bounds.size.width;
    
    NSDictionary* metricsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:height], @"height",
                                 [NSNumber numberWithFloat:width], @"width",
                                 [NSNumber numberWithFloat:width * (totalCount - 1)], @"mwidth", nil];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageView_0(height)]-0-|" options:0 metrics:metricsDict views:viewDict]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewDict]];
    if (needRollingCycle) {
        scrollView.contentOffset = CGPointMake(width, 0);
    } else {
        UIButton* startBtn = [[UIButton alloc]init];
        [startBtn setTitle:@"开启全新旅程" forState:UIControlStateNormal];
        [startBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [startBtn setBackgroundColor:[UIColor grayColor]];
        [startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [scrollView addSubview:startBtn];
        
        UIImageView* last = [viewDict objectForKey:[NSString stringWithFormat:@"pageView_%ld",(long)totalCount - 1]];
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:startBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:startBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:startBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:last attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-50]];
    }
}

#pragma mark 设置imageViewAry
-(void)setShowItemArray:(NSArray *)_showItemArray {
    if (_showItemArray) {
        showItemArray = _showItemArray;
        pageControl.numberOfPages = showItemArray.count;
    }
}

#pragma mark scrollvie停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    if (needRollingCycle) {
        NSInteger currentPage = (_scrollView.contentOffset.x / _scrollView.frame.size.width - 1);
        pageControl.currentPage = currentPage % showItemArray.count;
    } else {
        NSInteger currentPage = (_scrollView.contentOffset.x / _scrollView.frame.size.width);
        pageControl.currentPage = currentPage % showItemArray.count;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    if (!needRollingCycle) {
        return;
    }
    CGFloat width = _scrollView.frame.size.width;
    CGFloat offSetX = _scrollView.contentOffset.x;
    if (offSetX < 0) {
        [_scrollView setContentOffset:CGPointMake(width * showItemArray.count, 0) animated:NO];
    } else if (offSetX > (width * (showItemArray.count + 1))) {
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!needRollingCycle) {
        return;
    }
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!needRollingCycle) {
        return;
    }
    [self startTimer];
}

-(void)handleTap:(UITapGestureRecognizer*)sender {
    NSInteger tag = sender.view.tag;
    LOGINFO(@"selected at index :%d", tag);
    if (delegate && [delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
        [delegate didSelectAtIndex:tag];
    }
}

-(void)startAction:(id)sender {
    if (delegate && [delegate respondsToSelector:@selector(didSelectAtIndex:)]) {
        [delegate didSelectAtIndex:-1];
    }
}

#pragma mark 自动滚动
-(void)shouldAutoShow:(BOOL)shouldStart {
    if (!needRollingCycle) {
        return;
    }
    if (shouldStart) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (void)startTimer {
    if (!autoScrollTimer) {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer {
    if (autoScrollTimer) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
}

#pragma mark 展示下一页
-(void)autoShowNextImage {
    CGFloat offSet = self.frame.size.width;
    if (showItemArray.count - 1 > pageControl.currentPage) {
        offSet = offSet * (pageControl.currentPage + 2);
    }
    [scrollView setContentOffset:CGPointMake(offSet, 0)];
    pageControl.currentPage = (pageControl.currentPage + 1) % showItemArray.count;
}

@end
