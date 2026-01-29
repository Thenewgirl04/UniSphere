# UniSphere
 
A comprehensive campus event management platform that bridges the gap between students and student organizations. UniSphere enables organizations to create, manage, and promote campus events while allowing students to discover, explore, and stay updated on upcoming events.
 
## Features
 
### For Students
- **Event Discovery** - Browse all posted events from campus organizations
- **Event Exploration** - Explore events by categories (Technology, Arts, Health, Sports)
- **Organization Discovery** - Browse and view details about student organizations
- **Dashboard** - View trending events and recent updates
- **Profile Management** - User profile with preference settings
- **Secure Authentication** - JWT-based token authentication
 
### For Organizations
- **Organization Registration** - Create organization accounts with category and description
- **Event Creation** - Submit event requests with details (name, category, date, time, description, contact, flyer)
- **Event Management** - View events by status (pending, approved, rejected, posted)
- **Flyer Upload** - Upload event flyers/images
- **Organization Profile** - Manage organization details, logo, and description
 
### Admin Features
- **Event Moderation** - View and manage event requests
- **Event Approval/Rejection** - Approve or reject event requests
 
## Tech Stack
 
### Frontend
- **Flutter** (Dart) - Cross-platform mobile framework
- **Flutter Secure Storage** - Secure token storage
- **HTTP** - REST API client
- **Shared Preferences** - Local data persistence
- **Image Picker** - Image selection and uploading
 
### Backend
- **Django** - Python web framework
- **Django REST Framework** - REST API development
- **SimpleJWT** - JWT authentication
- **SQLite** - Database (development)
 
### Supported Platforms
- iOS
- Android
- Web
- Linux
- macOS
- Windows
 
## Project Structure
 
```
UniSphere/
├── backend/                           # Django backend server
│   └── unisphere_backend/
│       ├── authapp/                   # Main application
│       │   ├── models.py              # Database models
│       │   ├── views.py               # API endpoints
│       │   ├── urls.py                # URL routing
│       │   └── serializers.py         # DRF serializers
│       ├── unisphere_backend/
│       │   ├── settings.py            # Django settings
│       │   └── urls.py                # Main URL config
│       ├── manage.py                  # Django management script
│       └── media/                     # User uploads
│
└── flutter_projects/                  # Flutter mobile app
    ├── lib/
    │   ├── main.dart                  # Application entry point
    │   ├── screens/                   # UI screens
    │   ├── widgets/                   # Reusable UI components
    │   └── theme/                     # Theming
    ├── pubspec.yaml                   # Flutter dependencies
    └── test/                          # Flutter tests
```
 
## Installation
 
### Prerequisites
 
- Python 3.8+
- Flutter SDK 3.7.2+
- pip (Python package manager)
 
### Backend Setup
 
1. Navigate to the backend directory:
   ```bash
   cd backend/unisphere_backend
   ```
 
2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
 
3. Install dependencies:
   ```bash
   pip install django djangorestframework djangorestframework-simplejwt django-cors-headers pillow
   ```
 
4. Run migrations:
   ```bash
   python manage.py migrate
   ```
 
5. Create a superuser (optional):
   ```bash
   python manage.py createsuperuser
   ```
 
6. Start the development server:
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```
 
The backend will be available at `http://127.0.0.1:8000/`
 
### Frontend Setup
 
1. Navigate to the Flutter project:
   ```bash
   cd flutter_projects
   ```
 
2. Get dependencies:
   ```bash
   flutter pub get
   ```
 
3. Run the app:
   ```bash
   flutter run
   ```
 
   Or for a specific platform:
   ```bash
   flutter run -d android  # For Android
   flutter run -d ios      # For iOS
   flutter run -d web      # For Web
   ```
 
4. Build for release:
   ```bash
   flutter build apk       # For Android APK
   flutter build ios       # For iOS
   flutter build web       # For Web
   ```
 
## API Endpoints
 
### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/register/` | Student registration |
| POST | `/api/token/` | User login (JWT) |
| POST | `/api/token/refresh/` | Refresh JWT token |
 
### Organization
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/org/register/` | Organization registration |
| POST | `/api/org/login/` | Organization login |
| PUT | `/api/org/profile/` | Update organization profile |
| GET | `/api/org/events/` | Get organization's events |
| POST | `/api/org/events/create/` | Create event request |
| GET | `/api/org/events/grouped/` | Get events grouped by status |
| POST | `/api/org/events/post/<id>/` | Post approved event |
 
### Events
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/events/posted/` | Get all posted events |
| POST | `/api/submit-event/` | Submit event request |
| POST | `/api/event-requests/approve/<id>/` | Approve event |
| POST | `/api/event-requests/reject/<id>/` | Reject event |
 
## Configuration
 
### Backend (settings.py)
- Debug mode enabled for development
- SQLite database
- JWT authentication configured
- CORS enabled for all origins (development only)
- Media files stored in `media/` directory
 
### Frontend (pubspec.yaml)
- SDK requirement: ^3.7.2
- Assets directory: `assets/images/`
- Multi-platform support enabled
 
## Production Considerations
 
Before deploying to production:
 
- Set `DEBUG = False` in Django settings
- Use environment variables for `SECRET_KEY`
- Restrict `ALLOWED_HOSTS` and CORS origins
- Migrate to PostgreSQL or MySQL
- Set up proper media file storage (e.g., AWS S3)
- Implement rate limiting
- Add proper logging and error tracking
- Configure HTTPS
 
## License
 
This project is for educational purposes.
 
## Contributing
 
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request
