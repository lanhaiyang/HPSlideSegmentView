//
//  HPCacheListManage.m
//  HPSlideSegmentView
//
//  Created by 何鹏 on 17/7/14.
//  Copyright © 2017年 何鹏. All rights reserved.
//

#import "HPCacheListManage.h"

@interface HPCacheListManage ()

@property(nonatomic,strong) NSMutableDictionary *cacheDictionary;

@property(nonatomic,strong) dispatch_queue_t cahceQueue;

@property(nonatomic,strong) NSMutableArray *currentArray;

@end



@implementation HPCacheListManage

-(instancetype)init
{
    if (self=[super init]) {
        
        _cahceQueue=dispatch_queue_create("hpSlideSegamentView.hepeng.slide", NULL);
        
    }
    return self;
}

-(void)addCacheWithLeft:(ObjcWithKeyStruct)left
                 Centre:(ObjcWithKeyStruct)centre
                  Right:(ObjcWithKeyStruct)right
          updateContent:(BOOL)update
{
    
    
    [self.currentArray removeAllObjects];
    [self addObjeWithNumber:left.keyNum];
    [self addObjeWithNumber:centre.keyNum];
    [self addObjeWithNumber:right.keyNum];
    
    
    [self isCacheWithObj:left
           updateContent:update];
    
    [self isCacheWithObj:centre
           updateContent:update];
    
    [self isCacheWithObj:right
           updateContent:update];
    
    if ([_delegate respondsToSelector:@selector(hp_updateWihtLayotu)]) {
        [_delegate hp_updateWihtLayotu];
    }
}

-(void)isCacheWithObj:(ObjcWithKeyStruct)direction
        updateContent:(BOOL)update
{
    if (direction.keyNum<0) {
        return;
    }
    
    if ([self isCahceWithKey:@(direction.keyNum)]) {
        
        if (update==YES) {
            
            
            id cacheValue = nil;
            
            if ([_delegate respondsToSelector:@selector(hp_notCahceCreat:pageIndex:)]) {
                cacheValue = [_delegate hp_notCahceCreat:[self cacheWithKey:@(direction.keyNum)] pageIndex:direction.keyNum];
            }
            
            if (cacheValue==nil) {
                return;
            }
            
            [self.cacheDictionary setObject:cacheValue forKey:@(direction.keyNum)];
            
        }

        if ([_delegate respondsToSelector:@selector(hp_cacheWithLayout:direction:page:)]) {
            [_delegate hp_cacheWithLayout:[self cacheWithKey:@(direction.keyNum)] direction:direction.directionType page:direction.keyNum];
        }
        
        
    }
    else
    {

        id cacheValue=nil;
        
        if ([_delegate respondsToSelector:@selector(hp_notCahceCreat:pageIndex:)]) {
            cacheValue = [_delegate hp_notCahceCreat:nil pageIndex:direction.keyNum];
        }
        
        if (cacheValue==nil) {
            return;
        }
        
        if (self.cacheDictionary.count>=self.cacheListMax) {
            
            [self deleWithAddObj:cacheValue
                          keyNum:direction];
            
            
        }
        else
        {
            [self.cacheDictionary setObject:cacheValue forKey:@(direction.keyNum)];
            
            if ([_delegate respondsToSelector:@selector(hp_cacheWithLayout:direction:page:)]) {
                [_delegate hp_cacheWithLayout:[_cacheDictionary objectForKey:@(direction.keyNum)] direction:direction.directionType page:direction.keyNum];
            }
        }
        
        
    }
}


-(void)addObjeWithNumber:(NSInteger)number
{
    if (number<0) {
        return;
    }
    [_currentArray addObject:@(number)];
}

-(void)deleWithAddObj:(id)cacheObj keyNum:(ObjcWithKeyStruct)direction
{
    
    dispatch_async(self.cahceQueue, ^{
        
        id selectObj=nil;
        NSNumber *numberMax=nil;
        NSUInteger maxNumber=0;
        NSArray *keys=_cacheDictionary.allKeys;
        
        for (int i=0; i<keys.count; i++) {
            
            if (![_currentArray containsObject:keys[i]]) {
                NSNumber *num=keys[i];
                NSUInteger number=[self abs:(num.unsignedIntegerValue-direction.keyNum)];
                
                if (number>maxNumber) {
                    maxNumber=number;
                    selectObj=[_cacheDictionary objectForKey:keys[i]];
                    numberMax=keys[i];
                }
                
                
            }
            
        }
        
        if (selectObj!=nil && cacheObj!=nil && numberMax!=nil) {
            [_cacheDictionary removeObjectForKey:numberMax];
            
            if ([_delegate respondsToSelector:@selector(removeWithCacheObj:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate removeWithCacheObj:selectObj];
                });
            }
            
            [_cacheDictionary setObject:cacheObj forKey:@(direction.keyNum)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                
                if ([_delegate respondsToSelector:@selector(hp_cacheWithLayout:direction:page:)]) {
                    [_delegate hp_cacheWithLayout:[_cacheDictionary objectForKey:@(direction.keyNum)] direction:direction.directionType page:direction.keyNum];
                }
                
                if ([_delegate respondsToSelector:@selector(hp_updateWihtLayotu)]) {
                    [_delegate hp_updateWihtLayotu];
                }
                
                
            });
            
        }
        
        
        
    });
    
}


-(NSUInteger)abs:(NSInteger)number
{
    if (number<0) {
        return number * -1;
    }
    return number;
}


-(id)cacheWithKey:(id)key
{
    if (key==nil) {
        return nil;
    }
    
    id model=[self.cacheDictionary objectForKey:key];
    
    return model;
}

-(BOOL)isCahceWithKey:(id)key
{
    if (key==nil) {
        return NO;
    }
    
     id model=[self.cacheDictionary objectForKey:key];
    if (model==nil) {
        return NO;
    }
    
    return YES;
}


#pragma mark 懒加载

-(NSUInteger)cacheListMax
{
    if (_cacheListMax<3) {
        return 3;
    }
    return _cacheListMax;
}

-(NSMutableDictionary *)cacheDictionary
{
    if (_cacheDictionary==nil) {
        _cacheDictionary=[NSMutableDictionary dictionary];
    }
    return _cacheDictionary;
}

-(NSMutableArray *)currentArray
{
    if (_currentArray==nil) {
        _currentArray=[NSMutableArray array];
    }
    return _currentArray;
}

@end

