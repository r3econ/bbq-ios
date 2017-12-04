[![Build Status](https://travis-ci.org/r3econ/bbq-ios.svg?branch=master)](https://travis-ci.org/r3econ/bbq-ios) 
[![CodeFactor](https://www.codefactor.io/repository/github/r3econ/bbq-ios/badge)](https://www.codefactor.io/repository/github/r3econ/bbq-ios)
[![License](https://img.shields.io/badge/license-GNU%20GPLv3-brightgreen.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)

# BBQ. Grilling spots in Berlin - iOS App

Full source of an `iOS` app with information about public grilling spots in Berlin (state of `July 2014`). The app was available in the AppStore for two years (`2014`-`2016`). It's written in `Objective-C`.

<p align="center">
<img src="https://i.imgur.com/HuFbIXc.gif">
</p>

# What's inside
- Map with grilling spots
- Closest bus, tram or underground stops
- Description of the area around the grilling spot

[![Map](https://i.imgur.com/FQpHxXxm.png)](https://i.imgur.com/FQpHxXxm.png)
[![List](https://i.imgur.com/6CoCAcHm.png)](https://i.imgur.com/6CoCAcHm.png)
[![Details](https://i.imgur.com/6CoCAcHm.png)](https://i.imgur.com/dIZhwTlm.png)

# Technologies used
- Objective-C
- CoreData
- MapKit
- JSON
- Autolayout

# What could be improved
The app was created as a weekend project long time ago. It is production ready, updated to run in latest IDEs, but couple of things could be either added or improved.
- Adding unit tests for creation of `CoreData` stack and importing initial data
- Moving images and colors to asset catalogs
- Adding more comments to the code
- Simplifying autolayout logic in `RAFDetailViewController`

# License
This code is distributed under the terms and conditions of the [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/) license.

Copyright (c) 2014 Rafał Sroka
