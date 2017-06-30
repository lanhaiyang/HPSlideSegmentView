# HPSlideSegmentView

### 创建悬浮效果

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/HPSlideSegmentControllerView.gif)

在下面的可以看到`HPSlideSegmentControllerView`对应的属性的用途:

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/fundation.png)

#### 属性slideBackgroungView

```
这个属性主要用于管理左右滑动模块
```

- slideModuleView 文字滑动模块
- slideSegmenView 视图滑动模块

#### 初始化HPSlideSegmentControllerView

##### 在 ViewController.h 

``` objective-c

# import "HPSlideSegmentControllerView.h"

@interface DemoViewController : HPSlideSegmentControllerView

@end

```
#### 在 ViewController.m

- 创建headeView	

```objective-c

UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
headerView.backgroundColor=[UIColor blueColor];

self.header=headerView;

```


#### 初始化HPSlideSegmentBackgroundView

![image](https://github.com/lanhaiyang/HPSlideSegmentView/blob/master/README/HPSlideSegmentBackgroundView.gif)

### 创建

```objective-c

HPSlideSegmentBackgroundView *slideSegmentBackgroundView=[[HPSlideSegmentBackgroundView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
 
[self.view addSubview:slideSegmentBackgroundView];  
    
```

### 实现

#### 实现对应的代理

- 在来需要告诉我 滑模块 的内容 需要对应父类的`contents`对象

```objective-c
//NSString 数据源
self.slideBackgroungView.contents=self.dataSouce;
```

- 现在你需要显示多少数据 告诉`<HPSlideSegmentBackgroundDataSource>`代理

```objective-c
self.slideBackgroungView.dataSource=self;

//代理
-(NSUInteger)hp_slideListWithCount
{
    return self.dataSouce.count;//个数
}

```


- 在需要你要在对应模块中显示什么 告诉`<HPSlideSegmentViewDataSouce>`代理

```objective-c
self.slideBackgroungView.slideSegmenView.dataSource=self;

//代理
-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index
{
    AViewController *aViewController=[[AViewController alloc] init];
    
    aViewController.title=self.dataSouce[index];
    slideSegmentView.mainSlideScrollView=aViewController.tabelView;
    slideSegmentView.showViewController=aViewController;
}
```

- 还有需要注意的是在`<HPSlideSegmentViewDataSouce>`代理中

```objective-c
-(void )hp_slideListWithViewController:(HPSlideModel *)slideSegmentView index:(NSUInteger)index

```

#### HPSlideModel

- showViewController 

  这个用于显示对应UIViewController
- mainSlideScrollView 

  这个属性 showViewController 上面显示的UIScrollView 这个用于处理手势冲突(如果没有手势冲突问题这个需要传)




