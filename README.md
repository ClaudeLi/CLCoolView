# CLCoolView
支持图片拖动排序，图片浏览器&lt;类似微信等 带转场动画>

<img src="https://raw.githubusercontent.com/ClaudeLi/CLCoolView/master/Untitled.gif" width="320"><br/>

1.图片拖动排序 collectionView的移动->"CLImageTypesetView"

        // 初始化调用- initWithFrame:CGRectZero
        
        @interface CLImageTypesetView : UICollectionView
        
        // 图片数组
        @property (nonatomic, strong) NSMutableArray *imageArray;
        
        // 选中图片 回调Block
        @property (nonatomic, copy) void(^selectImageBlock)(NSInteger index, NSArray <UIImageView *>* sourceArray);
        
        // 长按图片 回调Block <-- 注：先调用 setLongGesture 添加长按手势 -->
        @property (nonatomic, copy) void(^longGestureBlock)(NSInteger index);
        
        // 移动图片 回调Block <-- 注：先调用 setMoveGesture 添加拖拽手势 -->
        @property (nonatomic, copy) void(^updateArrayBlock)(NSMutableArray *imageArray);
        
        // 设置图片数组, 起始坐标点 CGPointMark(x, y)
        - (void)setImagesWithImageArray:(NSArray *)imageArray point:(CGPoint)point;
        
        // 添加长按手势
        - (void)setLongGesture;
        
        // 添加移动手势
        - (void)setMoveGesture;

2.图片浏览器->“CLImageBrowserController”

        /**
        *  图片浏览器
        *
        *  @param sourceArray 源imageView数组 <-- 需要预览的imageView数组 -->
        *  @param imageArray  图片数组 <-- 本地图片为UIImage数组, 网络图片为图片地址数组 -->
        *  @param index       点击的图片的索引
        *
        */
        - (instancetype)initWithSourceArray:(NSArray <UIImageView *>*)sourceArray imageArray:(NSArray *)imageArray index:(NSInteger)index;

