# College Portal

A college management system with separate portals for students and teachers.

## Technology Stack

- **Backend**: Ruby on Rails 8.1.0, Ruby 3.4.7
- **Frontend**: Tailwind CSS, Turbo (Hotwire), ES6 Modules
- **Database**: SQLite3 (development), PostgreSQL (production)
- **Authentication**: Devise
- **Architecture**: RESTful API structure with JSON endpoints
- **Internationalization**: i18n support (EN, PL)
- **CI/CD**: GitHub Actions (automated testing on each commit)

## Features

### Student Portal
- Dashboard with announcements and grades
- Study progress tracking
- Weekly schedule
- Petition submission
- Teacher evaluation surveys

### Teacher Portal
- Announcement management
- Course and grade management
- Weekly schedule
- Survey results viewing
- Profile and statistics

## Setup

```bash
bundle install
rails db:create db:migrate db:seed
rails server
```

Access at `http://localhost:3000`


## 🎬 Demo
https://github.com/KappaChungus/college_portal/blob/main/demo.mp4