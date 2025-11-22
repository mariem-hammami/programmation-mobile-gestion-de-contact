import React from "react";
import "../style/card.css";

export default function WeatherCard({ city, temperature, icon }) {
  return (
    <div className="weather-card">
      <h3>{city}</h3>
      <p>{temperature}°C</p>
      <img src={icon} alt="icône météo" />
    </div>
  );
}
