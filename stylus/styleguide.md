The quick guide
=====

## UI

### Types

UI is a suit of component skin style.I category components UI in five main type:

+ **Basis** - Ordinary component.
+ **Information** - Expressing helpful information.
+ **Safety** - UI is safety or expressing good information.
+ **Danger** - UI is dangerous and side-effect or expressing bad information.
+ **Warning** - Warning user important information.

### States

Normal components is multi-state since UI may contains various persona under different states.There are four main states for each UI:

+ **Normal** - Normal state.
+ **Focused** - Component is foucsed.
+ **Activated** - Component is activated or selected.
+ **Disabled** - Component is disabled.

### Nomenclature

I name a UI in this manner:

    .type-state

The first portion describe UI type and the second one describe UI state modifier name.

If you omit state name.It means that you want UI with all states style with it.

    <!-- Get a button style with basis UI and all states style under it. -->
    <button class="btn basis">Simple Button</button>

    <!-- Get a button style with basis UI in normal state. -->
    <button class="btn basis-static">Simple Button</button>

    <!-- Get a button style with basis Ui in disabled state. -->
    <button class="btn basis-disabeld">Simple Button</button>

### Reusable

The most important thing is that skin style is reusable.It is different with
  layout style the after one can not reuse.There are many CSS properties
describe component skin:

+ color
+ font-*
+ background-*
+ border-*
+ border-radius
+ box-shadow
+ text-shadow
+ text-decoration

We only use CSS properties in above list for UI.In order to ensure UIs
can reuse across the project.

### Override

When we creating a new component.CSS properties in above list can use to
override the default UI style.

    .basis
      color grey

    .btn
      color red

    <button class="btn basis">Button</button>

The `.btn` component used the `color` property.This will override default UI
style `color`.That means all `.btn` components with red color whatever UI hooks on them.The basis UI with `grey` color not workable.

## Modifiers

Modifiers make component varied and graceful.Here is a list of typical
modifiers:

### State Modifiers

Describe components with various skin under different states.

    .btn:active
    .btn:focus
    .btn.is-active
    .btn.is-disabled

### Override Modifiers

Force override specified style.

    .btn.no-border
    .btn.round

### Style Modifiers

This is the key to make components various and graceful.You can change one or more default feature of component and name it.Extend component in this manner is very simple.

    .btn.naked
    .btn.mini
    .link.feel

## Override Modifiers

Override is global modifiers and force to override specified style.I name override in this manner:

    .type-modifier

There are several rules apply to override:

RULE NO.1: **Override can not override each other in different type**.

I divide override in different types.Every override which in different types can not confilict with each other.Every one must unique and no common features.That means you can not use same CSS property in two override which under different type.

But override in same type can use same CSS property because that they would not present in same HTML tag.

    .round
        border-radius 3px

    // different override types confilicted
    .box-round
        border-radius 5px

    // it is does not matter with same type
    .circle
        border-radius 50%

RULE NO.2: **Override can use `important` keyword**.

    .round
        border-radius 3px !important

    .circle
        border-radius 50% !important

## Global Modifiers

Global modifier just like override but not override component default
style. It supply default style.For example:

    .flex-width
        width 100%
        height auto

    <img alt="alt-text" class="flex-width">

Those rules supply basis flexible style for image.The image can
expand/compress width with parent element.But they are repeating override.

So common global modifiers it not recommended.It is better molding
them as template.

## Template

Template is several CSS rules and may used many times.If there are several CSS rules you
use again and again.It is a good sign to molding them as a template.Here is a
template example:

    // reset component outer and inner gap
    $reset-gaped$()
        margin 0
        padding 0

## Components vs Collections

Component is atom of collection.A component is self-contains and only consider
itself.For example `.btn` is a component.It is
unnecessary set `margin` for `.btn` to deal relation with other `.btn`.

Collection is a group of components.It care for relation between two different
components.For example `.board` is a collection.It care for child `.btn` inside
it.The `margin` or sibling `border` style between `.btn`.

## Component Size

+ **Normal Size**

The height of component with normal size equal to `$component-outer-height`.

+ **Mini Size**

The height of component with mini size equal to **Normal Size** height *minus* top and bottom `$gap-v`.

+ **Pygmy Size**

The height of component with extra small size equal to **Mini Size** height *minus* top and bottom `$gap-v`.

+ **Huge Size**
+ **massive Size**

## Component Factory

### $CONTROL

### $BTN

### $LABEL

### $LIST

### $LIST-ITEM
