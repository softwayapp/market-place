---
name: font
description: Download Pretendard font variants (Regular, Medium, SemiBold, Bold) with automatic path detection
category: frontend
version: 1.0.0
author: Frontend Team
---

# /font

Download Pretendard font files from jsDelivr CDN to a specified directory with parallel download optimization.

## Usage

```bash
# Auto-detect project type and download
/font

# Specify custom path
/font [target_path]
```

## Arguments

- `target_path` (optional): Directory where fonts will be saved
  - If omitted, auto-detects based on project type:
    - Next.js → `app/fonts/`
    - Expo → `assets/fonts/`
    - Other → `public/fonts/`

## Examples

### Example 1: Auto-detect (Next.js)

```bash
/font
```

**Output:**
```
✅ Pretendard fonts downloaded successfully!

📁 Location: app/fonts/
📦 Files:
  ✓ Pretendard-Regular.woff2 (45.2 KB)
  ✓ Pretendard-Medium.woff2 (45.8 KB)
  ✓ Pretendard-SemiBold.woff2 (46.1 KB)
  ✓ Pretendard-Bold.woff2 (46.5 KB)

⏱️  Download time: 2.3 seconds (parallel)

📝 Next Steps:
Add to app/layout.tsx:

import localFont from 'next/font/local'

const pretendard = localFont({
  src: [
    { path: './fonts/Pretendard-Regular.woff2', weight: '400' },
    { path: './fonts/Pretendard-Medium.woff2', weight: '500' },
    { path: './fonts/Pretendard-SemiBold.woff2', weight: '600' },
    { path: './fonts/Pretendard-Bold.woff2', weight: '700' },
  ],
  variable: '--font-pretendard',
})
```

### Example 2: Custom path

```bash
/font src/assets/fonts
```

**Output:**
```
✅ Pretendard fonts downloaded to custom path!

📁 Location: src/assets/fonts/
📦 Files: 4 files (183.6 KB total)
```

### Example 3: Expo project

```bash
/font
```

**Output:**
```
✅ Detected Expo project

📁 Location: assets/fonts/
📦 Files: 4 fonts downloaded

📝 Add to App.tsx:

import { useFonts } from 'expo-font'

const [loaded] = useFonts({
  'Pretendard-Regular': require('./assets/fonts/Pretendard-Regular.woff2'),
  'Pretendard-Medium': require('./assets/fonts/Pretendard-Medium.woff2'),
  'Pretendard-SemiBold': require('./assets/fonts/Pretendard-SemiBold.woff2'),
  'Pretendard-Bold': require('./assets/fonts/Pretendard-Bold.woff2'),
})
```

## Implementation

The command performs the following steps:

### 1. Detect Project Type

```bash
# Check for Next.js
if grep -q '"next"' package.json 2>/dev/null; then
  DEFAULT_PATH="app/fonts"
# Check for Expo
elif grep -q '"expo"' package.json 2>/dev/null; then
  DEFAULT_PATH="assets/fonts"
else
  DEFAULT_PATH="public/fonts"
fi
```

### 2. Create Target Directory

```bash
TARGET_PATH="${1:-$DEFAULT_PATH}"
mkdir -p "$TARGET_PATH"
```

### 3. Parallel Download

```bash
# Download all fonts in parallel for speed
curl -L -o "$TARGET_PATH/Pretendard-Regular.woff2" \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Regular.woff2 &

curl -L -o "$TARGET_PATH/Pretendard-Medium.woff2" \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Medium.woff2 &

curl -L -o "$TARGET_PATH/Pretendard-SemiBold.woff2" \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-SemiBold.woff2 &

curl -L -o "$TARGET_PATH/Pretendard-Bold.woff2" \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Bold.woff2 &

# Wait for all downloads to complete
wait
```

### 4. Verify Downloads

```bash
# Check if all files were downloaded successfully
DOWNLOADED=$(ls "$TARGET_PATH"/Pretendard-*.woff2 2>/dev/null | wc -l)

if [ "$DOWNLOADED" -eq 4 ]; then
  echo "✅ All fonts downloaded successfully!"
else
  echo "⚠️  Warning: Only $DOWNLOADED of 4 fonts downloaded"
fi
```

### 5. Display Setup Guide

Based on detected project type, display appropriate configuration:

- **Next.js**: `localFont` setup with App Router example
- **Expo**: `useFonts` hook example
- **Other**: CSS `@font-face` declarations

## Font Details

| Weight | File | Size | Use Case |
|--------|------|------|----------|
| 400 (Regular) | Pretendard-Regular.woff2 | ~45 KB | Body text |
| 500 (Medium) | Pretendard-Medium.woff2 | ~46 KB | Emphasis |
| 600 (SemiBold) | Pretendard-SemiBold.woff2 | ~46 KB | Headings |
| 700 (Bold) | Pretendard-Bold.woff2 | ~47 KB | Strong emphasis |

**Total Size**: ~184 KB
**Format**: WOFF2 (optimized for modern browsers)
**License**: SIL Open Font License 1.1

## Error Handling

### Network Failure

```
❌ Error downloading Pretendard-Regular.woff2
   Network error: Could not resolve host

💡 Troubleshooting:
   1. Check internet connection: ping cdn.jsdelivr.net
   2. Check firewall settings
   3. Try again: /font
```

### Permission Denied

```
❌ Error: Permission denied writing to app/fonts/

💡 Solutions:
   1. Check directory permissions
   2. Try different path: /font ~/Downloads/fonts
   3. Run with appropriate permissions
```

### Partial Download

```
⚠️  Partial download completed

✅ Downloaded (3/4):
   - Pretendard-Regular.woff2
   - Pretendard-Medium.woff2
   - Pretendard-SemiBold.woff2

❌ Failed:
   - Pretendard-Bold.woff2 (timeout)

💡 Retry: /font
```

## Performance

- **Parallel Downloads**: 4 simultaneous downloads
- **Time**: ~2-3 seconds (typical)
- **Bandwidth**: ~184 KB total
- **CDN**: jsDelivr (global CDN with high availability)

**Sequential vs Parallel:**
- Sequential: ~8-10 seconds
- Parallel: ~2-3 seconds
- **Speed improvement: ~75%**

## Related Skills

- `component-generator` - Generate UI components using Pretendard
- `responsive-design` - Design responsive layouts with typography
- `accessibility-audit` - Check font accessibility compliance

## Requirements

- `curl`: HTTP download tool (pre-installed on most systems)
- `mkdir`: Directory creation (pre-installed)
- Internet connection for CDN access

## Tips

### 1. Font Preloading

For better performance, preload critical fonts:

```html
<link
  rel="preload"
  href="/fonts/Pretendard-Regular.woff2"
  as="font"
  type="font/woff2"
  crossorigin
/>
```

### 2. Font Display Strategy

```css
@font-face {
  font-family: 'Pretendard';
  src: url('/fonts/Pretendard-Regular.woff2') format('woff2');
  font-display: swap; /* Prevent invisible text */
}
```

### 3. Subset Optimization

For even better performance, consider using font subsetting for your specific character set.

## Support

- **Documentation**: See `skills/frontend/font-download/`
- **Slack**: #frontend-support
- **Email**: frontend@company.com

## Version History

### 1.0.0 (2025-01-05)
- Initial release
- Support for Pretendard Regular, Medium, SemiBold, Bold
- Auto-detection for Next.js and Expo
- Parallel download optimization
- Framework-specific setup guides

---

**Maintained by Frontend Team** | [Report Issue](https://github.com/your-org/internal-marketplace/issues)
