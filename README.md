<div align="center">

  # 🍳 TasteCraft AI
  ### Intelligent Full-Stack Culinary & Nutrition Platform

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Django REST Framework](https://img.shields.io/badge/Django_REST-092E20?style=for-the-badge&logo=django&logoColor=white)](https://www.django-rest-framework.org/)
  [![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
  [![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
  [![OpenAPI](https://img.shields.io/badge/OpenAPI-6BAE23?style=for-the-badge&logo=openapi-initiative&logoColor=white)](https://swagger.io/)

  <p align="center">
    <b>TasteCraft AI</b> is a state-of-the-art, full-stack monorepo application combining a Django REST Framework backend with a cross-platform Flutter frontend to deliver AI-driven recipe recommendations, automated calorie tracking, personalized meal planning, and multi-language support.
  </p>

</div>

---

## 🌟 Key Features

### 📱 Frontend (Flutter Mobile & Web)
* **🤖 AI Calorie & Recipe Chatbot**: Interactive AI assistant supporting voice input (Speech-to-Text), audio recording, and automated ingredient analysis.
* **🥗 Smart Recipe Discovery**: Search, filter, and discover recipes by prep time, dietary preferences, difficulty, and available ingredients.
* **📅 Interactive Meal Planning**: Create weekly meal plans, track daily caloric intake, and export personalized PDF nutrition summaries.
* **🌐 Bilingual Support (Arabic & English)**: Full localization with seamless LTR/RTL support.
* **🎨 Modern UI/UX**: Crafted with smooth animations, dark/light theme options, responsive dynamic sizing, and Flutter BLoC/Cubit state management.

### 🐍 Backend API (Django REST Framework)
* **🔐 Secure Authentication**: JWT (JSON Web Token) authentication with custom user models.
* **📊 Admin Control Portal**: Dedicated HTML5 superuser dashboard monitoring user onboarding, demographics, system analytics, and chronic health tracking parameters.
* **📑 Automated OpenAPI / Swagger Documentation**: Interactive API documentation generated via `drf-spectacular`.
* **🐳 Containerized Environment**: Production-ready setup with Docker & Docker Compose.

---

## 🏗️ Repository Structure

This monorepo houses both the backend API and frontend client applications:

```text
tastecraft-ai/
├── recipe-app-api/              # Django REST Framework Backend
│   ├── app/                     # Main Django application directory
│   │   ├── core/                # Core apps, templates & admin dashboard
│   │   ├── recipe/              # Recipe CRUD, tags, ingredients APIs
│   │   ├── user/                # User authentication & profile management
│   │   └── app/                 # Settings, URLs, WSGI/ASGI configurations
│   ├── Dockerfile               # Production Docker build file
│   └── docker-compose.yml       # Multi-container orchestration
│
├── recipe_app/                  # Flutter Cross-Platform Frontend
│   ├── lib/                     # Application source code
│   │   ├── core/                # API clients, HTTP interceptors & constants
│   │   ├── data/                # Repositories & data models
│   │   ├── logic/               # BLoC / Cubit state management
│   │   ├── l10n/                # Localization files (Arabic & English)
│   │   └── presentation/        # UI Screens, widgets & themes
│   ├── android/                 # Android native configuration
│   ├── ios/                     # iOS native configuration
│   ├── web/                     # Web application manifest & index
│   └── pubspec.yaml             # Flutter dependencies
│
└── README.md                    # Project documentation
```

---

## 🚀 Quick Start Guide

### Prerequisites
- **Python**: `v3.10+`
- **Flutter SDK**: `v3.11+`
- **Docker & Docker Compose** (Optional, for containerized run)

---

### 1. Backend Setup (`recipe-app-api`)

#### Option A: Running with Docker (Recommended)
```bash
cd recipe-app-api
docker-compose up --build
```
The Django REST API will be accessible at `http://localhost:8000/`.
- **Swagger Documentation**: `http://localhost:8000/api/docs/`
- **Admin Portal**: `http://localhost:8000/admin/`

#### Option B: Local Setup with Virtual Environment
```bash
cd recipe-app-api
python -m venv venv

# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
python app/manage.py migrate
python app/manage.py runserver
```

---

### 2. Frontend Setup (`recipe_app`)

```bash
cd recipe_app

# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

---

## 📖 API Documentation

The backend includes auto-generated Swagger UI and Redoc documentation via `drf-spectacular`.

| Endpoint | Method | Description |
| :--- | :--- | :--- |
| `/api/user/create/` | `POST` | Register a new user |
| `/api/user/token/` | `POST` | Create JWT access token |
| `/api/user/me/` | `GET/PUT/PATCH` | Retrieve or update user profile |
| `/api/recipe/recipes/` | `GET/POST` | List recipes or create a new recipe |
| `/api/recipe/recipes/{id}/` | `GET/PUT/DELETE` | Detailed recipe view & management |
| `/api/recipe/tags/` | `GET/POST` | Recipe tagging system |
| `/api/docs/` | `GET` | Interactive Swagger UI |

---

## 🛠️ Built With

* **Frontend**: [Flutter](https://flutter.dev/), [Dart](https://dart.dev/), [Flutter BLoC](https://pub.dev/packages/flutter_bloc), [Dio](https://pub.dev/packages/dio), [Google Fonts](https://pub.dev/packages/google_fonts)
* **Backend**: [Django](https://www.djangoproject.com/), [Django REST Framework](https://www.django-rest-framework.org/), [drf-spectacular](https://drf-spectacular.readthedocs.io/)
* **DevOps**: [Docker](https://www.docker.com/), [Docker Compose](https://docs.docker.com/compose/)

---

## 🛡️ License

This project is licensed under the MIT License - see the LICENSE file for details.

<div align="center">
  <sub>Developed with ❤️ for culinary & tech enthusiasts.</sub>
</div>
