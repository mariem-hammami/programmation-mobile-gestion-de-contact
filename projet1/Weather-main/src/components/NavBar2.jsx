import React from 'react'
import {NavLink} from 'react-router-dom'

export default function NavBar() {
  return (
    <nav className="navbar">
      <ul className="nav-linkq">
        <li>
          <NavLink 
          to="/"
          className={({isActive}) => (isActive ? 'active' : '')}
          >Home</NavLink>
        </li>
        <li>
          <Link to="/Weather">Weather</Link>
        </li>
        <li>
            <Link to="/About">About</Link>  
          </li>
      </ul>
    </nav>
  )
}
