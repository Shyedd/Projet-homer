import { Component } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [MatIconModule, CommonModule, FormsModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  username: string = '';
  password: string = '';
  loginError: string | null = null;

  constructor(private router: Router, private authService: AuthService) {}

  scrollToLogin(): void {
    document.getElementById('login-section')?.scrollIntoView({ behavior: 'smooth' });
  }

  onSubmit(): void {
    if (this.authService.login(this.username, this.password)) {
      this.router.navigate(['/dashboard']);
    } else {
      this.loginError = 'Nom d\'utilisateur ou mot de passe incorrect';
    }
  }

  loginAsGuest(): void {
    this.authService.loginAsGuest();
  }
}