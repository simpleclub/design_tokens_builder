<h1 align="center">
    <img src="https://github.com/simpleclub/design_tokens_builder/assets/35028202/618f71e9-1b30-4955-b3ae-9708f3b8d22c" alt="Cover image" />
</h1>

![design_tokens_builder on Pub](https://img.shields.io/pub/v/design_tokens_builder.svg)

A package for generating a Flutter `ThemeData` from an exported design token json that is used
e.g. [in this Figma plugin](https://tokens.studio/). It rather aims to create a Flutter `Theme`
based on Material 3 than creating a lot of custom widgets for each token.

## Features

Right now, we support generating/parsing the following:

- `ColorScheme`
- `TextStyle`
    - Font family mapping (from Figma font name to Flutter name)
    - Font weight
    - Line height
    - Font size
    - Letter spacing
    - Text decoration
- Theme extension
    - Borders
    - Border radii
    - Box Shadows
    - Colors
    - Dimensions (also with px)
    - Font families
    - Font weights
    - Line height (only %)
    - Numbers
    - Opacity (also with %)
    - Edge insets
    - Text cases
    - Text decorations
    - Text styles

- Exposing theming and extensions via a `BuildContext` extension

## Getting started

1. Add a `.json` file containing the tokens describing your app design.
2. Add a `tokenbuilder.yaml` configuration
   file ([see example project](https://github.com/simpleclub/design_tokens_builder/blob/main/example/lib/tokenbuilder.yaml))
   in your `lib` directory
    1. Add the path leading to the json to the configuration file
    2. Map Figma font names to Flutter font family names in the configuration file
3. Add this builder to `build.yaml`

```yaml
targets:
  $default:
    builders:
      design_tokens_builder:design_tokens_builder:
        enabled: true
```

## Usage

Before you can use the tokens, you have to start the build runner by
executing `flutter pub run build_runner build`.
After that, just make sure to use one of the `GeneratedTokenSet` for the selected `Brightness` in
your `ThemeWidget`.

```dart
return Theme(
data: GeneratedTokenSet.general.data.dark,
child
:
Container
(
)
,
);
```

By listening to Brightness changes, you could then easily switch between themes. You could also
easily change the token set.

This package also exposes the generated theme extensions by building a `BuildContext` extension. You
can use the shortcut like this `context.yourExtension`. We also provide shortcuts for theme-related
properties like `context.colorScheme` and `context.textTheme`.

## Additional information

### Multi-theming and dark and light mode

The package can generate themes based on
multiple [token sets](https://docs.tokens.studio/themes/token-sets) in
your token data json. Every set will be available through a `GeneratedTokenSet`. This enum contains
all set pairs and
`ThemeData` for light and dark themes. To specify the brightness of your set, use Light/Dark
as a suffix in
design tokens (e.g. yourSetLight, yourSetDark). You also might have a global or core set with
universal tokens that do
not change based on the selected brightness. In that case, make sure to call this set `global`. It
will be recognized by
the builder and ignored when creating `GeneratedTokenSets`.

### Generation of Flutter `ThemeData`

The package allows for the straightforward generation of Flutter's `ThemeData`. To do so, you have
to have a certain
structure for your design tokens. Since this is a system token related to Material 3 the tokens used
to generate Flutter's
`ThemeData` should always start with `sys`. If you then e.g. want to set the primary color in
Flutter's `ColorScheme` you
have to add a token called `sys.primary` with type `color` to your json file containing all of your
tokens. `primary` is
the name of `ColorScheme`s `primary` field. Remember to write the field names in camel case so the
package can recognize them correctly.
For text styles, it works similarly. Here also use `sys` as the leading part of your token. To
better
organize the tokens in
Token Studio, we decided to split the text style naming. So if you want to generate `displaySmall`
text style, just use a
`sys.display.small` token of type `typography`.

### Generation of theme extensions

Theme extensions are a great way of providing custom parameters that are not defined in `ThemeData`
defined. You can
create a new extension using a different prefix than `sys` for your tokens. Based on that
name and the type
of the tokens inside
that [token group](https://docs.tokens.studio/tokens/creating-tokens#token-groups) an extension will
get generated and added to the `ThemeData`. So a custom set of colors
called `custom` in your token json with the type `color` will generate a class `CustomColors` which
extends
`ThemeExtension<CustomColors>`.

_Example token json:_

```json
{
  "light": {
    // <- Token set
    "sys": {
      // <- Token group sys - Used for Flutter ThemeData
      "primary": {
        // <- Token for primary color in ColorScheme
        "value": "#0000FF",
        "type": "color"
      },
      "background": {
        "value": "#FFFFFF",
        "type": "color"
      },
      "onBackground": {
        "value": "#000000",
        "type": "color"
      }
      …
    }
  },
  "$themes": [],
  "$metadata": {
    "tokenSetOrder": [
      "light"
    ]
  }
}
```

### Using math and aliases in your tokens

[Using math operations](https://docs.tokens.studio/tokens/using-math)
and [aliases](https://docs.tokens.studio/tokens/aliases)
in your tokens is supported by the package.

### Tokens Studio for Figma feature parity

Please also
see [Tokens Studio for figma documentation](https://docs.tokens.studio/available-tokens/available-tokens)
.

<details>
    <summary>Expand table</summary>

| Group                   | Parsable | Exposed via Extension |
|-------------------------|----------|-----------------------|
| Sizing                  | ✅        | ✅                     |
| Spacing                 | ✅        | ✅                     |
| Color                   | ✅        | ✅                     |
| Border radius           | ✅        | ✅                     |
| Border width            | ✅        | ✅                     |
| Box shadow              | ✅        | ✅                     |
| Opacity                 | ✅        | ✅                     |
| Font family             | ✅        | ✅                     |
| Font weight             | ✅        | ✅                     |
| Font size               | ✅        | ✅                     |
| Line height             | ✅        | ✅                     |
| Letter spacing          | ✅        | ✅                     |
| Paragraph spacing       | ✅        | ✅                     |
| Text case               | ✅        | ✅                     |
| Text decoration         | ✅        | ✅                     |
| Typography compositions | ✅        | ✅                     |
| Assets                  | ❌        | ❌                     |
| Composition             | ❌        | ❌                     |
| Dimension               | ✅        | ✅                     |
| Border                  | ✅        | ✅                     |

</details>

### Flutter theming

The following table shows which themes the package can generate.
<details>
    <summary>Expand table</summary>

| Properties                  | Supported |
|-----------------------------|-----------|
| `colorScheme`               | ✅         |
| `iconTheme`                 | ❌         |
| `textTheme`                 | ✅         |
| `appBarTheme`               | ❌         |
| `badgeTheme`                | ❌         |
| `bannerTheme`               | ❌         |
| `bottomAppBarTheme`         | ❌         |
| `bottomNavigationBarTheme`  | ❌         |
| `bottomSheetTheme`          | ❌         |
| `buttonBarTheme`            | ❌         |
| `buttonTheme`               | ❌         |
| `cardTheme`                 | ❌         |
| `checkboxTheme`             | ❌         |
| `chipTheme`                 | ❌         |
| `dataTableTheme`            | ❌         |
| `datePickerTheme`           | ❌         |
| `dialogTheme`               | ❌         |
| `dividerTheme`              | ❌         |
| `drawerTheme`               | ❌         |
| `dropdownMenuTheme`         | ❌         |
| `elevatedButtonTheme`       | ❌         |
| `expansionTileTheme`        | ❌         |
| `filledButtonTheme`         | ❌         |
| `floatingActionButtonTheme` | ❌         |
| `iconButtonTheme`           | ❌         |
| `listTileTheme`             | ❌         |
| `menuBarTheme`              | ❌         |
| `menuButtonTheme`           | ❌         |
| `menuTheme`                 | ❌         |
| `navigationBarTheme`        | ❌         |
| `navigationDrawerTheme`     | ❌         |
| `navigationRailTheme`       | ❌         |
| `outlinedButtonTheme`       | ❌         |
| `popupMenuTheme`            | ❌         |
| `progressIndicatorTheme`    | ❌         |
| `radioTheme`                | ❌         |
| `searchBarTheme`            | ❌         |
| `searchViewTheme`           | ❌         |
| `segmentedButtonTheme`      | ❌         |
| `sliderTheme`               | ❌         |
| `snackBarTheme`             | ❌         |
| `switchTheme`               | ❌         |
| `tabBarTheme`               | ❌         |
| `textButtonTheme`           | ❌         |
| `textSelectionTheme`        | ❌         |
| `timePickerTheme`           | ❌         |
| `toggleButtonsTheme`        | ❌         |
| `tooltipTheme`              | ❌         |

</details>

## Future capabilities

We want to extend the package also to be able to generate/parse more material themes
like `ButtonTheme` etc.

Let us know if you miss something by creating an issue or by actively contributing!

## Contributing

With this open-source repository, we want to create a tool that helps Flutter integrate with
more tools to
streamline and simplify the design handoff experience by utilizing Flutter's API. Since this is not
only a problem we
face, we want to share and collaborate on this software to give back to the
community. Any contributions are more than welcome!

See
our [contributing guide](https://github.com/simpleclub/design_tokens_builder/blob/main/CONTRIBUTING.md)
for more information.
