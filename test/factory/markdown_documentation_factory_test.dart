import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:design_tokens_builder/factory/markdown_documentation_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownDocumentationFactory', () {
    test('generates markdown documentation for simple tokens', () async {
      final builder = markdownDocumentationFactory(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'a|lib/tokenbuilder.yaml': '''
tokenFilePath: lib/tokens.json
defaultSetName: global
''',
          'a|lib/tokens.json': '''
{
  "global": {
    "white": {
      "value": "#ffffff",
      "type": "color"
    },
    "black": {
      "value": "#293133",
      "type": "color"
    },
    "fontSize": {
      "base": {
        "value": "10",
        "type": "fontSizes"
      }
    }
  },
  "\$metadata": {
    "tokenSetOrder": ["global"]
  }
}
''',
        },
        outputs: {
          'a|lib/tokens.md': decodedMatches(
            allOf([
              contains('# Design Tokens Documentation'),
              contains('## Token Set: global'),
              contains('- **global.white**'),
              contains('Type: `color`'),
              contains('Value: `#ffffff`'),
              contains('- **global.black**'),
              contains('Value: `#293133`'),
              contains('- **global.fontSize.base**'),
              contains('Type: `fontSizes`'),
              contains('Value: `10`'),
            ]),
          ),
        },
      );
    });

    test('generates markdown documentation with resolved aliases', () async {
      final builder = markdownDocumentationFactory(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'a|lib/tokenbuilder.yaml': '''
tokenFilePath: lib/tokens.json
defaultSetName: global
''',
          'a|lib/tokens.json': '''
{
  "global": {
    "white": {
      "value": "#ffffff",
      "type": "color"
    },
    "fontSize": {
      "base": {
        "value": "10",
        "type": "fontSizes"
      },
      "scale": {
        "value": "3",
        "type": "fontSizes"
      },
      "sm": {
        "value": "{fontSize.base}+{fontSize.scale}",
        "type": "fontSizes"
      }
    }
  },
  "light": {
    "sys": {
      "background": {
        "value": "{white}",
        "type": "color"
      }
    }
  },
  "\$metadata": {
    "tokenSetOrder": ["global", "light"]
  }
}
''',
        },
        outputs: {
          'a|lib/tokens.md': decodedMatches(
            allOf([
              contains('# Design Tokens Documentation'),
              contains('## Token Set: global'),
              contains('- **global.white**'),
              contains('Value: `#ffffff`'),
              contains('- **global.fontSize.sm**'),
              contains('Value: `13.0`'),
              contains('## Token Set: light'),
              contains('- **light.sys.background**'),
              contains('Value: `#ffffff`'),
            ]),
          ),
        },
      );
    });

    test('generates markdown documentation for multiple token sets', () async {
      final builder = markdownDocumentationFactory(BuilderOptions.empty);

      await testBuilder(
        builder,
        {
          'a|lib/tokenbuilder.yaml': '''
tokenFilePath: lib/tokens.json
defaultSetName: global
''',
          'a|lib/tokens.json': '''
{
  "global": {
    "white": {
      "value": "#ffffff",
      "type": "color"
    }
  },
  "light": {
    "sys": {
      "primary": {
        "value": "#0000FF",
        "type": "color"
      }
    }
  },
  "dark": {
    "sys": {
      "primary": {
        "value": "#000088",
        "type": "color"
      }
    }
  },
  "\$metadata": {
    "tokenSetOrder": ["global", "light", "dark"]
  }
}
''',
        },
        outputs: {
          'a|lib/tokens.md': decodedMatches(
            allOf([
              contains('# Design Tokens Documentation'),
              contains('## Token Set: global'),
              contains('## Token Set: light'),
              contains('## Token Set: dark'),
              contains('- **light.sys.primary**'),
              contains('Value: `#0000FF`'),
              contains('- **dark.sys.primary**'),
              contains('Value: `#000088`'),
            ]),
          ),
        },
      );
    });
  });
}
