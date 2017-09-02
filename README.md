# HPSlideSegmentView

### Pods 

```
#在podfile 中添加

# iOS 版本要7.0 :platform :ios, ‘7.0’
```
```
pod 'HPSlideSegmentView', '~> 0.1.8'
```


### 创建悬浮效果


在下面的可以看到`HPSlideSegmentControllerView`对应的属性的用途:

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/fundation.png)

### 类结构介绍

```
HPSlideSegmentControllerView (悬浮置顶)
	|
	|__ HPSlideSegmentBackgroundView (左右侧滑)
			|
			|_ HPSlideModuleView  (左右侧滑 管理上面模块)
			|_ HPSlideSegmentView (左右侧滑 管理下面模块)
			
HPSlideSegmentManage (管理两个scrollview滑动)
	|
	|__ HPSlideSegmentControllerView
	
HPSlideSegmentLogic (管理整体逻辑)
	|
	|__ HPSlideSegmentBackgroundView
	|
	|__ HPSlideModuleView
	|
	|__ HPSlideSegmentView
	
HPCacheListManage (管理下面模块 view的缓存问题)
	|
	|__ HPSlideSegmentView
	
HPKVOMange	(管理KVO 的创建和删除)
	|
	|__ HPSlideSegmentView
	
```

#### 属性slideBackgroungView

```
这个属性主要用于管理左右滑动模块
```

- slideModuleView 文字滑动模块
- slideSegmenView 视图滑动模块

#### slideSegmenView 里面的 `cacheMaxCount` 属性

 缓存个数
 小于3默认为3

``` objective-c
@property(nonatomic,assign) NSUInteger cacheMaxCount;
```


### 第一种样式初始化HPSlideSegmentControllerView

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/HPSlideSegmentControllerView.gif)

#### 在 ViewController.h 

``` objective-c

# import "HPSlideSegmentControllerView.h"

@interface DemoViewController : HPSlideSegmentControllerView

@end

```
#### 在 ViewController.m

- 创建headeView	

``` objective-c

UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
headerView.backgroundColor=[UIColor blueColor];

self.headeView=headerView;

//...
//属性设置
//...

[self.slideBackgroungView updateLayout];

```


### 第二种样式初始化HPSlideSegmentBackgroundView

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/HPSlideSegmentBackgroundView.gif)

### 创建

``` objective-c

HPSlideSegmentBackgroundView *slideSegmentBackgroundView=[[HPSlideSegmentBackgroundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
 
[self.view addSubview:slideSegmentBackgroundView];  
    
```

## 实现

#### 数据设置

- 告诉我滑模块的内容 告诉父类的`contents`对象

``` objective-c
//NSString 数据源
self.slideBackgroungView.contents=self.dataSouce;
```

#### 实现对应的代理

- 现在你需要显示多少数据 告诉`<HPSlideSegmentBackgroundDataSource>`代理

``` objective-c
self.slideBackgroungView.dataSource=self;

//代理
-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;//个数
}

```


- 在来需要你要在对应模块中显示什么 告诉`<HPSlideSegmentViewDataSouce>`代理

``` objective-c
self.slideBackgroungView.slideSegmenView.dataSource=self;

//代理
-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    AViewController *aViewController=[slideSegmentView cacheWithClass:[AViewController class] cacheIndex:index initAction:nil];
    
    aViewController.title=self.dataSouce[index];
    slideSegmentView.mainSlideScrollView=aViewController.tabelView;
    slideSegmentView.showViewController=aViewController;
}

如果是使用storyboard

-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    HomeViewController *homeViewController=[slideSegmentView cacheWithStoryboard:self.storyboard identifier:@"HomeViewController" cacheIndex:index];
    [homeViewController.view layoutIfNeeded];//更新一下
    slideSegmentView.mainSlideScrollView=homeViewController.scrollView;
    slideSegmentView.showViewController=homeViewController;

}

```


- 还有需要注意的是在`<HPSlideSegmentViewDataSouce>`代理中

``` objective-c
-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index

```

#### HPSlideModel

- showViewController 

  这个用于显示对应UIViewController
- mainSlideScrollView 

  这个属性 showViewController 上面显示的UIScrollView 这个用于处理手势冲突(如果没有手势冲突问题这个不需要传)




