# 📊 GradeWise – GPA & CGPA Calculator App

**GradeWise** is a mobile application built using **Flutter** and **GetX**, designed to help students calculate and manage their **GPA** and **CGPA** effortlessly. With a clean and responsive UI, offline data storage, and flexible input modes, GradeWise simplifies academic performance tracking for university and college students.

---

## 🚀 Features

✅ **Add Semesters**  
– Input multiple courses per semester  
– Choose between per-course or total grade point modes

✅ **Two Calculation Modes**  
– **Per-Credit Mode**: GPA = ∑(credit × grade point) / ∑(credits)  
– **Total Points Mode**: Directly enter total grade points and credits

✅ **Live GPA Preview**  
– See your GPA before saving semester data

✅ **Auto CGPA Calculation**  
– CGPA is automatically calculated from all saved semesters

✅ **Edit & Delete Semesters**  
– Easily update or remove existing data with confirmation dialogs

✅ **Light/Dark Mode Support**  
– Toggle between themes for a smooth visual experience

✅ **Offline Persistence**  
– All data is stored locally using **GetStorage** – no login/signup required

✅ **Responsive UI**  
– Works seamlessly across screen sizes  
– Uses Google Fonts (Inter, Rubik, Poppins) for modern typography

---

## 🧑‍💻 Tech Stack

- **Flutter** – Cross-platform UI framework  
- **GetX** – State management & routing  
- **GetStorage** – Local data persistence  
- **Google Fonts** – Custom typography  
- **MediaQuery + SizeHelper** – Responsive layout system

---

## 🖼️ UI Overview

### 🏠 Home Page
- Displays overall CGPA
- Lists all saved semesters with GPA
- Add/Edit/Delete options

### ➕ Add/Edit Semester
- Input per-course data or total grade points
- Toggle between calculation modes
- GPA preview before saving

---

## 📥 Installation

```bash
git clone https://github.com/DevExplorerr/Grade-Wise-App.git
cd Grade-Wise-App
flutter pub get
flutter run
