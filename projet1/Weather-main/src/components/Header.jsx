import React from "react";

const styleH3 = {
  backgroundColor: "red",
  fontSize: "20px",
  color: "white"
};

const styleBizerte = { color: "blue" };
const styleSousse = { color: "green" };

const weather = {
  ville: "Sousse",
  date: "14/10/2025"
};

export default function Header({name = "3LIG"}) {
  return (
    <div>
      <h1>🌞My Weather App</h1>
      <h3 style={styleH3}>{weather.date}</h3>
      <h2 style={weather.ville === "Bizerte" ? styleBizerte : styleSousse}>
        {weather.ville}
      </h2>
      <h3>{name}</h3>
    </div>
  );
}
