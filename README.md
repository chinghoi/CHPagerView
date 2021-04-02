# CHPagerView

[![Version](https://img.shields.io/github/v/tag/chinghoi/CHPagerView)](https://cocoapods.org/pods/CHPagerView)
[![License](https://img.shields.io/cocoapods/l/CHPagerView.svg?style=flat)](https://cocoapods.org/pods/CHPagerView)
[![Platform](https://img.shields.io/cocoapods/p/CHPagerView?color=green)](https://cocoapods.org/pods/CHPagerView)

![](https://github.com/chinghoi/CHPagerView/blob/master/demo.gif)

## 说明

为什么要重复造一个轮子？因为有时候只是想开箱即用一个轮播图或者左右滑动的视图，却要写一堆代理，所以写了能简单用一下的库, 可以直接设置数据。
库很轻量，仅有的 AlamofireImage 在1.0版本中也被去除，如使用有什么疑问，欢迎提 Issues。

## 使用方式

要运行示例项目，请克隆存储库，然后首先从Example目录运行`pod install`。

### 基本用法
```swift
let bannerView = CHPagerView()
let images = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
bannerView.setData(images)
```
#### 或者
```swift
let customViews: [UIView] = [UIColor.red, UIColor.yellow, UIColor.green].map {
    let v = UIView()
    v.backgroundColor = $0
    return v
    } 
bannerView.setData(customViews)
```
#### 或者
```swift
let urls = ["https://github.com/chinghoi/CHPagerView/blob/master/png1.png?raw=true",
            "https://github.com/chinghoi/CHPagerView/blob/master/png2.png?raw=true"]
bannerView.setData(urls, placeholder: UIImage(named: "placeholder"))

```
#### 代理
```swift
lazy var bannerViewTwo: CHPagerView = {
    let b = CHPagerView()
    b.delegate = self
    return b
}()

...

func pagerView(_ pagerView: CHPagerView, didSelectItemAt index: Int)
func pagerViewDidEndScroll(_ pagerView: CHPagerView, current index: Int)

```
更多使用方法见 demo。


## 支持设备
- iOS 10.0 or later.
- swift 5 or later.

## 安装

CHPagerView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CHPagerView'
```

## 依赖
~~- [AlamofireImage 4.1+](https://github.com/Alamofire/AlamofireImage)~~

## 支持
- Content edges.
- Set images, custom views or urls.
- Scroll direction: vertical or horizontal.
- Item spacing.
- Can set auto rotation, Is it an infinite loop.
- 如果设置 urls，会缓存加载完成的图片。

## Author

Chinghoi, 56465334@qq.com

## License

CHPagerView is available under the MIT license. See the LICENSE file for more info.
