# AutoLayout

## 概念说明

（1）约束优先级

```swift
约束不仅限于等量关系，它还可以是(>=)或者(<=)来描述两个属性之间的关系，由 NSLayoutRelation 定义。约束还有 1 ~ 1000的优先级，优先级为1000的约束为必须满足，优先级为 1 ~ 999 的约束为可选约束，数字越大其优先级越高，其满足的可能性越高，自动布局系统在满足了所有优先级为 1000 的约束后，会按照优先级从高到低的顺序满足可选约束。默认情况下，所有约束优先级都是 1000，即必须满足。
```



**内部内容尺寸（Intrinsic Content Size）**

```swift
简单来说就是，像按钮、文本标签这类视图控件，在布局的时候，它们自己内部比外部布局代码更清楚自己需要多大的尺寸来显示自己的内容。而这个尺寸就是由内部内容尺寸（intrinsic content size）来传达的。这就相当于，内部内容尺寸告诉布局系统：“这个视图里面包含了一些你不能理解的内容，但是我给你指出了那些内容有多大。”
```



AutoLayout中添加的约束也有优先级,优先级的数值是1~1000。分为两种情况：

- 一种情况是我们经常添加的各种约束,默认的优先级是1000，也就是最高级别，条件允许的话系统会满足我们所有的约束需求。

- 另外一种情况就是固有约束(intinsic content size)，严格来说这个这个更像是指UILabel和UIButton控件的一种属性,但是在AutoLayout中这个属性的取值和约束优先级的属性相结合才能完成图形的绘制。
   我们知道UIButton和UILabel两种控件可以根据内容长短来控制控件宽度，当展示内容的宽度满足不了约束的要求时(过短或者过宽)，控件就会被拉伸或者压缩，当我们不想控件被拉伸或者压缩时，就需要设置控件的固有约束（intinsic content size）来实现我们的需求。固有约束分为两种：

  + 1 ) Content Hugging Priority
     官方文档的解释是
     `Returns the priority with which a view resists being made larger than its intrinsic size.`
     即表示的是控件的抗拉伸优先级，优先级越高，越不易被拉伸，默认为25

    决定是否能够拉伸到大于自身内容尺寸；优先级比较大时，最大尺寸是内容尺寸

  

  使用场景：
   当一个视图上有多个 `intrinsic content size` 的子控件，子视图的总和，不够填充父视图区域时，此属性可以控制优先拉伸哪个视图内容。

  + 2）Content Compression Resistance Priority
     `Returns the priority with which a view resists being made smaller than its intrinsic size.`
     这个优先级的字面意思很明确了，是防压缩优先级，优先级越高，越不易被压缩，默认为750

  ​       决定着是否能压缩到小于自身内容尺寸；优先级大时，最小尺寸是内容尺寸

  

  使用场景：
   当一个视图上有多个 `intrinsic content size` 的子控件，并且子控件可能会超出父视图的区域时，此属性可控制哪些视图被内容被优先压缩，使其不超出父视图区域。



