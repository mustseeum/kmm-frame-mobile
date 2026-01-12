# Theme System Guide

## Overview
This app now uses a comprehensive Material 3 theme system that automatically applies colors, typography, and component styles throughout the app. You no longer need to manually set background colors, button styles, or text colors in most cases.

## How to Use Themes

### Accessing Theme Colors
Instead of using `AppColors` directly, use `Theme.of(context)`:

```dart
// ❌ Old way - DON'T DO THIS
Container(
  color: AppColors.fountainBlue500,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.osloGray900),
  ),
)

// ✅ New way - DO THIS
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    color: theme.colorScheme.primary,
    child: Text(
      'Hello',
      style: theme.textTheme.bodyLarge,
    ),
  );
}
```

## Color Scheme

### Primary Colors (Teal/Cyan)
- `primary` (p500): Main brand color - #44A8A9
- `onPrimary`: Text/icons on primary color
- `primaryContainer`: Lighter primary for containers
- `onPrimaryContainer`: Text on primary containers

### Secondary Colors (Dark Blue)
- `secondary` (sG300): Secondary brand color - #141C48
- `onSecondary`: Text/icons on secondary
- `secondaryContainer`: Light secondary backgrounds
- `onSecondaryContainer`: Text on secondary containers

### Tertiary Colors (Yellow/Gold)
- `tertiary` (a300b): Accent yellow - #FFDE59
- `onTertiary`: Text on tertiary
- `tertiaryContainer`: Light yellow backgrounds
- `onTertiaryContainer`: Text on tertiary containers

### Surface & Background
- `surface`: Card and component backgrounds (white in light mode)
- `onSurface`: Text and icons on surfaces
- `scaffoldBackgroundColor`: Main screen background (#F3F4F8 in light mode)

### Functional Colors
- `error` (r400): Error states - #FF4D57
- `success` (g400): Success states - #38B27D
- `warning` (o400): Warning states - #FF9F1C

## Typography

The theme includes comprehensive text styles:

```dart
// Display (largest)
theme.textTheme.displayLarge    // 57px, bold
theme.textTheme.displayMedium   // 45px, bold
theme.textTheme.displaySmall    // 36px, bold

// Headline
theme.textTheme.headlineLarge   // 32px, bold
theme.textTheme.headlineMedium  // 28px, bold
theme.textTheme.headlineSmall   // 24px, w600

// Title
theme.textTheme.titleLarge      // 22px, w600
theme.textTheme.titleMedium     // 16px, w600
theme.textTheme.titleSmall      // 14px, w600

// Body
theme.textTheme.bodyLarge       // 16px
theme.textTheme.bodyMedium      // 14px
theme.textTheme.bodySmall       // 12px

// Label
theme.textTheme.labelLarge      // 14px, w600
theme.textTheme.labelMedium     // 12px, w500
theme.textTheme.labelSmall      // 11px, w500
```

### Using Text Styles

```dart
Text(
  'Heading',
  style: theme.textTheme.headlineMedium,
)

// Override specific properties
Text(
  'Custom',
  style: theme.textTheme.bodyLarge?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.bold,
  ),
)
```

## Components

### Buttons

#### ElevatedButton (Primary Action)
Automatically styled with primary color background:

```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Continue'),
)
// No need to style - uses theme automatically!
```

#### OutlinedButton (Secondary Action)
Automatically styled with primary color border:

```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Cancel'),
)
```

#### TextButton (Tertiary Action)
Automatically styled with primary color text:

```dart
TextButton(
  onPressed: () {},
  child: Text('Skip'),
)
```

### Cards

Cards automatically use the theme's surface color and elevation:

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Card content'),
  ),
)
// Automatically has rounded corners (16px) and shadow
```

### Text Fields

Input fields are automatically styled:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
)
// Automatically has rounded borders and focus colors
```

### App Bar

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Title'),
  ),
)
// Automatically uses surface color with proper text color
```

## Scaffold Background

The scaffold background is automatically set based on the theme:

```dart
Scaffold(
  // No need to set backgroundColor!
  body: YourContent(),
)
```

If you need a different background for a specific screen:

```dart
Scaffold(
  backgroundColor: theme.colorScheme.surface, // Use theme colors
  body: YourContent(),
)
```

## Dark Mode

The app includes a dark theme that automatically switches based on system settings. All theme colors are properly configured for both light and dark modes.

## Color Mapping Reference

### Old AppColors → New Theme Colors

| Old (AppColors)          | New (Theme)                      |
|--------------------------|----------------------------------|
| `fountainBlue500`        | `theme.colorScheme.primary`      |
| `fountainBlue100`        | `theme.colorScheme.primaryContainer` |
| `osloGray900`            | `theme.colorScheme.secondary`    |
| `osloGray50`             | `theme.scaffoldBackgroundColor`  |
| White                    | `theme.colorScheme.surface`      |
| Text colors              | `theme.textTheme.*`              |
| Yellow accent            | `theme.colorScheme.tertiary`     |

## Best Practices

1. **Always use Theme.of(context)** instead of direct AppColors
2. **Use predefined text styles** from `theme.textTheme`
3. **Let components style themselves** - avoid manual styling when possible
4. **Use semantic colors** (primary, secondary, surface) instead of specific shades
5. **Test in both light and dark mode** to ensure proper contrast

## Examples

### Before (Manual Styling)
```dart
Container(
  color: AppColors.osloGray50,
  child: Column(
    children: [
      Text(
        'Title',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.osloGray900,
        ),
      ),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fountainBlue500,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
        child: Text('Action'),
      ),
    ],
  ),
)
```

### After (Theme-based)
```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    color: theme.scaffoldBackgroundColor,
    child: Column(
      children: [
        Text(
          'Title',
          style: theme.textTheme.headlineMedium,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Action'),
        ),
      ],
    ),
  );
}
```

## Troubleshooting

### Colors not showing correctly?
- Make sure you're getting the theme: `final theme = Theme.of(context);`
- Ensure you're inside a `BuildContext` (inside `build()` method)

### Need a custom color?
- For one-off colors, you can still use AppColors directly:
  ```dart
  Container(color: AppColors.p500)
  ```
- But prefer theme colors for consistency

### Text color not changing?
- Use text styles from theme: `theme.textTheme.bodyLarge`
- Or use: `theme.colorScheme.onSurface` for text colors

## Files Modified

- ✅ `lib/presentation/theme/app_themes.dart` - Complete theme configuration
- ✅ `lib/core/constants/app_colors.dart` - Updated color system (p50, sG300, etc.)
- ✅ All widget files - Now use `Theme.of(context)`
- ✅ All screen files - Now use theme colors
