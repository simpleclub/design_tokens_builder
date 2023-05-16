<h1 align="center">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://github.com/simpleclub/design_tokens_builder/assets/35028202/6ec91bfa-3124-4430-9ed0-6d616fe5c838">
      <img alt="Logo" src="https://github.com/simpleclub/design_tokens_builder/assets/35028202/0e70832e-78f2-4906-a5b1-940804f2619a">
    </picture>
</h1>

![design_tokens_builder on Pub](https://img.shields.io/pub/v/design_tokens_builder.svg)

A package for generating a flutter `ThemeData` from an exported design token json that is used e.g. [in this Figma plugin](https://tokens.studio/). It rather aims to create a flutter `Theme` 
based on Material 3 than creating a lot of custom widgets for each token.

## Features

Right now we support generating/parsing the following:
- `ColorScheme`
- `TextStyle`
  - Font family mapping (from Figma font name to flutter name)
  - Font weight
  - Line height
  - Font size
  - Letter spacing
  - Text decoration
- Theme extension
  - Custom colors
- Exposing theming and extensions via a `BuildContext` extension

## Getting started

1. Add a `.json` file containing the tokens describing your app design.
2. Add a `tokenbuilder.yaml` configuration file in your `lib` directory
   1. Add the path leading to the json to the configuration file 
   2. Map Figma font names to flutter font family names in configuration file
3. Add this builder to `build.yaml`
```yaml
targets:
  $default:
    builders:
      design_tokens_builder:design_tokens_builder:
        enabled: true
```

## Usage

Before you can use the tokens you have to start the build runner by executing `flutter pub run build_runner build`.
After that just make sure to use one of the `GeneratedTokenSet` for the selected `Brightness` in your `ThemeWidget`.
```dart
return Theme(
  data: GeneratedTokenSet.general.data.dark,
  child: Container(),
);
```
By listening on Brightness changes you could then easily switch between themes. You could also easily change the token set. 

This package also exposes the generated theme extensions by building a `BuildContext` extension. You can use the shortcut like this `context.yourExtension`. We also provide shortcuts for theme related properties like `context.colorScheme` and `context.textTheme`.

## Additional information

### Multi-theming and dark and light mode
The package can generate multiple themes based on multiple [token sets](https://docs.tokens.studio/themes/token-sets) in
your token data json. Every set will be available through a `GeneratedTokenSet`. This enum contains all set pairs and 
`ThemeData` for light and dark themes. In order to specify the brightness of your set use Light/Dark as a suffix in 
design tokens (e.g. yourSetLight, yourSetDark). You also might have a global or core set with universal tokens that do 
not change based on the selected brightness. In that case make sure to call this set `global`. It will be recognised by 
the builder and ignored when creating `GeneratedTokenSets`.

### Generation of flutter `ThemeData`
The package allows for easy and simple generation of flutters `ThemeData`. For doing so, you have to have a certain 
structure for your design tokens. Since this is a system token related to material 3 the tokens used to generate flutters
`ThemeData` should always start with `sys`. If you then e.g. want to set the primary color in flutters `ColorScheme` you
have to add a token called `sys.primary` with type `color` to your json file containing all of your tokens. `primary` is
the name of `ColorScheme`s `primary` field. Keep in mind to exactly write the field names in camel case so the package is
able to recognize them properly. 
For text styles it works similar. Here also use `sys` as the leading part of your token. To better organize the tokens in
Token Studio we decided to split the text style naming. So if you want to generate `displaySmall` text style just use a
`sys.display.small` token of type `typography`.

### Generation of theme extensions
Theme extension are a great way providing custom tokens that are not in flutters `ThemeData` defined. In order to create
a new extension you can just use a different prefix then `sys` for your tokens. Based on that name and the type of the
tokens inside that group an extension will get generated and added to the `ThemeData`. So a custom set of colors called
`custom` in your token json with the type `color` will generate a class `CustomColors` which extends 
`ThemeExtension<CustomColors>`.

### Using math and aliases in your tokens
[Using math operations](https://docs.tokens.studio/tokens/using-math) and [aliases](https://docs.tokens.studio/tokens/aliases) 
in your tokens is supported by the package.

### Tokens Studio for Figma feature parity
Please also see [Tokens Studio for figma documentation](https://docs.tokens.studio/available-tokens/available-tokens).

<details>
    <summary>Expand table</summary>

| Group                   | Parsable | Exposed via Extension |
|-------------------------|----------|-----------------------|
| Sizing                  | ✅        | ❌                     |
| Spacing                 | ❌        | ❌                     |
| Color                   | ✅        | ✅                     |
| Border radius           | ❌        | ❌                     |
| Border width            | ❌        | ❌                     |
| Box shadow              | ❌        | ❌                     |
| Opacity                 | ❌        | ❌                     |
| Font family             | ✅        | ❌                     |
| Font weight             | ✅        | ❌                     |
| Font size               | ✅        | ❌                     |
| Line height             | ✅        | ❌                     |
| Letter spacing          | ✅        | ❌                     |
| Paragraph spacing       | ❌        | ❌                     |
| Text case               | ❌        | ❌                     |
| Text decoration         | ✅        | ❌                     |
| Typography compositions | ✅        | ❌                     |
| Assets                  | ❌        | ❌                     |
| Composition             | ❌        | ❌                     |
| Dimension               | ✅        | ❌                     |
| Border                  | ❌        | ❌                     |

</details>

### Flutter theming
The following table shows which themes the package is able to generate.
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

We want to extend the package to also be able to generate/parse more material themes like `ButtonTheme` etc. We 
also want to add extension for paddings, dimensions and other tokens.

Let us know if you miss something by creating an issue or by actively contributing!

## Contributing

With this open source repositories we want to create a tool that helps Flutter to integrate with more tools to 
streamline and simplify the design handoff experience by utilizing Flutters API. Since this is not only a problem we
face we want to share and collaborate on this software as a way to give back to the
community. Any contributions are more than welcome!

See our [contributing guide](https://github.com/simpleclub/design_tokens_builder/blob/main/CONTRIBUTING.md) for more information.