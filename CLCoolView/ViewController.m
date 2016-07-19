//
//  ViewController.m
//  CLCoolView
//
//  Created by ClaudeLi on 16/7/19.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "ViewController.h"
#import "CLImageDragViewController.h"

@interface ViewController (){
    NSMutableArray *_localArray;
    NSArray *_networkArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _localArray = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        [_localArray addObject:[UIImage imageNamed:imageName]];
    }
    
    _networkArray = @[@"http://c.hiphotos.baidu.com/image/pic/item/5bafa40f4bfbfbed91fbb0837ef0f736aec31faf.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/4b90f603738da977772000d7b651f8198618e33b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/6609c93d70cf3bc798e14b10d700baa1cc112a6c.jpg",@"http://b.hiphotos.baidu.com/image/pic/item/0823dd54564e925838c205c89982d158ccbf4e26.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/279759ee3d6d55fb924d52c869224f4a21a4dd50.jpg",@"http://g.hiphotos.baidu.com/image/pic/item/8b82b9014a90f603d51af2a13d12b31bb151edaa.jpg",@"http://d.hiphotos.baidu.com/image/pic/item/8c1001e93901213fabe11ca757e736d12e2e95fe.jpg"];
}
- (IBAction)localAction:(id)sender {
    CLImageDragViewController *imageDrag = [[CLImageDragViewController alloc] init];
    imageDrag.imageArray = _localArray;
    [self.navigationController pushViewController:imageDrag animated:YES];
}
- (IBAction)formNetwork:(id)sender {
    CLImageDragViewController *imageDrag = [[CLImageDragViewController alloc] init];
    imageDrag.imageArray = [_networkArray mutableCopy];
    [self.navigationController pushViewController:imageDrag animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
