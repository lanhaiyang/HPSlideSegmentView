//
//  HPSlideView.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/6/12.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPSlideModuleView.h"
#import "HPSlideSegmentLogic.h"
#import "UIView+HPSlideSegmentRect.h"
#import <objc/runtime.h>

@interface HPSlideModuleView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *backgroundView;

@property(nonatomic,strong) NSMutableArray<UIButton *> *arrayButtons;

@property(nonatomic,weak) id hpWeakObj;
@property(nonatomic,strong) HPSLIDEMODULBUTTONBLOCK hpActionBlock;

@end

@implementation HPSlideModuleView


-(instancetype)initWithFrame:(CGRect)frame 
{
    if (self=[super initWithFrame:frame]) {
        self.hiddenModule=NO;
        [self layoutSlideModule];
    }
    return self;
}

-(void)updateLayout
{
//    for (int i=0; i<self.arrayButtons.count; i++) {
//        
//        UIButton *button=_arrayButtons[i];
//        [button removeFromSuperview];
//        
//    }
//    [self.arrayButtons removeAllObjects];
    self.scrollView.contentSize=CGSizeMake(0, 0);
    [self layoutSlideModule];
}

-(void)layoutSlideModule
{
    self.scrollView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:_scrollView];

    [_scrollView addSubview:self.backgroundView];
    
    [self scrollViewLayoutWithCount:self.showCount
                         casheArray:self.arrayButtons
                    delegateContent:_delegate
                         layoutView:self
                       moduleHeight:self.bounds.size.height];
    
    self.backgroundColor=[UIColor whiteColor];
    self.slideModuleColor=_slideModuleColor;
    self.slideModuleView=_slideModuleView;
    
    [self buttonAction:_arrayButtons];
    [self slideModuleLayout];
    
}


-(void)slideModuleLayout
{
    UIButton *defaultButton=nil;
    if (self.arrayButtons.count!=0) {
        defaultButton=self.arrayButtons[0];
    }
    self.slideModuleView.backgroundColor=self.slideModuleColor;
    self.slideModuleView.frame=[HPSlideSegmentLogic slideModuleWithView:self.slideModuleView.bounds.size.height
                                                        slideViewHeight:self.bounds.size.height
                                                           defauleWidth:defaultButton.bounds.size.width
                                                            buttonWithX:defaultButton.x];
    
    [HPSlideSegmentLogic animationSlideView:self.slideModuleView
                           slideModuleWidht:_slideModeuleWidth
                                   nowPoint:HPPointMake(defaultButton.x, defaultButton.width)
                                readyButton:HPPointMake(defaultButton.x, defaultButton.width)
                                movePercent:0];
    
    
    [self.backgroundView insertSubview:_slideModuleView atIndex:0];
    
}

-(void)buttonAction:(NSArray<UIButton *> *)arrayButtons
{
    for (int i=0; i<arrayButtons.count; i++) {
        
        UIButton *button=arrayButtons[i];
        [button addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)hp_weak:(id)weakObj actionButton:(HPSLIDEMODULBUTTONBLOCK)actionBlock
{
    _hpWeakObj=weakObj;
    _hpActionBlock=actionBlock;
}

-(void)updateLayoutWithIndex:(NSUInteger)index
{
    UIButton *button=[HPSlideSegmentLogic isArrayWithNil:_arrayButtons index:index];
    
    [self actionButton:button];
    
}

-(void)actionButton:(UIButton *)button
{
    if (_hpActionBlock!=nil) {
        [self selectButton:button];

        
        [HPSlideSegmentLogic animationSlideView:self.slideModuleView
                               slideModuleWidht:_slideModeuleWidth
                                       nowPoint:HPPointMake(button.x, button.width)
                                    readyButton:HPPointMake(button.x, button.width)
                                    movePercent:0];
        
        
//        CGFloat x=button.x;
//
//        self.slideModuleView.frame=CGRectMake(x, self.slideModuleView.y, button.width, self.slideModuleView.height);
        _hpActionBlock(_hpWeakObj,button.index);
        
        
        [HPSlideSegmentLogic slideModuleAlignCenter:self.scrollView
                                   slideModuleWithX:self.slideModuleView.x];
    }
}

-(void)slideBetweenWithButton:(UIButton *)button
{
    if (button.x-self.width/2>0) {
        if (_scrollView.contentOffset.x+self.width<_scrollView.contentSize.width) {
            _scrollView.contentOffset=CGPointMake(button.x-self.width/2, 0);
        }
    }
    else{
        
        _scrollView.contentOffset=CGPointMake(0, 0);
        
    }
}

-(void)slideWithNowIndex:(NSUInteger)nowIndex readyIndex:(NSUInteger)readyIndex movePercent:(CGFloat)movePercent
{
    
    UIButton *nowButton=_arrayButtons[nowIndex];
    UIButton *readyButton=_arrayButtons[readyIndex];

    [HPSlideSegmentLogic animationSlideView:self.slideModuleView
                           slideModuleWidht:_slideModeuleWidth
                                   nowPoint:HPPointMake(nowButton.x, nowButton.width)
                                readyButton:HPPointMake(readyButton.x, readyButton.width)
                                movePercent:movePercent];
    
    [HPSlideSegmentLogic slideModuleAlignCenter:self.scrollView
                               slideModuleWithX:self.slideModuleView.x];
    
    
    [self selectButton:readyButton];
    
}


-(void)scrollViewLayoutWithCount:(NSUInteger )count
                      casheArray:(NSMutableArray<UIButton *> *)arrayButtons
                 delegateContent:(id)delegate
                      layoutView:(HPSlideModuleView *)moduleView
                    moduleHeight:(CGFloat)height
{
    for (int i=0; i<count; i++) {
        
//        UIButton *module=[self creatModule:i
//                                casheArray:arrayButtons
//                           delegateContent:delegate
//                              moduleHeight:height];
        
         UIButton *module=[self cacheButton:arrayButtons
                             getCacheButton:i
                            delegateContent:delegate
                               moduleHeight:height];
        

        if (count-1==i) {
            CGFloat widthAddY=module.width+module.x;
            
            moduleView.scrollView.contentSize=CGSizeMake(widthAddY, 0);
            
        }
        
        if (_backgroundSelectColor!=nil && i==0) {
            module.backgroundColor=_backgroundSelectColor;
        }
        else if(_backgroundDefaultColor!=nil)
        {
            module.backgroundColor=_backgroundDefaultColor;
        }
        
        moduleView.backgroundView.frame=CGRectMake(0, 0, moduleView.scrollView.contentSize.width,moduleView.scrollView.height);
        
        [moduleView.backgroundView addSubview:module];
        module.index=i;
        module=nil;
        
    }
}

-(UIButton *)cacheButton:(NSMutableArray<UIButton *> *)arrayButtons
          getCacheButton:(NSUInteger)index
         delegateContent:(id)delegate
            moduleHeight:(CGFloat)height
{
    
    UIButton *currenButton=[HPSlideSegmentLogic isArrayWithNil:arrayButtons index:index];
    
    if (currenButton==nil) {
        
        return [self creatModule:index
                      casheArray:arrayButtons
                 delegateContent:delegate
                    moduleHeight:height];
        
    }
    
    UIButton *oldButton=[HPSlideSegmentLogic arrayCount:arrayButtons index:index-1];
    
    return [self buttonLayoutWithOldButton:oldButton
                          newButton:currenButton
                       moduleHeight:height
                      buttonContent:currenButton.titleLabel.text];
    
}

-(UIButton *)creatModule:(NSUInteger)index
              casheArray:(NSMutableArray<UIButton *> *)arrayButtons
         delegateContent:(id)delegate
            moduleHeight:(CGFloat)height
{
    UIButton *module=nil;
    
    NSString *content=@"";
    
    if ([delegate respondsToSelector:@selector(hp_slideContentWithIndex:)]) {
        
        content=[delegate hp_slideContentWithIndex:index];
        
    }
    
    if ([delegate respondsToSelector:@selector(hp_slideWithIndex:)]) {
        
        module=[delegate hp_slideWithIndex:index];
        
    }
    else
    {
        module=[[UIButton alloc] init];
    }
    
    [module setTitle:content forState:UIControlStateNormal];
    [module setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    module.titleLabel.font=[UIFont systemFontOfSize:14];
    
    UIButton *oldButton=[HPSlideSegmentLogic arrayCount:arrayButtons index:index-1];
    
//    module.frame=[HPSlideSegmentLogic oldButtonPoint:HPPointMake(oldButton.frame.origin.x, oldButton.bounds.size.width)
//                                     slideViewHeight:height
//                                             content:content
//                                            fontSize:module.titleLabel.font.pointSize
//                                          spaceWidth:10];

    module = [self buttonLayoutWithOldButton:oldButton
                                   newButton:module
                                moduleHeight:height
                               buttonContent:content];
    
    [arrayButtons addObject:module];
    
    content=nil;
    return module;
}

-(UIButton *)buttonLayoutWithOldButton:(UIButton *)oldButton
                             newButton:(UIButton *)module
                          moduleHeight:(CGFloat)height
                         buttonContent:(NSString *)content
{
    module.frame=CGRectMake(0, 0, 0, 0);
    
    module.frame=[HPSlideSegmentLogic oldButtonPoint:HPPointMake(oldButton.frame.origin.x, oldButton.bounds.size.width)
                                     slideViewHeight:height
                                            isModule:self.hiddenModule
                                             content:content
                                            fontSize:module.titleLabel.font.pointSize
                                          edgeInsets:self.edgeInsets
                                            minWidth:self.minWidth
                                            autoType:self.type];
    
    return module;
    
}

-(void)selectButton:(UIButton *)selectButton
{
    for (int i=0; i<_arrayButtons.count; i++) {
        UIButton *button=_arrayButtons[i];
        if (button==selectButton) {
            
            if (_backgroundSelectColor!=nil) {
                button.backgroundColor=_backgroundSelectColor;
            }
            
            button.selected=YES;
        }
        else
        {
            
            if (_backgroundDefaultColor!=nil) {
                button.backgroundColor=_backgroundDefaultColor;
            }
            
            button.selected=NO;
        }
    }
}

#pragma mark - 懒加载

-(void)setBackgroundDefaultColor:(UIColor *)backgroundDefaultColor
{
    _backgroundDefaultColor=backgroundDefaultColor;
    [self updateLayout];
}

-(void)setBackgroundSelectColor:(UIColor *)backgroundSelectColor
{
    _backgroundSelectColor=backgroundSelectColor;
    [self updateLayout];
}

-(void)setDelegate:(id<SlideModuleViewDelegate>)delegate
{
    
    _delegate=delegate;
    
    for (int i=0; i<self.arrayButtons.count; i++) {
        
        UIButton *button=_arrayButtons[i];
        [button removeFromSuperview];
        
    }
    [self.arrayButtons removeAllObjects];
    
    [self updateLayout];
}

-(void)setHiddenModule:(BOOL)hiddenModule
{
    _hiddenModule=hiddenModule;
    
    if (hiddenModule==YES) {
        
        [_slideModuleView removeFromSuperview];
        _slideModuleView=nil;
        [self updateLayout];
    }
}

-(void)setEdgeInsets:(UIEdgeInsets)edgeInsets
{
    _edgeInsets=edgeInsets;
    
    [self updateLayout];
}

-(void)setMinWidth:(CGFloat)minWidth
{

    _minWidth=minWidth;
    
    [self updateLayout];
    
}

-(void)setType:(AutoSizeType)type
{

    _type=type;
    
    [self updateLayout];
    
}

-(void)setShowCount:(NSUInteger)showCount
{
    _showCount=showCount;
    
    [self updateLayout];
    
}

-(UIScrollView *)scrollView
{
    if (_scrollView==nil) {
        _scrollView=[[UIScrollView alloc] init];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.delegate=self;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
    }
    return _scrollView;
}


-(void)setSlideModuleView:(UIView *)slideModuleView
{
    if (self.hiddenModule==YES) {
        
        [_slideModuleView removeFromSuperview];
        _slideModuleView=nil;
        _slideModuleView=slideModuleView;
        
        return;
    }
    
    if (slideModuleView==nil) {
        
        _slideModuleView=[[UIView alloc] init];
        self.slideModuleColor=_slideModuleColor;
        _slideModuleView.backgroundColor=self.slideModuleColor;
        _slideModuleView.frame=CGRectMake(0, 0, 10, 3);
        
    }
    else
    {

        self.slideModuleColor=slideModuleView.backgroundColor;
        [self slideModuleLayout];
    }
}

-(void)setSlideModuleColor:(UIColor *)slideModuleColor
{
    if (slideModuleColor==nil ) {
        _slideModuleColor=[UIColor redColor];
    }
    else
    {
        _slideModuleColor=slideModuleColor;
        [self slideModuleLayout];
    }
}

-(UIView *)backgroundView
{
    if (_backgroundView==nil) {
        _backgroundView=[[UIView alloc] init];
        _backgroundView.backgroundColor=[UIColor clearColor];
    }
    return _backgroundView;
}

-(NSMutableArray<UIButton *> *)arrayButtons
{
    if (_arrayButtons==nil) {
        _arrayButtons=[NSMutableArray array];
    }
    return _arrayButtons;
}

@end

#pragma mark - HPSlideSegment

static void *indexKey = &indexKey;

@implementation UIButton (HPSlideSegment)

-(void)setIndex:(NSUInteger)index
{
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSUInteger)index
{
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
