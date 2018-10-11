

# NRSpeechToText

[![Version](https://img.shields.io/cocoapods/v/NRSpeechToText.svg?style=flat)](http://cocoapods.org/pods/NRSpeechToText)
[![License](https://img.shields.io/cocoapods/l/NRSpeechToText.svg?style=flat)](http://cocoapods.org/pods/NRSpeechToText)
[![Platform](https://img.shields.io/cocoapods/p/NRSpeechToText.svg?style=flat)](http://cocoapods.org/pods/NRSpeechToText)
![ScreenShot](https://cdn.rawgit.com/naveenrana1309/NRSpeechToText/master/Example/sample.png "Screeshot")



## Introduction

NRSpeechToText: This library provides the speech to text functionality with the help iOS speech framework.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Xcode 9+ , Swift 4 , iOS 9 and above


## Plist Keys & Background Mode
Please make sure you have the below keys in your plist file before using the speech services.

```
<key>Privacy - Microphone Usage Description</key>
<string>We will use this microphone for testing our demo.</string>

<key>Privacy - Speech Recognition Usage Description</key>
<string>We will speech recognition for testing demo</string>

```

## Installation

NRSpeechToText is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NRSpeechToText"
```



## Usage

```
@IBAction func microphoneButtonPressed(_ sender: AnyObject) {
NRSpeechToText.shared.authorizePermission { (authorize) in
if authorize {
if NRSpeechToText.shared.isRunning {
NRSpeechToText.shared.stop()
OperationQueue.main.addOperation {
self.microphoneButton.setTitle("Start Recording", for: .normal)

}

}
else {
OperationQueue.main.addOperation {
self.microphoneButton.setTitle("Stop Recording", for: .normal)

}
self.startRecording()

}


}
}

}

func startRecording() {
NRSpeechToText.shared.startRecording {(result: String?, isFinal: Bool, error: Error?) in
if error == nil {
self.textView.text = result
}
}
}

```


## Contributing

Contributions are always welcome! (:

1. Fork it ( http://github.com/naveenrana1309/NRSpeechToText/fork )
2. Create your feature branch ('git checkout -b my-new-feature')
3. Commit your changes ('git commit -am 'Add some feature')
4. Push to the branch ('git push origin my-new-feature')
5. Create new Pull Request

## Compatibility

Xcode 9+ , Swift 4 , iOS 10 and above

## Author

Naveen Rana. [See Profile](https://www.linkedin.com/in/naveen-rana-9a371a40)

Email:
naveenrana1309@gmail.com.

Check out [Facebook Profile](https://www.facebook.com/naveen.rana.146) for detail.

## License

NRSpeechToText is available under the MIT license. See the LICENSE file for more info.


