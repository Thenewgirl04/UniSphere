# UniSphere

A campus event management platform built with **Flutter** and **Django REST Framework**.

Students browse posted events. Organizations submit events for approval. Admins moderate events in Django Admin.

## What It Does

### Students
- Sign up and log in
- View all posted campus events on the home screen
- Profile with logout

### Organizations
- Register and log in
- Create event requests (pending admin approval)
- View events by status: pending, approved, rejected
- Publish approved events with a flyer upload
- Edit organization profile

### Admins
- Approve or reject events at `/admin/`
- Manage users and events through Django Admin

## Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile | Flutter, HTTP, Flutter Secure Storage |
| Backend | Django 5, Django REST Framework, SimpleJWT |
| Database | SQLite (development) |
| Auth | JWT tokens with role-based permissions |

## Project Structure

```
UniSphere/
├── backend/unisphere_backend/   # Django API
├── flutter_projects/            # Flutter mobile app
└── docs/ARCHITECTURE.md         # Architecture guide (start here)
```

## Quick Start

### 1. Backend

```bash
cd backend/unisphere_backend
pip install -r ../requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000
```

### 2. Flutter App

```bash
cd flutter_projects
flutter pub get
flutter run
```

The app uses `http://10.0.2.2:8000` for the Android emulator. Change the base URL in `lib/core/config/env.dart` for iOS simulator (`localhost`) or physical devices (your machine's IP).

### 3. Test the Full Flow

1. Register an organization in the app
2. Log in as the org and create an event
3. Open `http://127.0.0.1:8000/admin/` and approve the event
4. In the app, go to Events → Approved → upload a flyer → Publish
5. Register a student account and view the event on the home screen

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/register/` | Student registration |
| POST | `/api/org/register/` | Organization registration |
| POST | `/api/token/` | Login (JWT) |
| GET | `/api/events/posted/` | Posted events (public) |
| POST | `/api/events/` | Create event (org only) |
| GET | `/api/events/mine/` | Org's events by status |
| POST | `/api/events/<id>/post/` | Publish approved event |
| GET/PUT | `/api/org/profile/` | Org profile |

## Running Tests

```bash
# Backend
cd backend/unisphere_backend
python manage.py test authapp

# Flutter
cd flutter_projects
flutter test
```

## Future Improvements

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full architecture and planned production upgrades (PostgreSQL, env config, CI, deployment).

## License

Educational / portfolio project.
