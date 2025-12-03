# How to Add an App Icon to Your macOS App

## Step 1: Prepare Your Icon Image

You'll need an icon image. Here are options:

### Option A: Create Your Own Icon
- Use any image editor (Photoshop, GIMP, Preview, etc.)
- Create a square image (1024x1024 pixels recommended)
- Save as PNG format
- Use a transparent background if desired

### Option B: Use an Online Icon Generator
- Visit: https://www.appicon.co/ or https://www.appicon.build/
- Upload your image
- Download the generated icon set

### Option C: Use SF Symbols (Simple)
- macOS has built-in timer icons you can use
- We can create a simple icon programmatically

## Step 2: Add Icon to Xcode Project

### Method 1: Using Assets.xcassets (Recommended)

1. **Open your Xcode project**

2. **Find Assets.xcassets:**
   - In the left sidebar, look for `Assets.xcassets`
   - If you don't see it, create it:
     - Right-click your project → **New File**
     - Choose **Resource → Asset Catalog**
     - Name it `Assets` (or use default)
     - Click **Create**

3. **Add App Icon Set:**
   - Click on `Assets.xcassets` in the left sidebar
   - Right-click in the assets list → **New App Icon**
   - Or click the **"+"** button at the bottom → **App Icon**
   - You'll see "AppIcon" appear

4. **Add Icon Images:**
   - Click on "AppIcon" in the assets list
   - You'll see slots for different icon sizes
   - Drag and drop your icon images into the slots:
     - **512pt** (1x, 2x) - For macOS
     - **256pt** (1x, 2x) - For macOS
     - **128pt** (1x, 2x) - For macOS
     - **32pt** (1x, 2x) - For macOS
     - **16pt** (1x, 2x) - For macOS

5. **Quick Method (Single Image):**
   - If you have one 1024x1024 image, drag it to the **1024pt** slot
   - Xcode will automatically generate the other sizes (if you have the right settings)

### Method 2: Using Icon Composer (Advanced)

1. **Open Icon Composer:**
   - In Finder, press **⌘ + Space** (Spotlight)
   - Type "Icon Composer" and open it

2. **Add your icon:**
   - Drag your 1024x1024 image into Icon Composer
   - It will generate all required sizes
   - Save as `AppIcon.icns`

3. **Add to Xcode:**
   - Drag the `.icns` file into your Xcode project
   - Make sure it's added to the target

## Step 3: Configure App to Use Icon

1. **Select your project** (blue icon in left sidebar)

2. **Select "Pomodoro Timer" target**

3. **Go to "General" tab**

4. **Under "App Icons and Launch Screen":**
   - **App Icons Source:** Select `AppIcon` (from Assets.xcassets)
   - Or if using .icns file, select it from the dropdown

## Step 4: Icon Size Requirements

For macOS, you need these sizes:

- **1024x1024** (1x) - Main icon
- **512x512** (1x and 2x) - 512pt@1x, 512pt@2x
- **256x256** (1x and 2x) - 256pt@1x, 256pt@2x
- **128x128** (1x and 2x) - 128pt@1x, 128pt@2x
- **32x32** (1x and 2x) - 32pt@1x, 32pt@2x
- **16x16** (1x and 2x) - 16pt@1x, 16pt@2x

**Easiest:** Just provide a 1024x1024 PNG, and Xcode can generate the rest (if you enable it).

## Quick Setup: Using a Single 1024x1024 Image

1. **Prepare your icon:**
   - Create or find a 1024x1024 PNG image
   - Name it something like `icon.png`

2. **Add to Assets:**
   - Open `Assets.xcassets` in Xcode
   - Click **"+"** → **App Icon**
   - Drag your 1024x1024 image to the **1024pt** slot

3. **Configure:**
   - Select your project → Target → General tab
   - Set **App Icons Source** to `AppIcon`

4. **Build and test:**
   - Build the app (⌘ + B)
   - The icon should appear in Finder and Dock!

## Using SF Symbols (Simple Timer Icon)

If you want a quick icon using Apple's system symbols, you can create a simple icon programmatically, but for the app icon itself, you need actual image files.

## Icon Design Tips

- **Use a square image** (1024x1024)
- **Keep it simple** - icons are small, so details get lost
- **Use high contrast** - makes it visible at small sizes
- **Test at different sizes** - make sure it looks good at 16x16 and 1024x1024
- **PNG format** with transparency works best

## Troubleshooting

### Icon doesn't appear after building:
- Make sure the icon is in Assets.xcassets → AppIcon
- Check that App Icons Source is set correctly in project settings
- Clean build folder (⌘ + Shift + K) and rebuild
- Delete the app from Applications and rebuild

### Icon looks blurry:
- Make sure you're using high-resolution images (2x versions)
- Use PNG format, not JPEG
- Ensure images are the exact pixel dimensions required

### Can't find Assets.xcassets:
- Create it: Right-click project → New File → Resource → Asset Catalog
- Name it `Assets`

## Quick Test

After adding your icon:
1. Build the app (⌘ + B)
2. Find the `.app` file in Products folder
3. Right-click → Show in Finder
4. The icon should appear on the `.app` file!

Your app icon will appear in:
- Finder
- Dock (when running)
- Launchpad
- Applications folder

