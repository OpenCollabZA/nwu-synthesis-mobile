#! /bin/bash
# Author : Charl Thiem {charl@opencollab.co.za}
# Created : 19 Feb 2014
# Description : Script that creates required media files for web and native


# ========================================
# Configure the source logos to use for
# application icons
# ========================================

# Image to use as a splash screen (SVG only)
NATIVE_SPLASH=app_banner.svg
NATIVE_SPLASH_W=515
NATIVE_SPLASH_H=235

# Background to use with the splash screen
# This color is used to fill the space of the splash
NATIVE_SPLASH_BG=#ffffff

# A squared logo (SVG only)
LOGO_SQUARE=app_logo.svg

# If you have an icon with a rounded border (SVG only)
# if not, use the same icon as for LOGO_SQUARE
LOGO_ROUNDED=$LOGO_SQUARE

# Native logo for Android
NATIVE_LOGO_ANDROID=$LOGO_ROUNDED

# Native logo for iOS
# iOS automatically adds round corners
NATIVE_LOGO_IOS=$LOGO_SQUARE

# Native logo for Windows
NATIVE_LOGO_WINDOWS=$LOGO_SQUARE

# Web icon logo
WEB_LOGO=$LOGO_ROUNDED

# Favicon logo
WEB_FAVICON=$LOGO_ROUNDED


# ========================================
# DO NOT CHANGE ANYTHING BELOW THIS LINE!
# ========================================
FILE_NAMES=`ls -1 | grep svg$`
SCRIPT_PATH=`dirname "$0"`
SCRIPT_PATH=`readlink -e $SCRIPT_PATH`


# Use this path to export files cordova will automatically add
# when adding platforms
OUTPUT_DIR_TEMP="/tmp"
OUTPUT_DIR_WEB="${SCRIPT_PATH}/../html"
OUTPUT_DIR_MARKETS="${SCRIPT_PATH}/store_images"
OUTPUT_DIR_CORDOVA=${SCRIPT_PATH}

# Check that imagemagic is installed
which convert >/dev/null 2>&1
if [ $? != 0 ] ; then
	echo "You don't seem to have the 'convert' command. You might need to install 'imagemagick'";
	exit 1;
fi

which rsvg-convert >/dev/null 2>&1
if [ $? != 0 ] ; then
	echo "You don't seem to have the 'rsvg-convert' command. You might need to install 'librsvg2-bin'";
	exit 1;
fi


# Converts a svg to a png
# $1 source file
# $2 output file name
# $3 size
# $4 Optional --no-alpha
CONVERT_LOGO(){
	BACKGROUND="";
	if [ "$4" == "--no-alpha" ]; then
		BACKGROUND="--background-color=$NATIVE_SPLASH_BG";
	fi
	rsvg-convert -a $BACKGROUND --width=$3 --height=$3 --format=png -o "$2" $1
	echo "Created file $2";
}


# Convert and SVG to a splash screen
# $1 source file
# $2 output file
# $3 Desired width
# $4 Desired height
CONVERT_SPLASH_9(){
	CONVERT_SPLASH $* --no-alpha;
	NEW_WIDTH=$(identify -format "%[w]" "$2");
 	NEW_HEIGHT=$(identify -format "%[h]" "$2");
	./9pedit -sx 1,$NEW_WIDTH -sy 1,$NEW_HEIGHT -px 1-$NEW_WIDTH -py 1-$NEW_HEIGHT "$2"
	rm "$2"
}

# Convert and SVG to a splash screen
# $1 source file
# $2 output file
# $3 Desired width
# $4 Desired height
# $5 --no-alpha
CONVERT_SPLASH(){

	# Which dimesion should we scale on
	SOURCE_SCALE="height"
	# Which dimension is the biggest
	DEST_SCALE="height"

	if [ "$5" == "--no-alpha" ]; then
		BACKGROUND="-background $NATIVE_SPLASH_BG";
	else
		BACKGROUND="-background none";
	fi

	if [ $NATIVE_SPLASH_W -gt $NATIVE_SPLASH_H ] ; then
		SOURCE_SCALE="width";
	fi

	# Check if width is bigger than height
	if [ $3 -gt $4 ] ; then
		DEST_RATIO="width";
	fi

	# If splash is a square, we have to work with only the dest ratio
	# If the Dest ratio and source ratio is not the same, use the dest ratio
	if [ $NATIVE_SPLASH_W == $NATIVE_SPLASH_H ] || [ "$DEST_RATIO" != "$SOURCE_SCALE" ] ; then
		if [ "$DEST_RATIO" == "width" ] ; then
			SOURCE_SCALE="height";
		else
			SOURCE_SCALE="width";
		fi
	fi

	if [ "$SOURCE_SCALE" == "width" ] ; then
		rsvg-convert --keep-aspect-ratio --width=$3 --format=png -o "${OUTPUT_DIR_TEMP}/~temp.png" $1
	else
		rsvg-convert --keep-aspect-ratio --height=$4 --format=png -o "${OUTPUT_DIR_TEMP}/~temp.png" $1
	fi

	convert "${OUTPUT_DIR_TEMP}/~temp.png" $BACKGROUND -gravity center -extent "$3x$4" "$2"
	#rm "${OUTPUT_DIR_TEMP}/~temp.png"
	echo "Created file $2";
}

# Convert banner to splash screen
# $1 input file
# $2 output file name
# $3 width
# $4 height
CONVERT_JPG(){
	rsvg --width=$3 --height=$4 -f jpeg $1 "$2"
	echo "Created file $2";
}

# Convert SVG to favicon
#
#
CONVERT_ICO(){
	convert -resize x16 -gravity center -crop 16x16+0+0 $1 -transparent white -colors 256 "$2"
	echo "Created file $2";
}


# Web apple touch icons
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_WEB}/apple-touch-icon.png" 57
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_WEB}/apple-touch-icon-76.png" 76
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_WEB}/apple-touch-icon-120.png" 120
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_WEB}/apple-touch-icon-152.png" 152

CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_WEB}/images/splash.png" 500 500

# Web fav icons
#CONVERT_ICO $WEB_FAVICON "favicon.ico"

#Android
mkdir -p "${OUTPUT_DIR_CORDOVA}/android"

# Android icons
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_CORDOVA}/android/icon-36-ldpi.png" 36
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_CORDOVA}/android/icon-48-mdpi.png" 48
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_CORDOVA}/android/icon-72-hdpi.png" 72
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_CORDOVA}/android/icon-96-xhdpi.png" 96
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_CORDOVA}/android/icon-144-xxhdpi.png" 144

# Android splash screens
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-720x960-port.png" 720 960
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-960x720-land.png" 960 720
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-480x640-hdpi.png" 480 640
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-640x480-land-hdpi.png" 640 480
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-320x426-port-ldpi.png" 320 426
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-426x320-land-ldpi.png" 426 320
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-320x470-port-mdpi.png" 320 470
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-470x320-land-mdpi.png" 470 320
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-720x960-port-xhdpi.png" 720 960
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-960x720-land-xhdpi.png" 960 720
CONVERT_SPLASH_9 $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/android/splash-1440x1080-land-xxhdpi.png" 1440 1080

# Create market images
mkdir -p "$OUTPUT_DIR_MARKETS/android/"
CONVERT_LOGO $NATIVE_LOGO_ANDROID "${OUTPUT_DIR_MARKETS}/android/high-rest-icon-512x512.png" 512
CONVERT_SPLASH $LOGO_SQUARE "${OUTPUT_DIR_MARKETS}/android/feature-graphic-1024x500.png" 1024 500
CONVERT_SPLASH $LOGO_SQUARE "${OUTPUT_DIR_MARKETS}/android/promo-graphic-180x120.png" 180 120
CONVERT_SPLASH $LOGO_SQUARE "${OUTPUT_DIR_MARKETS}/android/banner-asset-tv-320x180.png" 320 180

# iOS
mkdir -p "${OUTPUT_DIR_CORDOVA}/ios"

# iOS Splash screens
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-568h@2x~iphone.png" 640 1136
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-667h.png" 750 1334
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-736h.png" 1242 2208
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-Landscape-736h.png" 2208 1242
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-Landscape@2x~ipad.png" 2048 1536
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-Landscape~ipad.png" 1024 768
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default@2x~iphone.png" 640 960
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-Portrait~ipad.png" 768 1024
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default-Portrait@2x~ipad.png" 1536 2048
CONVERT_SPLASH $NATIVE_SPLASH "${OUTPUT_DIR_CORDOVA}/ios/Default~iphone.png" 320 480

# iOS Icons
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-40.png" 40
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-40@2x.png" 80
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-50.png" 50
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-50@2x.png" 100
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-60.png" 60
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-60@2x.png" 120
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-60@3x.png" 180
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-72.png" 72
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-72@2x.png" 144
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-72.png" 72
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-76.png" 76
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-76@2x.png" 152
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-83.5@2x.png" 167
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-small.png" 29
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-small@2x.png" 58
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon-small@3x.png" 87
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon.png" 57
CONVERT_LOGO $NATIVE_LOGO_IOS "${OUTPUT_DIR_CORDOVA}/ios/icon@2x.png" 114

# iOS Market Images
mkdir -p "$OUTPUT_DIR_MARKETS/ios"
CONVERT_LOGO $LOGO_SQUARE "$OUTPUT_DIR_MARKETS/ios/LargeAppIcon-1024x1024.png" 1024 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/3_5_Retina_Screenshot-960x600.png" 960 600 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/3_5_Retina_Screenshot-640x920-landscape.png" 640 920 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/4_Retina_Screenshot-640x1096.png" 640 1096 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/4_Retina_Screenshot-1136x600-landscape.png" 1136 600 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/4_7_Retina_Screenshot-750x1334.png" 750 1334 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/4_7_Retina_Screenshot-1334x750-landscape.png" 1334 750 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/5_5_Retina_Screenshot-1242x2208.png" 1242 2208 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/5_5_Retina_Screenshot-2208x1242-landscape.png" 2208 1242  --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/9_7_iPad_Retina_Screenshot-1536x2008.png" 2048 1496 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/9_7_iPad_Retina_Screenshot-1536x2008-landscape.png" 1536 2008 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/12_9_iPad_Retina_Screenshot-1536x2008-portrait.png" 2048 2732 --no-alpha
CONVERT_SPLASH $NATIVE_SPLASH "$OUTPUT_DIR_MARKETS/ios/12_9_iPad_Retina_Screenshot-2732x2048-landscape.png" 2048 2732 --no-alpha

# Windows
mkdir -p "${OUTPUT_DIR_CORDOVA}/windows"

CONVERT_SPLASH $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/SplashScreen.scale-100.png" 620 300
CONVERT_SPLASH $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/SplashScreenPhone.scale-240.png" 1152 1920
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square150x150Logo.scale-100.png" 150
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square150x150Logo.scale-240.png" 360
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square30x30Logo.scale-100.png" 30
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square310x310Logo.scale-100.png" 310
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square44x44Logo.scale-100.png" 44
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square44x44Logo.scale-240.png" 106
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square70x70Logo.scale-100.png" 70
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square71x71Logo.scale-100.png" 71
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Square71x71Logo.scale-240.png" 170
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/StoreLogo.scale-100.png" 50
CONVERT_LOGO $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/StoreLogo.scale-240.png" 120
CONVERT_SPLASH $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Wide310x150Logo.scale-100.png" 310 150
CONVERT_SPLASH $NATIVE_LOGO_WINDOWS "${OUTPUT_DIR_CORDOVA}/windows/Wide310x150Logo.scale-240.png" 744 360
