SRH Hotel - Cross-Platform Booking Application

A feature-rich, cross-platform hotel booking application built for the SRH University Project. This application demonstrates advanced mobile development concepts, including local data persistence, hardware integration (Camera, GPS, Audio), and global accessibility.

 Key Features

 Core Functionality

Multi-Screen Navigation: Seamless transition between Login, Home, Booking, and Admin dashboards.

SQLite Database: Full offline data persistence for room bookings using a local relational database.

Admin Dashboard: A secure area to view, manage, and delete existing bookings.

 Hardware & API Integration

Live GPS Tracking: Real-time user positioning on an interactive map (OpenStreetMap).

QR Code System: Dynamic QR generation for booking confirmations and a functional QR scanner using the device camera.

Google Maps Integration: ROI-based markers showing hotel locations in Heidelberg.

 Accessibility & Localization

Multilingual Support: Instant switching between English, German, and Spanish.

Speech-to-Text (STT): Voice-activated form filling for names and emails.

Text-to-Speech (TTS): Auditory reading of booking confirmations for better accessibility.

Dynamic Text Scaling: Global magnifier controls (+/-) to adjust font sizes across the entire UI.

 Project Structure

lib/
  ├─ models/           # Data classes (Booking model)
  ├─ screens/          # UI Screens (Login, Home, Admin, etc.)
  ├─ utils/            # Services (DatabaseHelper, Permissions)
  ├─ widgets/          # Reusable UI components (AppControls)
  └─ main.dart         # App entry point & Routing
assets/
  ├─ images/           # Logo and static assets
  └─ translations/     # JSON localization files


 Installation & Setup

Clone the repository:

git clone [https://github.com/Yeshas0017/srh-hotel.git](https://github.com/Yeshas0017/srh-hotel.git)
cd srh-hotel


Install dependencies:

flutter pub get


Run the application:

Mobile: flutter run

Windows: flutter run -d windows

macOS: flutter run -d macos

 Contributors

Narasimha Murthy, Yeshas (100002275)

Ashok Mehatha, Suhas (100003705)

Muthu, Yashwanth (100003479)

Developed as part of the "Developing Mobile Applications" course at SRH Hochschule Heidelberg.
