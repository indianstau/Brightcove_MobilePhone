## CocoaPods  
[Cocoapods](https://cocoapods.org/)  
It's dependencies Cocoapods in your project.  
  
#### Brightcove documentation  
[Swift - quick start](https://support.brightcove.com/quick-start-create-simple-video-app-using-swift)  
[Objective-C - quick start](https://support.brightcove.com/quick-start-create-simple-video-app-using-objective-c)  

##### How to install cocoapods (cmd)  
1. $ sudo gem install cocoapods  

2. $ pod init (in your project file) 

3. change profile content (like Brightcove-Player-Core) then  $ pod install  

P.S Here is for Objective-c code note.  

### Note  
  
When something is update  
You need to update Cocoapods    
If Cocoapods have issue re install  
  
#### For Swift   
If not such brightcoveSDK moudle   
Try clean bliud  win + Alt + Shift + k  

#### For Objective-c  
  
Error :  framework not found Pods_"project_name"  
Try   
Under your file project  
Cmd: $pod deintegrate  
     $pod install  
  

If two language have simulator issue, try reopen Xcode or clean build, or check dependencies and SDK exist, and file is correct  
P.S. Podfile for Swift and Objective-c are different
