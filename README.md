# 🍺 BeerHopper iOS

The official iOS client for [staging.beerhopper.me](https://staging.beerhopper.me), BeerHopper connects brewers, beer lovers, and microbrewery communities. Discover hops, grains, yeasts, recipes, and share your brews — now on mobile.

---

## 📱 Overview

This app brings the full BeerHopper experience to iPhone:

- ✅ Browse and search ingredients (hops, grains, yeasts)
- ✅ View detailed profiles and descriptors
- ✅ Post and comment in the community forum
- ✅ React to posts with likes or dislikes
- ✅ Register and authenticate with your BeerHopper account

---

## 🧰 Tech Stack

- **Language:** Swift 5.9
- **Framework:** SwiftUI, Combine, XCTest
- **Architecture:** MVVM + Environment Injection
- **Networking:** `URLSession` with async/await
- **Auth:** JWT with API-token-based headers
- **Backend:** Connects to BeerHopper API (Node.js + PostgreSQL)

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15+
- iOS 17+ device or simulator
- Swift Package Manager (SPM) dependencies resolved

### Running Locally

1. Clone the repo:

   ```bash
   git clone https://github.com/[your-username]/beerhopper-ios.git
   cd beerhopper-ios
   ```

2.	Open in Xcode:
 
  ```bash
  open BeerHopper.xcodeproj
  ```

3.	Run on simulator or your iOS device.

⸻

📦 Features in Progress
	•	User-generated ingredient creation
	•	Recipe building and tracking
	•	Push notifications
	•	Profile editing and social linking

⸻

🧪 Testing
	•	Unit and integration tests using XCTest
	•	Dedicated suites for:
	•	Authentication (AuthAPITests)
	•	Forum interactions (ForumAPITests)
	•	Performance and pagination tests

Run all tests via:

Cmd + U


⸻

📄 License

Will be a private repo shortly

⸻

🔗 Related Projects
	•	🌐 BeerHopper Web (staging)
	•	📦 BeerHopper API

⸻

Cheers to good code and great brews 🍻


