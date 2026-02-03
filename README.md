# Vehicle Carbon Calculator 

A fun, interactive, and easy-to-use Flutter app to calculate and track your vehicle's carbon footprint. 

##  Features

- **Interactive Calculation**: Simply enter your vehicle type, fuel type, efficiency, and distance.
- **Engaging Visuals**: View your CO₂ emissions with color-coded results and intuitive graphs.
- **Trip History**: Keep track of your past trips and monitor your environmental impact over time.
- **Modern UI**: Clean, intuitive design with smooth animations.
- **Multi-Platform**: Designed to work flawlessly on both Android and iOS.

## 📊 How It Works

The app calculates CO₂ emissions using standard emission factors for various fuel types:
- **Gasoline**: ~2.31 kg CO₂ per liter
- **Diesel**: ~2.68 kg CO₂ per liter
- **Electric**: Emissions vary based on grid mix (approx. 0.4 kg CO₂ per kWh)

Formula: `(Distance / Efficiency) * Emission Factor`

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)

