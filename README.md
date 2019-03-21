# TBPerformanceView

[![Version](https://img.shields.io/cocoapods/v/TBPerformanceView.svg?style=flat)](https://cocoapods.org/pods/TBPerformanceView)
[![License](https://img.shields.io/cocoapods/l/TBPerformanceView.svg?style=flat)](https://cocoapods.org/pods/TBPerformanceView)
[![Platform](https://img.shields.io/cocoapods/p/TBPerformanceView.svg?style=flat)](https://cocoapods.org/pods/TBPerformanceView)

## Demo

![DEMO](https://github.com/Bintong/TBPerformanceView/blob/master/Mar-21-2019%2013-40-57.gif)

## Use

```
    [[TBPerformanceBoard sharedInstance] createPeroformanceWithDeviceInfo:self.view];
    [[TBPerformanceBoard sharedInstance] open];
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TBPerformanceView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TBPerformanceView'
```

## Author

yaxun_123@163.com

## License

TBPerformanceView is available under the MIT license. See the LICENSE file for more info.



## 中文

### 使用

```
[[TBPerformanceBoard sharedInstance] createPeroformanceWithDeviceInfo：self.view];
[[TBPerformanceBoard sharedInstance] open];
```



方法列表

| 方法名称                                                    | 说明                                        |
| :---------------------------------------------------------- | ------------------------------------------- |
| - (**void**)createPeroformanceBoardUpOnView:(UIView *)view  | 在当前view 上添加普通版本的board            |
| - (**void**)createPeroformanceWithDeviceInfo:(UIView *)view | 在当前view 上添加普通版本的版本号版本的view |
| - (**void**)open;                                           | 开始监听                                    |
| - (**void**)close;                                          | 关闭监听                                    |



### 安装

TBPerformanceView可通过[CocoaPods]（https://cocoapods.org）获得。 安装

```
pod 'TBPerformanceView'
```

### 目前状态

后期迭代，欢迎提供宝贵建议

期望您的star，哈哈哈
