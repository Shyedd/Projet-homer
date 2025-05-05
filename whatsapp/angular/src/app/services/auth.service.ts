// src/app/services/auth.service.ts
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';

export interface User {
  username: string;
  role: 'admin' | 'user' | 'guest';
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private currentUser: User | null = null;
  private users = [
    { username: 'admin', password: 'azerty', role: 'admin' as const },
    { username: 'user', password: 'qwerty', role: 'user' as const }
  ];

  constructor(private router: Router) {
    // Vérifier si localStorage est disponible
    if (this.isLocalStorageAvailable()) {
      const storedUser = localStorage.getItem('currentUser');
      if (storedUser) {
        this.currentUser = JSON.parse(storedUser);
      }
    }
  }

  login(username: string, password: string): boolean {
    const user = this.users.find(u => 
      u.username === username && u.password === password
    );

    if (user) {
      this.currentUser = {
        username: user.username,
        role: user.role
      };
      // Stocker l'utilisateur dans le localStorage (si disponible)
      if (this.isLocalStorageAvailable()) {
        localStorage.setItem('currentUser', JSON.stringify(this.currentUser));
      }
      return true;
    }
    return false;
  }

  logout(): void {
    this.currentUser = null;
    if (this.isLocalStorageAvailable()) {
      localStorage.removeItem('currentUser');
    }
    this.router.navigate(['/']);
  }

  loginAsGuest(): void {
    this.currentUser = {
      username: 'Invité',
      role: 'guest'
    };
    if (this.isLocalStorageAvailable()) {
      localStorage.setItem('currentUser', JSON.stringify(this.currentUser));
    }
    this.router.navigate(['/dashboard']);
  }

  getCurrentUser(): User | null {
    return this.currentUser;
  }

  isLoggedIn(): boolean {
    return this.currentUser !== null;
  }

  isAdmin(): boolean {
    return this.currentUser?.role === 'admin';
  }

  isUser(): boolean {
    return this.currentUser?.role === 'user' || this.currentUser?.role === 'guest';
  }

  private isLocalStorageAvailable(): boolean {
    try {
      return typeof localStorage !== 'undefined';
    } catch {
      return false;
    }
  }
}