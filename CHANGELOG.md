## 0.3.0

* **Breaking:** The generated code imports the standalone
  [`material_ui`](https://pub.dev/packages/material_ui) package instead of the
  in-framework Material library, which Flutter 3.50 deprecates. Projects that
  run the builder must depend on `material_ui` (`flutter pub add material_ui`).
  See the
  [migration guide](https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui).

## 0.2.0+1

* Improve package documentation.

## 0.2.0

* Adds support for most of Tokens Studio for Figma token types.
* Introduces a new `defaultSetName` property in `tokenbuilder.yaml` to configure the default set.

* Adds generation of theme extension based on `defaultSetName`.
* Adds new architecture for managing type parsers more easily.

## 0.1.0

* Adds the capability of generating colors, text styles, custom theme extensions and `ThemeData`
  from a design token studio exported .json file.
