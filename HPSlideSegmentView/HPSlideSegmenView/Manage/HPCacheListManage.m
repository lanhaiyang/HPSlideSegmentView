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
                weakObj:(id)weakObj
          updateContent:(BOOL)update
            layoutBlock:(LayoutBlock)layoutBlock
     notCahceCreatBlock:(CreatBlock)creatBlock
{
    
    
    [self.currentArray removeAllObjects];
    [self addObjeWithNumber:left.keyNum];
    [self addObjeWithNumber:centre.keyNum];
    [self addObjeWithNumber:right.keyNum];
    
    
    [self isCacheWithObj:left
                 weakObj:weakObj
           updateContent:update
             layoutBlock:layoutBlock
      notCahceCreatBlock:creatBlock];
    
    [self isCacheWithObj:centre
                 weakObj:weakObj
           updateContent:update
             layoutBlock:layoutBlock
      notCahceCreatBlock:creatBlock];
    
    [self isCacheWithObj:right
                 weakObj:weakObj
           updateContent:update
             layoutBlock:layoutBlock
      notCahceCreatBlock:creatBlock];
    
    
}

-(void)isCacheWithObj:(ObjcWithKeyStruct)direction
              weakObj:(id)weakObj
        updateContent:(BOOL)update
          layoutBlock:(LayoutBlock)layoutBlock
   notCahceCreatBlock:(CreatBlock)creatBlock
{
    if (direction.keyNum<0) {
        return;
    }
    
    if ([self isCahceWithKey:@(direction.keyNum)]) {
        
        if (update==YES) {
            
            
            id cacheValue=creatBlock(weakObj,[self cacheWithKey:@(direction.keyNum)],direction.keyNum);
            
            if (cacheValue==nil) {
                return;
            }
            
            [self.cacheDictionary setObject:cacheValue forKey:@(direction.keyNum)];
            
        }
        
        if (layoutBlock!=nil) {
            
            layoutBlock(weakObj,[self cacheWithKey:@(direction.keyNum)],direction.directionType,direction.keyNum);
            
        }
        
    }
    else
    {
        if (creatBlock==nil) {
            return;
        }
        
        id cacheValue=creatBlock(weakObj,nil,direction.keyNum);
        
        if (cacheValue==nil) {
            return;
        }
        
        if (self.cacheDictionary.count>=self.cacheListMax) {
            
            [self deleWithAddObj:cacheValue
                         weakObj:weakObj
                          keyNum:direction
                     layoutBlock:layoutBlock];
            
            
        }
        else
        {
            [self.cacheDictionary setObject:cacheValue forKey:@(direction.keyNum)];
            if (layoutBlock!=nil) {
                
                layoutBlock(weakObj,[_cacheDictionary objectForKey:@(direction.keyNum)],direction.directionType,direction.keyNum);
                
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

-(void)deleWithAddObj:(id)cacheObj weakObj:(id)weakObj keyNum:(ObjcWithKeyStruct)direction layoutBlock:(LayoutBlock)layoutBlock
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
                [_delegate removeWithCacheObj:selectObj];
            }
            
            [_cacheDictionary setObject:cacheObj forKey:@(direction.keyNum)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (layoutBlock!=nil) {
                    
                    layoutBlock(weakObj,[_cacheDictionary objectForKey:@(direction.keyNum)],direction.directionType,direction.keyNum);
                    
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

