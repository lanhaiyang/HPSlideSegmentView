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
#import "HPCacheListManage.h"


@interface HPSlideSegmentView ()<UIScrollViewDelegate,NSCacheDelegate,HPCacheListManageDelegate>

@property(nonatomic,strong) UIScrollView *viewContrllerScrollerView;
@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,assign) CGPoint startOffset;

@property(nonatomic,strong) HPSlideModel *slideLeft;
@property(nonatomic,strong) HPSlideModel *slideCentre;
@property(nonatomic,strong) HPSlideModel *slideRight;

@property(nonatomic,assign) NSUInteger showCount;

@property(nonatomic,assign) BOOL scrollViewMove;

@property(nonatomic,strong) HPCacheListManage *cacheListMange;




@property(nonatomic,weak) UIScrollView *centreScrollerView;//滑动到中间

@end

@interface HPSlideModel ()

@property(nonatomic,assign) BOOL observse;
@property(nonatomic,assign) NSUInteger xxx;

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

#pragma mark - <HPCacheListManageDelegate>
-(void)removeWithCacheObj:(id)Obj
{
    HPSlideModel *cacheSlideModel=Obj;
    
    if (cacheSlideModel==nil) {
        return;
    }
    
    if (cacheSlideModel.observse==YES) {
        [cacheSlideModel.mainSlideScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    [cacheSlideModel.showViewController.view removeFromSuperview];
    cacheSlideModel.showViewController=nil;
    [cacheSlideModel.mainSlideScrollView removeFromSuperview];
    cacheSlideModel.mainSlideScrollView=nil;
    cacheSlideModel.observse=NO;
    cacheSlideModel=nil;
    
}

-(void)removeWithLayout:(HPSlideModel *)slideView
{
    
    if (slideView==nil) {
        return;
    }
    
    [slideView.showViewController.view removeFromSuperview];
    slideView.showViewController=nil;   
}


-(void)currenSlideScrollView
{
    
    
    if (_showCount==2) {
        
        if (_pageIndex==0) {
            [self addObserver:_slideLeft pageIndex:_pageIndex];

        }
        else if (_pageIndex==self.showCount-1)
        {
            [self addObserver:_slideCentre pageIndex:_pageIndex];

        }
        
    }
    else
    {
        if (_pageIndex==0) {
            [self addObserver:_slideLeft pageIndex:_pageIndex];

            
        }
        else if (_pageIndex==self.showCount-1)
        {
            [self addObserver:_slideRight pageIndex:_pageIndex];

        }
        else
        {
            [self addObserver:_slideCentre pageIndex:_pageIndex];

        }
    }
    

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIScrollView *scrollView = (UIScrollView *)object;
    if (self.centreScrollerView == scrollView && [@"contentOffset" isEqualToString:keyPath]) {
        
//        [self scrollViewDidScroll:scrollView];
        
        if ([self.upDelegate respondsToSelector:@selector(hp_currentMainSlideScrollView:changeWithOffset:)]) {
            
            [self.upDelegate hp_currentMainSlideScrollView:self.centreScrollerView changeWithOffset:scrollView.contentOffset];
            
        }
        
    }
}

-(void)addObserver:(HPSlideModel *)slideModel pageIndex:(NSUInteger)index
{
    
    _centreScrollerView = slideModel.mainSlideScrollView;
    
    if (slideModel.observse==YES) {
        return;
    }
    
    if (_centreScrollerView==nil) {
        return;
    }
    
    
    
    [_centreScrollerView addObserver:self
                          forKeyPath:@"contentOffset"
                             options:NSKeyValueObservingOptionNew
                             context:nil];
    
    slideModel.observse=YES;
    [self updateWithViewCacheSlideModel:slideModel keyIndex:index];
}

-(void)changeStatusLeft:(HPNumber)left centre:(HPNumber)centre right:(HPNumber)right
{


    
    [HPSlideSegmentView numberWithLessThanZero:left];
    [HPSlideSegmentView numberWithLessThanZero:centre];
    [HPSlideSegmentView numberWithLessThanZero:right];
    
    [self removeWithLayout:_slideLeft];
    [self removeWithLayout:_slideCentre];
    [self removeWithLayout:_slideRight];
    
    [self.cacheListMange addCacheWithLeft:ObjcWithKeyStructMake(left.number, LEFTTYPE)
                                   Centre:ObjcWithKeyStructMake(centre.number, CENTRETYPE)
                                    Right:ObjcWithKeyStructMake(right.number, RIGHTTYPE)
                                  weakObj:self
                              layoutBlock:^(HPSlideSegmentView *weakObj, id cacheObje, DirectionType direction, NSUInteger key) {
                                  
                                  HPSlideModel *cacheSlideModel=cacheObje;
                                  
                                  switch (direction) {
                                      case LEFTTYPE:
                                      {
                                          [HPSlideSegmentView layoutWithView:weakObj.slideLeft cacheSlideModel:cacheSlideModel];
                                      }
                                          break;
                                      case CENTRETYPE:
                                      {
                                          [HPSlideSegmentView layoutWithView:weakObj.slideCentre cacheSlideModel:cacheSlideModel];
                                      }
                                          break;
                                      case RIGHTTYPE:
                                      {
                                          [HPSlideSegmentView layoutWithView:weakObj.slideRight cacheSlideModel:cacheSlideModel];
                                      }
                                          break;
                                      default:
                                          break;
                                  }
                                  
                                  
                              } notCahceCreatBlock:^id(HPSlideSegmentView *weakObj, NSUInteger key) {
                                  
                                  HPSlideModel *cacheSlideModel=nil;
                                  
                                  if ([weakObj.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                      
                                      cacheSlideModel=[[HPSlideModel alloc] init];
                                      
                                      [weakObj.dataSource hp_slideListWithViewController:cacheSlideModel index:key];
                                  }
                                  
                                  return cacheSlideModel;
                                  
                              }];
    
    
}

+(void)layoutWithView:(HPSlideModel *)slideModel cacheSlideModel:(HPSlideModel *)cacheSlideModel
{
    
    [slideModel setShowViewController:cacheSlideModel.showViewController];
    slideModel.mainSlideScrollView=cacheSlideModel.mainSlideScrollView;
    slideModel.observse=cacheSlideModel.observse;
    slideModel.name=cacheSlideModel.name;
}

-(void)updateWithViewCacheSlideModel:(HPSlideModel *)slideModel keyIndex:(NSUInteger)index
{
    
    HPSlideModel *cacheSlideModel=[self.cacheListMange cacheWithKey:@(index)];
    
    if (cacheSlideModel==nil) {
        return;
    }
    cacheSlideModel.observse=slideModel.observse;
}

+(void)numberWithLessThanZero:(HPNumber)number
{
    if (number.error!=nil) {
        
        number.number=-1;
        
    }
    
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

-(void)setCacheMaxCount:(NSUInteger )cacheMaxCount
{
    _cacheMaxCount=cacheMaxCount;
    self.cacheListMange.cacheListMax=cacheMaxCount;
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

-(HPCacheListManage *)cacheListMange
{
    if (_cacheListMange==nil) {
        _cacheListMange=[[HPCacheListManage alloc] init];
        _cacheListMange.delegate=self;
    }
    return _cacheListMange;
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
