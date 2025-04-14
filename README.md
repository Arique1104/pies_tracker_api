# 🧠 PIES Tracker – Frontend

A React + TypeScript frontend for the PIES (Physical, Intellectual, Emotional, Spiritual) Tracker, designed to support healing-centered leadership growth through daily check-ins, insights, and visualizations.

---

## 📦 Tech Stack
- React (TypeScript)
- Vite
- Axios
- Recharts (data visualization)
- JWT-based auth

---

## 🚀 Setup

```bash
cd pies-frontend
npm install
npm run dev
```

Make sure your `.env` (or axios baseURL config) points to the backend:
```ts
axios.defaults.baseURL = 'http://localhost:3000';
```

---

## 🧑‍🤝‍🧑 Roles

- **Individual**: Check in daily, view personal trends and suggestions
- **Leader**: Read-only access to reflection tips
- **Owner**: Full control over users, unmatched keywords, and tip engine

---

## 🔑 Features

- Role-based dashboards
- PIES check-in form (with sliders)
- Daily reflection engine with keyword-based tips
- Radar and line chart visualizations
- Responsive suggestion display logic
- Unmatched keyword review UI (for Owners)
- Tip manager with full CRUD (for Owners)
- Tip search (for all roles)

---

## 📁 File Highlights
- `src/components/PiesCheckinForm.tsx`
- `src/components/PiesRadarChart.tsx`
- `src/components/PiesSuggestions.tsx`
- `src/components/ReflectionTipsManager.tsx`
- `src/pages/IndividualDashboard.tsx`, `LeaderDashboard.tsx`, `OwnerDashboard.tsx`

---

## 🧪 Testing Locally
- Use the secret owner signup route to create an owner user
- Login as each role to test dashboards
- Enter various keywords in descriptions to see suggestion matches

---

## 📌 To Do
- [ ] Add tag-based filtering for tips
- [ ] Highlight keywords in suggestions
- [ ] Add tooltip previews

---

# 🧠 PIES Tracker – Backend

A Ruby on Rails API powering the PIES Tracker app — managing users, PIES check-ins, keyword suggestion engine, and role-based permissions.

---

## 📦 Tech Stack
- Ruby on Rails 8
- PostgreSQL
- JWT Auth (custom middleware)

---

## 🚀 Setup

```bash
git clone <repo>
cd pies_tracker_api
bundle install
rails db:create db:migrate
rails server
```

---

## 🔐 Auth
- Login returns a JWT
- Roles are stored on the `User` model via `enum role`
- `@current_user` available via middleware (decoded from JWT)

---

## 🧑‍🤝‍🧑 Models

- `User` (roles: individual, leader, owner)
- `PIESEntry` (daily check-ins)
- `TeamAssignment` (for leaders tracking assigned individuals)
- `UnmatchedKeyword` (logs unknown words from descriptions)
- `ReflectionTip` (suggestions shown to users)

---

## 📌 Key Routes

### Auth
```http
POST /signup
POST /login
```

### PIESEntries
```http
GET /pies_entries
POST /pies_entries
```

### Unmatched Keywords (owner only)
```http
GET /unmatched_keywords
```

### Reflection Tips
```http
GET /reflection_tips
POST /reflection_tips
PUT /reflection_tips/:id
DELETE /reflection_tips/:id
```

---

## 🧪 Seeding/Test Setup
In `rails console`, create users with roles:
```rb
User.create!(name: "Alice", email: "a@a.com", password: "password", role: :owner)
```

---

## ✅ Permissions
- `Individual`: Only manage own check-ins
- `Leader`: Read-only tips
- `Owner`: Full access to everything

---

## 📌 To Do
- [ ] Add streak tracking logic
- [ ] Improve example parsing for unmatched words
- [ ] Admin dashboard for viewing tip analytics