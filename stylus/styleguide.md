快速指南
=====

## 命名规范 `Naming Conventions`

一般在 HTML 标签的 `class` 属性中定义控件的名字。控件的名字一般遵循**仅使用一个英文单词描述的原则**。比如：

+ `btn`
+ `textfield`
+ `vlist`

修饰器的名字紧随在部件名字之后，同样遵循**仅使用一个英文单词描述的原则**，使用 `--` 同部件名字分隔：

+ `btn--basis`
+ `btn--outline`

## 修饰器 `Modifiers`

### 皮肤 `Theme`

tentomon.css 的控件基本支持五中皮肤设置：

+ `*--basis`
+ `*--info`
+ `*--safe`
+ `*--danger`
+ `*--warn`

### 大小 `Size`

tentomon.css 的控件基本支持五种大小设置：

+ `*--xs`
+ `*--s`
+ `*--m`
+ `*--l`
+ `*--xl`

## 状态 `State`

同 MVCSS 推荐的做法不同，tentomon.css 的状态修饰器在控件的 `data-state` 属性中定义。样式指南中带 `:` 前缀的状态名表示伪类。
