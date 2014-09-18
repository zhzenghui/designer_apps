

pulish_url="https://file.i-bejoy.com"




APPROOT="/Users/lifeng/github/desgner"
APPXCASSETSROOT="$APPROOT/Designer"

RESOUCEROOT="/Users/lifeng/快盘/我收到的共享文件/lifeng@i-bejoy.com/BEJOY项目文档/设计师App"
RESOUCEPAHT="$RESOUCEROOT/$DESGNERID.$DESGNERNAME/切图"


# 配置icon目录信息
Icon_path="$APPXCASSETSROOT/Images.xcassets/AppIcon.appiconset/icon-152x152.png"
Icon_images_path="$RESOUCEPAHT/icon/icon-152x152.png"

AppResourcesPath="$APPROOT/Designer/Resources/$SCHME/"



userPlistPath="$RESOUCEPAHT/user.plist"
build="$APPROOT/build"
production="$APPROOT/production"

RESOUCEPlistPath="$RESOUCEPAHT/user.plist"
AppPlistPath="$APPROOT/Designer/$SCHME-Info.plist"




cd "$APPROOT/sh"


#------------------------------------
#-------第一步，创建和修改配置文件-------
#------------------------------------

#创建 user.plist 文件
defaults write $RESOUCEPlistPath "kD_Id" $DESGNERID
defaults write $RESOUCEPlistPath "name" $DESGNERSPELLNAME
defaults write $RESOUCEPlistPath "display_name" $DESGNERNAME
defaults write $RESOUCEPlistPath "plist" $SCHME
defaults write $RESOUCEPlistPath "them_id" $them_id
defaults write $RESOUCEPlistPath "version" $version

# 修改 Info.plist 文件
defaults write $AppPlistPath "CFBundleDisplayName" $DESGNERNAME
defaults write $AppPlistPath "CFBundleIdentifier" "com.i-bejoy.$DESGNERSPELLNAME"
defaults write $AppPlistPath "CFBundleName" $DESGNERSPELLNAME



#------------------------------------
#-------第二步，复制icon文件   -------
#------------------------------------
echo "copy icon images"
cp -R $Icon_images_path $Icon_path

cp -R -a  $RESOUCEPAHT $AppResourcesPath 


#------------------------------------
#-------第三步，复制icon文件   -------
#------------------------------------

mkdir "$production/$DESGNERSPELLNAME"
echo "编译项目到build目录"
echo "开始编译"

cd ..
xcodebuild clean  CONFIGURATION_BUILD_DIR="$build"
xcodebuild -configuration Release -workspace "./Designer.xcworkspace" PROVISIONING_PROFILE="2F6DB9F6-0B65-4C74-8351-A46E20ED2454" CODE_SIGN_IDENTITY="iPhone Distribution: Beijing Vision Bejoy Media Technology Co., Ltd" -scheme "$SCHME" CONFIGURATION_BUILD_DIR="$build"
xcrun -sdk iphoneos packageapplication -v "$build/$SCHME.app" -o "$production/$DESGNERSPELLNAME/$SCHME.ipa"



#------------------------------------
#---第四步，生成plist，download文件-------
#------------------------------------
cd "$production"




ipa_download_url=${pulish_url}/${DESGNERSPELLNAME}/${SCHME}.ipa
ios_install_url="itms-services://?action=download-manifest&url=${pulish_url}/${DESGNERSPELLNAME}/100-iphone.plist"

#生成install.html文件
cat << EOF > "$DESGNERSPELLNAME/download.html"
<!DOCTYPE HTML>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>安装此软件</title>
  </head>
  <body>



    <table width="90%">
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	<td align="center"><h1>${DESGNERNAME}</h1></td>
	</tr>
	<tr>
	<td align="center"><h1><a href="${ios_install_url}">下载及安装...</a></h1></td>
	</tr>
	</table>
  </body>
</html>
EOF
#生成plist文件
cat << EOF > "$DESGNERSPELLNAME/100-iphone.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   	<key>items</key>
	<array>
		<dict>
			<key>assets</key>
			<array>
				<dict>
					<key>kind</key>
					<string>software-package</string>
					<key>url</key>
					<string>${ipa_download_url}</string>
				</dict>
			</array>
			<key>metadata</key>
			<dict>
				<key>bundle-identifier</key>
				<string>com.i-bejoy.${DESGNERSPELLNAME}</string>
				<key>bundle-version</key>
				<string>1.0</string>
				<key>kind</key>
				<string>software</string>
				<key>title</key>
				<string>${DESGNERNAME}</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>

EOF


#------------------------------------
#---第五步，上传 dir           -------
#------------------------------------
local_ipa_path="./$DESGNERSPELLNAME"
server_path="root@223.4.147.79:/data/webroot/"

echo "正在上传到服务器"
scp -r $local_ipa_path $server_path



scp root@223.4.147.79:/data/webroot/apps.html $production



