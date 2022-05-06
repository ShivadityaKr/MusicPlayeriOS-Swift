# Music Player in Swift

[![S|Swift](data:image/png;base64,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)](https://developer.apple.com/documentation/swift)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://github.com/ShivadityaKr/MusicPlayeriOS-Swift/tree/main)

This Music player is made-up with swift UiKit and AVFoundation

- Swift UiKit
- AVFoundation


## Features

- Play Music 
- Play and pause functionality
- Seek Functionality
- Jump to next song
- Load song from URL





## Usages

Clone from git URL or download the project and open in your xCode and simply run the project.

There is no any dependency added to the project.


## License

MIT

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   
