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

- Explain how `sys` tokens work
- Explain how extensions work
- Explain how math works https://docs.tokens.studio/tokens/using-math

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
