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
#import "HPScrollView.h"


@interface HPSlideSegmentView ()<UIScrollViewDelegate,NSCacheDelegate,HPCacheListManageDelegate>

@property(nonatomic,strong) HPScrollView *viewContrllerScrollerView;

@property(nonatomic,strong) HPSlideModel *slideLeft;
@property(nonatomic,strong) HPSlideModel *slideCentre;
@property(nonatomic,strong) HPSlideModel *slideRight;

@property(nonatomic,assign) NSUInteger showCount;

@property(nonatomic,assign) BOOL scrollViewMove;

@property(nonatomic,strong) HPCacheListManage *cacheListMange;
@property(nonatomic,strong) HPKVOMange *kvoMange;

@property(nonatomic,weak) UIScrollView *centreScrollerView;//滑动到中间

@property(nonatomic,assign) CGFloat privateChangeCahePoint;

@end

@interface HPSlideModel ()

/**
 显示的ViewController
 */
@property(nonatomic,strong) UIViewController *showViewController;


/**
 ViewController 上面 的scrollView
 */
@property(nonatomic,strong) UIScrollView *mainSlideScrollView;

@end


@implementation HPSlideSegmentView
{
    NSUInteger _pageIndex;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutWithView];
}

-(void)updateLayout
{
    //更新布局
    [self layoutWithView];
    [self updateLayout:0];
}

-(void)layoutWithView
{
    if (self.showCount==0) {
        return ;
    }
    
    
    if (self.showCount==1)
    {
        [self layoutWithScrollerAddView:self.viewContrllerScrollerView
                                   left:self.slideLeft
                                 centre:nil
                                  right:nil
                  scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
    else if(self.showCount==2)
    {
        [self layoutWithScrollerAddView:self.viewContrllerScrollerView
                                   left:self.slideLeft
                                 centre:self.slideCentre
                                  right:nil
                  scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
    else if (self.showCount>=3)
    {
        [self layoutWithScrollerAddView:self.viewContrllerScrollerView
                                   left:self.slideLeft
                                 centre:self.slideCentre
                                  right:self.slideRight
                  scrollerViewWithWidth:self.viewContrllerScrollerView.width];
    }
    
}

-(void)layoutWithScrollerAddView:(UIScrollView *)addView
                            left:(UIView *)left
                          centre:(UIView *)centre
                           right:(UIView *)right
           scrollerViewWithWidth:(CGFloat)scrollerViewWidth
{
    
    CGFloat width = self.viewContrllerScrollerView.width;
    CGFloat height = self.viewContrllerScrollerView.height;
    
    left.frame=CGRectMake(0, 0, width, height);
    [addView addSubview:left];
    
    centre.frame=CGRectMake(scrollerViewWidth, 0, width, height);
    [addView addSubview:centre];
    
    right.frame=CGRectMake(2*scrollerViewWidth, 0, width, height);
    [addView addSubview:right];
}



-(void)updateLayout:(NSUInteger)pageIndex
{
    [self updateLayout:pageIndex updateDelegate:YES];
}

-(void)updateScrollerViewWidthWidth:(NSUInteger)arrayCount
{
    self.viewContrllerScrollerView.frame=CGRectMake(0, 0, self.width, self.height);
    CGFloat sizeWidth=[HPSlideSegmentLogic scrollViewWidth:_viewContrllerScrollerView.width dataArrayCount:arrayCount];
    self.viewContrllerScrollerView.contentSize=CGSizeMake(sizeWidth, self.height);

    [self addSubview:_viewContrllerScrollerView];
    
    _showCount = arrayCount;
    [self updateLayout];
}


#pragma mark - scrollerViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
        [self.gestrueClashDelegate hp_slideWithGestureClash:NO];
        
    }
    
    [_viewContrllerScrollerView setDelaysContentTouches:NO];
    [_viewContrllerScrollerView setCanCancelContentTouches:NO];
    
    _pageIndex = scrollView.contentOffset.x/_viewContrllerScrollerView.width;
    CGPoint startOffset = CGPointMake(_pageIndex * _viewContrllerScrollerView.width, 0);
    
    [HPSlideSegmentLogic scrollView:_viewContrllerScrollerView
                       currentIndex:_pageIndex
                        startOffset:startOffset
                          dataArray:_showCount
                         boardBlock:^{
                             
                             [self changeWithScrollView:_viewContrllerScrollerView];
                             
                         } moduleBlock:^(NSUInteger nowIndex, NSUInteger readyIndex, CGFloat movePercent) {
                             
                             if ([self.delegate respondsToSelector:@selector(hp_slideWithNowIndex:readyIndex:movePercent:)]) {
                                 
                                 [self.delegate hp_slideWithNowIndex:nowIndex readyIndex:readyIndex movePercent:movePercent];
                                 
                             }
                             
                         }];
    

    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _pageIndex = scrollView.contentOffset.x/_viewContrllerScrollerView.width;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
        [self.gestrueClashDelegate hp_slideWithGestureClash:YES];
        
    }
    
    
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    _pageIndex = scrollView.contentOffset.x/_viewContrllerScrollerView.width;
    
    [self.delegate hp_slideWithNowIndex:_pageIndex readyIndex:_pageIndex movePercent:1];
    
    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {
        
        [self.gestrueClashDelegate hp_slideWithGestureClash:YES];
        
    }
}

-(void)changeWithScrollView:(UIScrollView *)scrollView
{
    CGPoint startOffset = CGPointMake(_pageIndex * _viewContrllerScrollerView.width, 0);

    [HPSlideSegmentLogic slideSuperView:_viewContrllerScrollerView.width
                             scrollView:_viewContrllerScrollerView
                           currentIndex:_pageIndex
                            startOffset:startOffset
                              dataArray:_showCount
                            changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {


                                [self changeStatusLeft:left centre:centre right:right updateCreatNifomation:NO];
                            }];
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


-(void)changeStatusLeft:(HPNumber)left centre:(HPNumber)centre right:(HPNumber)right updateCreatNifomation:(BOOL)update
{


    [self removeWithLayout:_slideLeft];
    [self removeWithLayout:_slideCentre];
    [self removeWithLayout:_slideRight];


    [self.cacheListMange addCacheWithLeft:ObjcWithKeyStructMake(left.number, LEFTTYPE)
                                   Centre:ObjcWithKeyStructMake(centre.number, CENTRETYPE)
                                    Right:ObjcWithKeyStructMake(right.number, RIGHTTYPE)
                            updateContent:update];


}

+(void)layoutWithView:(HPSlideModel *)slideModel cacheSlideModel:(HPSlideModel *)cacheSlideModel pointIndex:(NSUInteger)index
{
    if (cacheSlideModel.showViewController!=nil) {
        slideModel.showViewController=cacheSlideModel.showViewController;
        slideModel.showViewController.view.frame=CGRectMake(0, 0, slideModel.width, slideModel.height);
        slideModel.frame = CGRectMake(index * slideModel.width, 0, slideModel.width, slideModel.height);
        [slideModel addSubview:cacheSlideModel.showViewController.view];
    }
//    [slideModel showViewController:cacheSlideModel.showViewController pointIndex:index];
    slideModel.mainSlideScrollView=cacheSlideModel.mainSlideScrollView;;
}

-(void)removeWithLayout:(HPSlideModel *)slideView
{

    if (slideView==nil) {
        return;
    }

    [slideView.showViewController.view removeFromSuperview];
    slideView.showViewController=nil;
}


-(void)updateLayout:(NSUInteger)pageIndex updateDelegate:(BOOL)update
{

    _pageIndex=[HPSlideSegmentLogic arraCount:_showCount index:pageIndex];

    [HPSlideSegmentLogic currentIndex:_pageIndex
                           arrayCount:_showCount
                           scrollView:_viewContrllerScrollerView
                       slideSuperView:_viewContrllerScrollerView.width
                          changeIndex:^(HPNumber left, HPNumber centre, HPNumber right, CGPoint startPoint) {

                              [self changeStatusLeft:left centre:centre right:right updateCreatNifomation:YES];
                              _viewContrllerScrollerView.contentOffset = CGPointMake(_pageIndex * _viewContrllerScrollerView.width, 0);

                          }];

    if ([self.gestrueClashDelegate respondsToSelector:@selector(hp_slideWithGestureClash:)]) {

        [self.gestrueClashDelegate hp_slideWithGestureClash:YES];

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

-(id)hp_notCahceCreat:(id)cacheObj pageIndex:(NSUInteger)key{
    
    HPSlideModel *cacheSlideModel=cacheObj;
    
    if ([self.dataSource respondsToSelector:@selector(hp_slideListWithViewController:index:)]) {
        
        if (cacheSlideModel==nil) {
            cacheSlideModel=[[HPSlideModel alloc] init];
        }
        
        cacheSlideModel.showViewController = [self.dataSource hp_slideListWithViewController:cacheSlideModel index:key];
        [self getControllerWithScrollView:cacheSlideModel];
        
    }
    
    return cacheSlideModel;
}

-(void)hp_cacheWithLayout:(id)cacheObje direction:(DirectionType)direction page:(NSUInteger)key{
    
    HPSlideModel *cacheSlideModel=cacheObje;
    
    switch (direction) {
        case LEFTTYPE:
        {
            [HPSlideSegmentView layoutWithView:self.slideLeft cacheSlideModel:cacheSlideModel pointIndex:key];
        }
            break;
        case CENTRETYPE:
        {
            [HPSlideSegmentView layoutWithView:self.slideCentre cacheSlideModel:cacheSlideModel pointIndex:key];
        }
            break;
        case RIGHTTYPE:
        {
            [HPSlideSegmentView layoutWithView:self.slideRight cacheSlideModel:cacheSlideModel pointIndex:key];
        }
            break;
        default:
            break;
    }
}

-(void)hp_updateWihtLayotu{
    
    [self currenSlideScrollView];
}



#pragma mark - 监听

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIScrollView *scrollView = (UIScrollView *)object;
    if (self.centreScrollerView == scrollView && [@"contentOffset" isEqualToString:keyPath] && _privateChangeCahePoint != scrollView.contentOffset.y) {

        if ([self.upDelegate respondsToSelector:@selector(hp_currentMainSlideScrollView:)]) {
            _privateChangeCahePoint = scrollView.contentOffset.y;
            [self.upDelegate hp_currentMainSlideScrollView:self.centreScrollerView];

        }

    }
    
}

-(void)getControllerWithScrollView:(HPSlideModel *)slideModel{
    
    for (id object in [slideModel.showViewController.view subviews]) {
        if ([object isKindOfClass:[UIScrollView class]]) {
            UIScrollView * scrollView = (UIScrollView *)object;
            
            if (scrollView.contentSize.height > slideModel.showViewController.view.height) {
                slideModel.mainSlideScrollView = scrollView;
                break;
            }
        }
    }
    
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

-(HPCacheListManage *)cacheListMange
{
    if (_cacheListMange==nil) {
        _cacheListMange=[[HPCacheListManage alloc] init];
        _cacheListMange.delegate=self;
    }
    return _cacheListMange;
}
//
-(HPKVOMange *)kvoMange
{
    if (_kvoMange==nil) {
        _kvoMange=[[HPKVOMange alloc] init];
    }
    return _kvoMange;
}
//
-(HPScrollView *)viewContrllerScrollerView
{
    if (_viewContrllerScrollerView==nil) {
        _viewContrllerScrollerView=[[HPScrollView alloc] init];
        _viewContrllerScrollerView.gestrueType = HPScrollView_Filter_GestureCell;
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

-(id)cacheWithClass:(Class)className initAction:(InitWithActionBlock)actionBlock
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

-(id)cacheWithStoryboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier
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

//-(void)showViewController:(UIViewController *)showViewController pointIndex:(NSUInteger)index
//{
//    if (showViewController==nil) {
//        return;
//    }
//
//    self.showViewController=showViewController;
//    showViewController.view.frame=CGRectMake(0, 0, self.width, self.height);
//    self.frame = CGRectMake(index * self.width, 0, self.width, self.height);
//    [self addSubview:showViewController.view];
//}


@end
