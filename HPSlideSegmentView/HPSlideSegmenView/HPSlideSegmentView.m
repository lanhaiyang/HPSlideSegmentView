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
#import "HPSegmentEnum.h"
#import "HPKVOMange.h"



@interface HPSlideSegmentView ()<UIScrollViewDelegate,NSCacheDelegate,HPCacheListManageDelegate>

@property(nonatomic,strong) UIScrollView *viewContrllerScrollerView;
@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,assign) CGPoint startOffset;
@property(nonatomic,assign) CGPoint endOffset;

@property(nonatomic,strong) HPSlideModel *slideLeft;
@property(nonatomic,strong) HPSlideModel *slideCentre;
@property(nonatomic,strong) HPSlideModel *slideRight;

@property(nonatomic,assign) NSUInteger showCount;

@property(nonatomic,assign) BOOL scrollViewMove;
@property(nonatomic,assign) BOOL scrollViewMove1;

@property(nonatomic,strong) HPCacheListManage *cacheListMange;
@property(nonatomic,strong) HPKVOMange *kvoMange;



@property(nonatomic,weak) UIScrollView *centreScrollerView;//滑动到中间

@property(nonatomic,assign) CGFloat privateChangeCahePoint;

@end

@interface HPSlideModel ()

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
    else if (self.showCount>=3)
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
 
    _pageIndex=[HPSlideSegmentLogic arraCount:_showCount index:pageIndex];
    
    [HPSlideSegmentLogic currentIndex:_pageIndex
                           arrayCount:_showCount
                           scrollView:_viewContrllerScrollerView
                       slideSuperView:_viewContrllerScrollerView.width
                          changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {
                              
                              self.startOffset=startPoint;
                              
                              if ([self.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                  
                                  
                                  [self changeStatusLeft:left centre:centre right:right updateCreatNifomation:YES];
                                  
                              }
                              
                              [self currenSlideScrollView];
                              
                              
                          }];
    
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
        [self.gestrueClashDelegate hp_slideWithGestureClash:YES];
        
    }
}

#pragma mark - scrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (_showCount==0 ) {
        return;
    }
    
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
        [self.gestrueClashDelegate hp_slideWithGestureClash:NO];
        
    }

    
    if (_scrollViewMove==NO) {
        _scrollViewMove=YES;
        
        [HPSlideSegmentLogic scrollViewWithStartPoint:_startOffset
                                           moveOffset:scrollView.contentOffset
                                     slideModuleWidht:scrollView.width
                                         currentIndex:_pageIndex
                                            dataArray:_showCount
                                      startPointBlock:^(CGPoint startPoint, CGPoint endPoint) {
                                          
                                          self.startOffset=startPoint;
                                          self.endOffset=endPoint;
                                          
                                      }];
        
    }
    
    if (_scrollViewMove1==YES) {
        return;
    }

    [HPSlideSegmentLogic scrollView:_viewContrllerScrollerView
                       currentIndex:&_pageIndex
                        startOffset:_startOffset
                          endOffset:_endOffset
                          dataArray:_showCount
                    startPointBlock:^(CGPoint startPoint,CGPoint endPoint) {
                        
                        self.startOffset=startPoint;
                        self.endOffset=endPoint;
                        
                    } boardBlock:^void{
                        
                        [self changeWithScrollView:_viewContrllerScrollerView];
                        
                    } moduleBlock:^(NSUInteger nowIndex, NSUInteger readyIndex, CGFloat movePercent) {
                    
                        if ([self.delegate respondsToSelector:@selector(hp_slideWithNowIndex:readyIndex:movePercent:)]) {
                            
                            [self.delegate hp_slideWithNowIndex:nowIndex readyIndex:readyIndex movePercent:movePercent];
                            
                            
                        }
                        
                        
                    }];

}

-(void)changeWithScrollView:(UIScrollView *)scrollView
{
    _scrollViewMove1=YES;
    
    [HPSlideSegmentLogic slideSuperView:_viewContrllerScrollerView.width
                             scrollView:_viewContrllerScrollerView
                           currentIndex:&_pageIndex
                            startOffset:self.startOffset
                              dataArray:_showCount
                            changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {
                                
                                
                                if ([self.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                    
                                    
                                    [self changeStatusLeft:left centre:centre right:right updateCreatNifomation:NO];
                                    
                                }
                                
                                
                                
                            }endIndex:^{
                                
                                _scrollViewMove1=NO;
                                [self currenSlideScrollView];
                                
                            }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollViewMove=NO;
    _scrollViewMove1=NO;
    _scrollViewMove=NO;
    
    
        int morePage=(int)(scrollView.contentOffset.x/scrollView.width);
        self.startOffset=CGPointMake(morePage*scrollView.width, scrollView.contentOffset.y);

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_pageIndex>0 && _pageIndex<_showCount-1) {
        scrollView.contentOffset=CGPointMake(self.startOffset.x, scrollView.contentOffset.y);
    }


    if ([self.delegate respondsToSelector:@selector(hp_slideWithNowIndex:readyIndex:movePercent:)]) {
        
        
        [self.delegate hp_slideWithNowIndex:_pageIndex readyIndex:_pageIndex movePercent:1.0];
        
        
    }

    
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
            [self.gestrueClashDelegate hp_slideWithGestureClash:YES];
        
    }

    
}

#pragma mark - <HPCacheListManageDelegate>
-(void)removeWithCacheObj:(id)Obj
{
    HPSlideModel *cacheSlideModel=Obj;
    
    if (cacheSlideModel==nil) {
        return;
    }
    
    [self.kvoMange removeObserverWithObject:cacheSlideModel.mainSlideScrollView
                                  blockWeak:self
                                addObserver:^(HPSlideSegmentView *weakObj) {
                                    
                                    [cacheSlideModel.mainSlideScrollView removeObserver:self forKeyPath:@"contentOffset"];
                                    
                                }];

    [cacheSlideModel.showViewController.view removeFromSuperview];
    cacheSlideModel.showViewController=nil;
    [cacheSlideModel.mainSlideScrollView removeFromSuperview];
    cacheSlideModel.mainSlideScrollView=nil;
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

        if ([self.upDelegate respondsToSelector:@selector(hp_currentMainSlideScrollView:)]) {
            
            [self.upDelegate hp_currentMainSlideScrollView:self.centreScrollerView];
            
        }
        
    }
}

-(void)addObserver:(HPSlideModel *)slideModel pageIndex:(NSUInteger)index
{
    
    _centreScrollerView = slideModel.mainSlideScrollView;

    
    if (_centreScrollerView==nil) {
        return;
    }
    
    [self.kvoMange addObserverWithObject:_centreScrollerView
                               blockWeak:self
                             addObserver:^(HPSlideSegmentView *weakObj) {
                                 
                                 [weakObj.centreScrollerView addObserver:weakObj
                                                              forKeyPath:@"contentOffset"
                                                                 options:NSKeyValueObservingOptionNew
                                                                 context:nil];
                                 
                             }];
    
}

-(void)changeStatusLeft:(HPNumber)left centre:(HPNumber)centre right:(HPNumber)right updateCreatNifomation:(BOOL)update
{

    
    [self removeWithLayout:_slideLeft];
    [self removeWithLayout:_slideCentre];
    [self removeWithLayout:_slideRight];
    
    
    [self.cacheListMange addCacheWithLeft:ObjcWithKeyStructMake(left.number, LEFTTYPE)
                                   Centre:ObjcWithKeyStructMake(centre.number, CENTRETYPE)
                                    Right:ObjcWithKeyStructMake(right.number, RIGHTTYPE)
                                  weakObj:self
                            updateContent:update
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
                                  
                                  
                              } notCahceCreatBlock:^id(HPSlideSegmentView *weakObj,id cacheObj, NSUInteger key) {
                                  
                                  HPSlideModel *cacheSlideModel=cacheObj;
                                  
                                  if ([weakObj.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
                                      
                                      if (cacheObj==nil) {
                                          cacheSlideModel=[[HPSlideModel alloc] init];
                                      }
                                      
                                      [weakObj.dataSource hp_slideListWithViewController:cacheSlideModel index:key];
                                  }
                                  
                                  return cacheSlideModel;
                                  
                              }];
    
    
}

+(void)layoutWithView:(HPSlideModel *)slideModel cacheSlideModel:(HPSlideModel *)cacheSlideModel
{
    
    [slideModel setShowViewController:cacheSlideModel.showViewController];
    slideModel.mainSlideScrollView=cacheSlideModel.mainSlideScrollView;
    slideModel.name=cacheSlideModel.name;
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

-(HPKVOMange *)kvoMange
{
    if (_kvoMange==nil) {
        _kvoMange=[[HPKVOMange alloc] init];
    }
    return _kvoMange;
}

-(UIScrollView *)viewContrllerScrollerView
{
    if (_viewContrllerScrollerView==nil) {
        _viewContrllerScrollerView=[[UIScrollView alloc] init];
        _viewContrllerScrollerView.pagingEnabled=YES;
        _viewContrllerScrollerView.delegate=self;
        _viewContrllerScrollerView.bounces=NO;
        _viewContrllerScrollerView.backgroundColor=[UIColor clearColor];
        _viewContrllerScrollerView.showsVerticalScrollIndicator=NO;
        _viewContrllerScrollerView.showsHorizontalScrollIndicator=NO;
    }
    return _viewContrllerScrollerView;
}


@end

@implementation HPSlideModel

-(id)cacheWithClass:(Class)className cacheIndex:(NSUInteger)index initAction:(InitWithActionBlock)actionBlock
{
    if (className==nil) {
        return nil;
    }
    
    id cacheObj=self.showViewController;
    
    if (cacheObj==nil) {
        cacheObj=[[className alloc] init];
        
        if (actionBlock!=nil) {
            actionBlock(self);
        }
        
    }
    
    
    return cacheObj;

}

-(id)cacheWithStoryboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier cacheIndex:(NSUInteger)index
{
    
    if (storyboard==nil || identifier==nil) {
        return nil;
    }
    
    id cacheObj=self.showViewController;
    
    
    if (cacheObj==nil) {
        cacheObj=[storyboard instantiateViewControllerWithIdentifier:identifier];
       
    }
    
    return cacheObj;
    
}


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
