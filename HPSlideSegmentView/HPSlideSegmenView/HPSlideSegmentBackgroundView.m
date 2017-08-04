//
//  HPSlideSegmentBackgroundView.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/13.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentBackgroundView.h"
#import "HPSlideSegmentLogic.h"
#import "UIView+HPSlideSegmentRect.h"

@interface HPSlideSegmentBackgroundView ()<SlideModuleViewDelegate,HPSlideSegmentViewDelegate>


@property(nonatomic,assign) NSUInteger arrayCount;

@end

@implementation HPSlideSegmentBackgroundView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self updateData];
        [self slideSegmentlayout];
        [self slideAction];
    }
    return self;
}

-(void)updateData
{
    if ([self.dataSource respondsToSelector:@selector(hp_slideListWithCount)]) {
        self.arrayCount=[self.dataSource hp_slideListWithCount];
    }
    
    
}

-(void)updateLayout
{
    //更新布局
    [self updateData];
    [self slideSegmentlayout];
}

-(void)updateLayoutWithIndex:(NSUInteger)index
{
    [self.slideSegmenView updateLayout:index];
    [self.slideModuleView updateLayoutWithIndex:index];
}

-(void)slideSegmentlayout
{
    [self.slideSegmenView updateScrollerViewWidthWidth:self.arrayCount];
    self.slideModuleView.showCount=self.arrayCount;
    
    [self addSubview:self.slideModuleView];
    [self addSubview:self.slideSegmenView];
    
}

-(void)slideAction
{
    [self.slideModuleView hp_weak:self
                     actionButton:^(HPSlideSegmentBackgroundView *weak, NSUInteger buttonIndex) {
                         
                         [weak.slideSegmenView updateLayout:buttonIndex];
                         
                     }];
}

#pragma mark - HPSlideSegmentViewDataSouce

-(void)hp_slideWithNowIndex:(NSUInteger)nowIndex readyIndex:(NSUInteger)readyIndex movePercent:(CGFloat)movePercent
{
    [self.slideModuleView slideWithNowIndex:nowIndex readyIndex:readyIndex movePercent:movePercent];
}

#pragma mark - SlideModuleViewDelegate

-(NSString *)hp_slideContentWithIndex:(NSUInteger)index
{
    return self.contents[index];
}


#pragma mark - 懒加载

-(void)setSlideModuleViewHeight:(CGFloat)slideModuleViewHeight
{
    
    if (slideModuleViewHeight<30) {
        slideModuleViewHeight=30;
    }
    
    _slideModuleViewHeight=slideModuleViewHeight;

    _slideModuleView.frame=CGRectMake(0, 0, self.width, slideModuleViewHeight);
    CGFloat y=self.slideModuleView.x+self.slideModuleView.height;
    _slideSegmenView.frame=CGRectMake(0, y, self.width, self.height-y);
    [self updateLayout];
}


-(void)setDataSource:(id<HPSlideSegmentBackgroundDataSource>)dataSource
{
    _dataSource=dataSource;
    [self updateLayout];
}

-(void)setContents:(NSArray<NSString *> *)contents
{
    _contents=contents;
    [self updateLayout];
}


-(HPSlideModuleView *)slideModuleView
{
    if (_slideModuleView==nil) {
        _slideModuleView=[[HPSlideModuleView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _slideModuleView.delegate=self;
    }

    return _slideModuleView;
}

-(HPSlideSegmentView *)slideSegmenView
{
    if (_slideSegmenView==nil) {
        CGFloat y=self.slideModuleView.x+self.slideModuleView.height;
        _slideSegmenView=[[HPSlideSegmentView alloc] initWithFrame:CGRectMake(0, y, self.width, self.height)];
        _slideSegmenView.delegate=self;
    }
    return _slideSegmenView;
}


@end
