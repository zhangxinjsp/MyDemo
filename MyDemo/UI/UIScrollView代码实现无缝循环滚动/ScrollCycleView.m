//
//  WHScrollAndPageView.m
//  ChinaExpress
//
//  Created by Perry on 15/8/6.
//  Copyright (c) 2015年 zhangxin. All rights reserved.
//

#import "ScrollCycleView.h"
@interface ScrollCycleView () <CAAnimationDelegate>
{
    NSTimer *autoScrollTimer;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@end

@implementation ScrollCycleView

@synthesize showItemArray;
@synthesize delegate;
@synthesize needAutoCycle;

- (id)init
{
    self = [super init];
    if (self) {
        needAutoCycle = NO;
        
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
    
    [scrollView removeConstraints:[scrollView constraints]];
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableDictionary* viewDict = [[NSMutableDictionary alloc]init];
    NSString* formatString = @"H:|-0-";
    NSInteger totalCount = needAutoCycle ? showItemArray.count + 1 : showItemArray.count;
    for (int i = 0; i < totalCount; i++) {
        NSInteger tag = i;
        if (needAutoCycle) {
            if (i == showItemArray.count) {
                tag = 0;
            } else {
                tag = i;
            }
        }
        UIImageView* pageView = [[UIImageView alloc]init];
        pageView.tag = tag;
        pageView.image = showItemArray[tag];
        pageView.userInteractionEnabled = YES;
        [pageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [scrollView addSubview:pageView];
        
        if (needAutoCycle) {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [pageView addGestureRecognizer:tap];
        }
        NSString* key = [NSString stringWithFormat:@"pageView_%d", i];
        [viewDict setObject:pageView forKeyedSubscript:key];
        formatString = [formatString stringByAppendingFormat:@"[%@(==scrollView)]-0-", key];
    }
    formatString = [formatString stringByAppendingString:@"|"];
    [viewDict setObject:scrollView forKey:@"scrollView"];
    
    NSDictionary* metricsDict = @{};
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pageView_0(==scrollView)]-0-|" options:0 metrics:metricsDict views:viewDict]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metricsDict views:viewDict]];
    if (!needAutoCycle) {
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
        [self layoutScrollView];
    }
}

#pragma mark scrollvie停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    NSInteger currentPage = (_scrollView.contentOffset.x / _scrollView.frame.size.width);
    pageControl.currentPage = currentPage % showItemArray.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    if (!needAutoCycle) {
        return;
    }
    CGFloat width = _scrollView.frame.size.width;
    CGFloat offSetX = _scrollView.contentOffset.x;
    if (offSetX < 0) {
        [_scrollView setContentOffset:CGPointMake(width * showItemArray.count, 0) animated:NO];
    } else if (offSetX > (width * showItemArray.count)) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

#pragma mark Action
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

-(void)setNeedAutoCycle:(BOOL)_needAutoCycle {
    needAutoCycle = _needAutoCycle;
    if (needAutoCycle) {
        [self layoutScrollView];
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (void)startTimer {
    if (!needAutoCycle) {
        return;
    }
    if (!autoScrollTimer) {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoShowNextImage) userInfo:nil repeats:YES];
    }
//    [self performSelector:@selector(autoShowNextImage) withObject:nil afterDelay:2];
}

- (void)stopTimer {
    if (autoScrollTimer) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
}

#pragma mark 展示下一页

-(void)autoShowNextImage {
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setRepeatCount:0];
//    [animation setRepeatDuration:2];
//    animation.fillMode = kCAFillModeBoth;
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [scrollView.layer addAnimation:animation forKey:@"animation"];
    
    pageControl.currentPage = (pageControl.currentPage + 1) % showItemArray.count;
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * pageControl.currentPage, 0)];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    LOGINFO(@"");
}

@end
