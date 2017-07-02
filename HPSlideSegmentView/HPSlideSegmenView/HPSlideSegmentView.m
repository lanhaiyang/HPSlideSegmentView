//
//  HPSlideSegmentView.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/12.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideSegmentView.h"
#import "UIView+HPSlideSegmentRect.h"
#import "HPSlideSegmentLogic.h"

@interface HPSlideSegmentView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *viewContrllerScrollerView;
@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,assign) CGPoint startOffset;

@property(nonatomic,strong) HPSlideModel *slideLeft;
@property(nonatomic,strong) HPSlideModel *slideCentre;
@property(nonatomic,strong) HPSlideModel *slideRight;

@property(nonatomic,assign) NSUInteger showCount;

@property(nonatomic,assign) BOOL scrollViewMove;

@end

@implementation HPSlideSegmentView
{
    NSUInteger _pageIndex;
}


-(void)slideSegmentLayout
{
    self.backgroundColor=[UIColor whiteColor];
    
    self.backgroundView.frame=CGRectMake(0, 0, _viewContrllerScrollerView.contentSize.width, _viewContrllerScrollerView.contentSize.height);
    [_viewContrllerScrollerView addSubview:self.backgroundView];
    
}

-(void)updateLayout
{
    //更新布局
    [self layoutWithView];
}

-(void)layoutWithView
{
    if (self.showCount==0) {
        return ;
    }
    
    
    if (self.showCount==1)
    {
        [HPSlideSegmentView layoutWithScrollerAddView:self.backgroundView
                                                 left:self.slideLeft
                                               centre:nil
                                                right:nil
                                scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
    else if(self.showCount==2)
    {
        [HPSlideSegmentView layoutWithScrollerAddView:self.backgroundView
                                                 left:self.slideLeft
                                               centre:self.slideCentre
                                                right:nil
                                scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
    else if (self.showCount>3)
    {
        [HPSlideSegmentView layoutWithScrollerAddView:self.backgroundView
                                                 left:self.slideLeft
                                               centre:self.slideCentre
                                                right:self.slideRight
                                scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
}

+(void)layoutWithScrollerAddView:(UIView *)addView
                            left:(UIView *)left
                          centre:(UIView *)centre
                           right:(UIView *)right
           scrollerViewWithWidth:(CGFloat)scrollerViewWidth
{
    
    left.frame=CGRectMake(0, 0, left.width, left.height);
    [addView addSubview:left];
    
    centre.frame=CGRectMake(scrollerViewWidth, 0, centre.width, centre.height);
    [addView addSubview:centre];
    
    right.frame=CGRectMake(2*scrollerViewWidth, 0, right.width, right.height);
    [addView addSubview:right];
}

-(void)updateScrollerViewWidthWidth:(NSUInteger)arrayCount
{
    self.viewContrllerScrollerView.frame=CGRectMake(0, 0, self.width, self.height);
    CGFloat sizeWidth=[HPSlideSegmentLogic scrollViewWidth:_viewContrllerScrollerView.width dataArrayCount:arrayCount];
    self.viewContrllerScrollerView.contentSize=CGSizeMake(sizeWidth, self.height);
    
    [self addSubview:_viewContrllerScrollerView];
    
    self.showCount=arrayCount;
    
    [self layoutWithView];
    [self updateLayout:_pageIndex];
    [self slideSegmentLayout];
}

-(void)updateLayout:(NSUInteger)pageIndex
{
    
    _pageIndex=pageIndex;
    
    [HPSlideSegmentLogic currentIndex:pageIndex
                           arrayCount:_showCount
                           scrollView:_viewContrllerScrollerView
                       slideSuperView:_viewContrllerScrollerView.width
                          changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {
                              
                              self.startOffset=startPoint;
                              
                              if ([self.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                  
                                  
                                  [self changeStatusLeft:left centre:centre right:right];
                                  
                              }
                              
                               [self currenSlideScrollView];
                              
                              
                              
                          }];
}

#pragma mark - scrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_showCount==0 ) {
        return;
    }
    
    if (_scrollViewMove==NO) {
        return;
    }
    
    NSUInteger index=[HPSlideSegmentLogic scrollView:_viewContrllerScrollerView
                                        currentIndex:&_pageIndex
                                         startOffset:_startOffset
                                           dataArray:_showCount];
    if ([self.delegate respondsToSelector:@selector(hp_slideWithNowIndex:readyIndex:movePercent:)]) {
        
        CGFloat percent=fabs(scrollView.contentOffset.x-self.startOffset.x)/self.width;
        
        [self.delegate hp_slideWithNowIndex:_pageIndex readyIndex:index movePercent:percent];
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewMove=YES;
    self.startOffset=scrollView.contentOffset;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollViewMove=NO;
    [HPSlideSegmentLogic slideSuperView:_viewContrllerScrollerView.width
                             scrollView:_viewContrllerScrollerView
                           currentIndex:&_pageIndex
                              startOffset:self.startOffset
                              dataArray:_showCount
                            changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {
                                
                                self.startOffset=startPoint;
                                
                                if ([self.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                    
                                    
                                    [self changeStatusLeft:left centre:centre right:right];
                                    
                                }
                                
                                
                            }endIndex:^{
                                
                                [self currenSlideScrollView];
                                
                            }];

    
}

-(void)currenSlideScrollView
{
    
    if (![self.upDelegate respondsToSelector:@selector(hp_currentMainSlideScrollView:)]) {
        
        return;
        
        
    }
    
    if (_showCount==2) {
        
        if (_pageIndex==0) {
            [self.upDelegate hp_currentMainSlideScrollView:_slideLeft.mainSlideScrollView];
        }
        else if (_pageIndex==self.showCount-1)
        {
            [self.upDelegate hp_currentMainSlideScrollView:_slideCentre.mainSlideScrollView];
        }
        
    }
    else
    {
        if (_pageIndex==0) {
            [self.upDelegate hp_currentMainSlideScrollView:_slideLeft.mainSlideScrollView];
        }
        else if (_pageIndex==self.showCount-1)
        {
            [self.upDelegate hp_currentMainSlideScrollView:_slideRight.mainSlideScrollView];
        }
        else
        {
            [self.upDelegate hp_currentMainSlideScrollView:_slideCentre.mainSlideScrollView];
        }
    }
}

-(void)changeStatusLeft:(HPNumber)left centre:(HPNumber)centre right:(HPNumber)right
{
    
    if (left.error==nil) {
        
        if (_slideLeft==nil) {
            return;
        }
        
        [HPSlideSegmentView releateViewController:_slideLeft];
        
        [self.dataSource hp_slideListWithViewController:_slideLeft index:left.number];
    }
    else
    {
        [HPSlideSegmentView releateViewController:_slideLeft];
    }
    
    if (centre.error==nil) {
        
        if (_slideCentre==nil) {
            return;
        }
        
        [HPSlideSegmentView releateViewController:_slideCentre];
        
        [self.dataSource hp_slideListWithViewController:_slideCentre index:centre.number];
    }
    else
    {
        [HPSlideSegmentView releateViewController:_slideCentre];
    }
    
    if (right.error==nil) {
        
        if (_slideRight==nil) {
            return;
        }
        
        [HPSlideSegmentView releateViewController:_slideRight];
        
        [self.dataSource hp_slideListWithViewController:_slideRight index:right.number];
    }
    else
    {
        [HPSlideSegmentView releateViewController:_slideRight];
    }
}

+(void)releateViewController:(HPSlideModel *)slideModel
{
    if (slideModel==nil) {
        return;
    }
    [slideModel.showViewController.view removeFromSuperview];
    slideModel.showViewController=nil;
    [slideModel.mainSlideScrollView removeFromSuperview];
    slideModel.mainSlideScrollView=nil;
}


#pragma mark -懒加载

-(void)setDataSource:(id<HPSlideSegmentViewDataSouce>)dataSource
{
    _dataSource=dataSource;
    
    [self updateLayout:_pageIndex];
    
}

-(void)setUpDelegate:(id<HPSlideUpViewDelegate>)upDelegate
{
    _upDelegate=upDelegate;
    
    [self updateLayout:_pageIndex];
}

-(HPSlideModel *)slideLeft
{
    if (_slideLeft==nil) {
        _slideLeft=[[HPSlideModel alloc] init];
        _slideLeft.frame=CGRectMake(0, 0, self.width, self.height);
    }
    return _slideLeft;
}

-(HPSlideModel *)slideCentre
{
    if (_slideCentre==nil) {
        _slideCentre=[[HPSlideModel alloc] init];
        _slideCentre.frame=CGRectMake(0, 0, self.width, self.height);
    }
    return _slideCentre;
}

-(HPSlideModel *)slideRight
{
    if (_slideRight==nil) {
        _slideRight=[[HPSlideModel alloc] init];
        _slideRight.frame=CGRectMake(0, 0, self.width, self.height);
    }
    return _slideRight;
}

-(UIView *)backgroundView
{
    if (_backgroundView==nil) {
        _backgroundView=[[UIView alloc] init];
    }
    return _backgroundView;
}

-(UIScrollView *)viewContrllerScrollerView
{
    if (_viewContrllerScrollerView==nil) {
        _viewContrllerScrollerView=[[UIScrollView alloc] init];
        _viewContrllerScrollerView.pagingEnabled=YES;
        _viewContrllerScrollerView.delegate=self;
        _viewContrllerScrollerView.backgroundColor=[UIColor clearColor];
        _viewContrllerScrollerView.showsVerticalScrollIndicator=NO;
        _viewContrllerScrollerView.showsHorizontalScrollIndicator=NO;
    }
    return _viewContrllerScrollerView;
}


@end

@implementation HPSlideModel


-(void)setShowViewController:(UIViewController *)showViewController
{
    if (showViewController==nil) {
        return;
    }
    
    _showViewController=showViewController;
    
    showViewController.view.frame=CGRectMake(0, 0, self.width, self.height);
    [self addSubview:showViewController.view];
}


@end
