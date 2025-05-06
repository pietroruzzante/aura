# Aura

<p align="center">
  <img src="assets/logo.png" alt="Aura Logo" width="200">
</p>

Aura is a cross-platform mobile application that leverages machine learning to predict the likelihood of experiencing headaches. By analyzing data from smartwatches and environmental factors, Aura aims to provide users with proactive insights to manage and prevent migraine episodes.

## Features
- Headache Probability Prediction: Utilizes a machine learning model to estimate the probability of a headache occurring.
- Smartwatch Data Integration: Collects and analyzes physiological data from connected smartwatches.
- Environmental Factor Analysis: Considers external factors such as weather conditions and air quality in predictions.
- User-Friendly Interface: Designed with a focus on usability and accessibility across multiple platforms.

## Getting Started
### Prerequisites
- Flutter SDK: Ensure you have Flutter installed.
- Supported Platforms: Android, iOS, Web, macOS, Windows, Linux.

### Installation
To get started with Aura, follow these steps:
1. **Clone the repository:**
```bash
git clone https://github.com/pietroruzzante/aura.git
cd aura
```
2. Install the dependencies:
```bash
flutter pub get
```
3. Run the application:
```bash
flutter run
```
Make sure you have Flutter properly installed. You can check by running:
```bash
flutter doctor
```

## Project Structure
- ```lib/```: Contains the main application code.
- ```assets/```: Includes images, fonts, and other asset files.
- ```test/```: Contains unit and widget tests.
- ```data_stress.csv```: Dataset used for training and evaluating the machine learning model.

## Machine Learning Model
The application incorporates a machine learning model trained on physiological and environmental data to predict headache occurrences. The data_stress.csv file provides the dataset used for model training and validation.

## Contributors
Powered by **DartVaders**:
- Leonardo Badon
- Anna Ghiotto
- Pietro Ruzzante
