Tentomon
===

## Code Tree

+ Foundation
+ Base
+ Layout
+ Placeholder
+ Module

## Base

## Layout

## Placeholder

Placeholder is public skin or layout snippet.Module will extend those snippets.

    // stylus/placeholder/ui.styl
    $ui-primary
        // public primary ui

    $ui-safty
        // public safety ui

    // stylus/placeholder/measure.styl
    $l-pygmy
        // public pygmy size layout

    $l-massive
        // public massive size layout

    // stylus/modules/btn/btn.styl
    .btn
        &.l-pygmy
            @extend $l-pygmy
        &.l-massive
            @extend $l-massive

    // stylus/modules/btn/btn-ui.styl
    .btn
        &.ui-primary
            @extend $ui-primary

        &.ui-safty
            @extend $ui-safty

## Module

### Core

Describe sub components, layout of specific module.

    .btn
        // core component style

    .btn-text
        // sub component style

### Skin

Describe component skin named with `ui` as prefix.

    .btn
        // default button skin

        &.ui-link
            // btn looks like a link

        &.ui-glyph
            // btn looks like ordinary string

### State

Describe what should particular skin looks like or layout changes under various states.

    .btn:active
    .btn.is-active
        // layout changes style

        &.ui-link
            // how activated button looks with ui-link

        &.ui-glyph
            // how activated button looks with ui-glyph
