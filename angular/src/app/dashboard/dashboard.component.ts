import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';

interface Comment {
  username: string;
  text: string;
  date: string;
}

interface Concert {
  id: number;
  artistName: string;
  concertName: string;
  musicStyle: string;
  date: string;
  startTime: string;
  city: string;
  country: string;
  price: number;
  imageColor: string;
  comments: Comment[];
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent implements OnInit {
  // Propriété pour la recherche
  searchQuery: string = '';
  
  showStyles = false;
  showDates = false;
  showLocations = false;
  
  // Propriétés pour les commentaires
  showComments = false;
  selectedConcert: Concert | null = null;
  newComment: string = '';
  
  // Propriétés pour l'administration
  isAdmin = false;
  showAddConcertForm = false;
  newConcert: Partial<Concert> = {
    artistName: '',
    concertName: '',
    musicStyle: '',
    date: '',
    startTime: '',
    city: '',
    country: '',
    price: 0,
    imageColor: '#0C0C24',
    comments: []
  };

  // Styles musicaux
  musicStyles = [
    'Rock', 'Pop', 'Metal', 'Hip-Hop', 'Jazz', 
    'Électronique', 'Classique', 'Folk', 'R&B', 'Reggae'
  ];
  
  // Options pour les dates
  featuredYears = [2024, 2025, 2026];
  otherYears = [2023, 2027, 2028];
  months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  
  // Pour suivre les sélections
  selectedYear: number | null = null;
  selectedCountry: string | null = null;
  selectedStyle: string | null = null;
  
  // Données pour les zones géographiques
  countries = ['France', 'Suisse', 'Belgique', 'Allemagne', 'Espagne'];
  
  // Villes par pays (simulant des données de BDD)
  citiesByCountry: { [key: string]: string[] } = {
    'France': ['Paris', 'Lyon', 'Marseille', 'Nancy', 'Strasbourg', 'Amnéville', 'Maxéville'],
    'Suisse': ['Genève', 'Zurich', 'Berne', 'Lausanne'],
    'Belgique': ['Bruxelles', 'Liège', 'Anvers', 'Gand'],
    'Allemagne': ['Berlin', 'Munich', 'Francfort', 'Cologne'],
    'Espagne': ['Madrid', 'Barcelone', 'Valence', 'Séville']
  };
  
  // Données fictives de concerts
  concerts: Concert[] = [];
  filteredConcerts: Concert[] = [];
  
  users = [
    { username: 'user1', email: 'user1@example.com', role: 'Utilisateur' },
    { username: 'admin', email: 'admin@example.com', role: 'Administrateur' },
  ];

  reportedMessages = [
    { id: 1, content: 'Message inapproprié' },
    { id: 2, content: 'Spam détecté' },
  ];

  stats = {
    totalUsers: 100,
    messagesToday: 500,
    activeUsers: 75,
  };

  constructor(private router: Router, public authService: AuthService) {}
  
  ngOnInit(): void {
    // Vérifier si l'utilisateur est administrateur
    this.isAdmin = this.authService.isAdmin();
    
    // Générer 35 concerts fictifs
    this.generateMockConcerts(35);
    this.filteredConcerts = [...this.concerts];

    // Charger les données initiales ici
  }

  // Méthode pour se déconnecter
  logout(): void {
    this.authService.logout();
  }
  
  // Méthode pour ajouter un concert (admin seulement)
  addConcert(): void {
    if (!this.isAdmin) return;
    
    if (!this.newConcert.artistName || !this.newConcert.date || !this.newConcert.city || !this.newConcert.country) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }
    
    const newId = this.concerts.length > 0 ? Math.max(...this.concerts.map(c => c.id)) + 1 : 1;
    
    this.concerts.push({
      id: newId,
      artistName: this.newConcert.artistName!,
      concertName: this.newConcert.concertName || `${this.newConcert.artistName} en concert`,
      musicStyle: this.newConcert.musicStyle || 'Pop',
      date: this.newConcert.date!,
      startTime: this.newConcert.startTime || '20:00',
      city: this.newConcert.city!,
      country: this.newConcert.country!,
      price: this.newConcert.price || 0,
      imageColor: this.newConcert.imageColor || '#0C0C24',
      comments: []
    });
    
    // Réinitialiser le formulaire et mettre à jour les concerts filtrés
    this.newConcert = {
      artistName: '',
      concertName: '',
      musicStyle: '',
      date: '',
      startTime: '',
      city: '',
      country: '',
      price: 0,
      imageColor: '#0C0C24',
      comments: []
    };
    
    this.showAddConcertForm = false;
    this.filteredConcerts = [...this.concerts];
  }
  
  // Méthode pour supprimer un concert (admin seulement)
  deleteConcert(id: number): void {
    if (!this.isAdmin) return;
    
    if (confirm('Êtes-vous sûr de vouloir supprimer ce concert ?')) {
      this.concerts = this.concerts.filter(concert => concert.id !== id);
      this.filteredConcerts = this.filteredConcerts.filter(concert => concert.id !== id);
    }
  }
  
  // Méthode pour générer des concerts fictifs
  private generateMockConcerts(count: number) {
    const artists = ['Imagine Dragons', 'Coldplay', 'Adele', 'Ed Sheeran', 'The Weeknd', 
      'Billie Eilish', 'Daft Punk', 'Metallica', 'Queen', 'AC/DC', 'Linkin Park',
      'Black Eyed Peas', 'David Guetta', 'Calvin Harris', 'Dua Lipa', 'Lady Gaga'];
      
    const colors = ['#FF5733', '#33FF57', '#3357FF', '#F3FF33', '#FF33F3', 
      '#33FFF3', '#F333FF', '#FF3333', '#33FF33', '#3333FF'];
    
    const sampleComments = [
      { username: 'fan2000', text: 'J\'ai hâte d\'y être !', date: '15/04/2025' },
      { username: 'musiclover', text: 'Ce concert va être incroyable !', date: '10/04/2025' },
      { username: 'rockstar', text: 'J\'ai vu cet artiste l\'année dernière, ça valait vraiment le coup !', date: '05/04/2025' }
    ];
      
    for (let i = 0; i < count; i++) {
      const artist = artists[Math.floor(Math.random() * artists.length)];
      const style = this.musicStyles[Math.floor(Math.random() * this.musicStyles.length)];
      const country = this.countries[Math.floor(Math.random() * this.countries.length)];
      
      // Générer une date entre 2024 et 2026
      const year = 2024 + Math.floor(Math.random() * 3);
      const month = Math.floor(Math.random() * 12) + 1;
      const day = Math.floor(Math.random() * 28) + 1;
      
      // Formater la date en DD/MM/YYYY
      const date = `${day.toString().padStart(2, '0')}/${month.toString().padStart(2, '0')}/${year}`;
      
      // Générer une heure aléatoire entre 18:00 et 22:00
      const hour = 18 + Math.floor(Math.random() * 5);
      const startTime = `${hour}:00`;
      
      // Générer un prix entre 20 et 200
      const price = Math.round((20 + Math.random() * 180) * 100) / 100;
      
      // Sélectionner une ville du pays choisi
      const cities = this.citiesByCountry[country];
      const city = cities[Math.floor(Math.random() * cities.length)];
      
      // Sélectionner une couleur aléatoire pour l'image
      const imageColor = colors[Math.floor(Math.random() * colors.length)];
      
      // Générer des commentaires aléatoires (0 à 3)
      const commentsCount = Math.floor(Math.random() * 4); // 0 à 3 commentaires
      const comments: Comment[] = [];
      
      for (let j = 0; j < commentsCount; j++) {
        const randomComment = {...sampleComments[j % sampleComments.length]};
        comments.push(randomComment);
      }
      
      this.concerts.push({
        id: i + 1,
        artistName: artist,
        concertName: `${artist} World Tour`,
        musicStyle: style,
        date: date,
        startTime: startTime,
        city: city,
        country: country,
        price: price,
        imageColor: imageColor,
        comments: comments
      });
    }
  }
  
  // Méthodes pour les commentaires
  openComments(concert: Concert): void {
    this.selectedConcert = concert;
    this.showComments = true;
  }
  
  closeComments(event: Event): void {
    // Fermer uniquement si on clique sur l'overlay ou le bouton de fermeture
    if (
      (event.target as HTMLElement).classList.contains('comments-overlay') ||
      (event.target as HTMLElement).classList.contains('close-button')
    ) {
      this.showComments = false;
      this.selectedConcert = null;
      this.newComment = '';
    }
  }
  
  addComment(): void {
    if (this.newComment.trim() && this.selectedConcert) {
      const today = new Date();
      const formattedDate = `${today.getDate().toString().padStart(2, '0')}/${(today.getMonth() + 1).toString().padStart(2, '0')}/${today.getFullYear()}`;
      
      const currentUser = this.authService.getCurrentUser();
      const username = currentUser ? currentUser.username : 'Invité';
      
      this.selectedConcert.comments.push({
        username: username,
        text: this.newComment.trim(),
        date: formattedDate
      });
      
      this.newComment = '';
    }
  }
  
  // Méthode pour appliquer la recherche
  applySearch() {
    this.applyFilters();
  }
  
  toggleStyles() {
    this.showStyles = !this.showStyles;
    // Fermer les autres filtres
    this.showDates = false;
    this.showLocations = false;
  }
  
  toggleDates() {
    this.showDates = !this.showDates;
    // Fermer les autres filtres
    this.showStyles = false;
    this.showLocations = false;
  }
  
  toggleLocations() {
    this.showLocations = !this.showLocations;
    // Fermer les autres filtres
    this.showStyles = false;
    this.showDates = false;
  }
  
  selectYear(year: number) {
    if (this.selectedYear === year) {
      this.selectedYear = null; // Désélectionner si déjà sélectionné
    } else {
      this.selectedYear = year;
    }
    this.applyFilters();
  }
  
  selectCountry(country: string) {
    if (this.selectedCountry === country) {
      this.selectedCountry = null; // Désélectionner si déjà sélectionné
    } else {
      this.selectedCountry = country;
    }
    this.applyFilters();
  }
  
  selectStyle(style: string) {
    if (this.selectedStyle === style) {
      this.selectedStyle = null;
    } else {
      this.selectedStyle = style;
    }
    this.applyFilters();
  }
  
  filterByMonth(year: number, month: number) {
    const monthStr = String(month + 1).padStart(2, '0');
    
    this.filteredConcerts = this.concerts.filter(concert => {
      const parts = concert.date.split('/');
      const concertMonth = parts[1];
      const concertYear = parts[2];
      return concertYear === String(year) && concertMonth === monthStr;
    });
  }
  
  filterByYear(year: number) {
    this.filteredConcerts = this.concerts.filter(concert => {
      const parts = concert.date.split('/');
      return parts[2] === String(year);
    });
  }
  
  filterByCountry(country: string) {
    this.filteredConcerts = this.concerts.filter(concert => 
      concert.country === country
    );
  }
  
  filterByCity(country: string, city: string) {
    this.filteredConcerts = this.concerts.filter(concert => 
      concert.country === country && concert.city === city
    );
  }
  
  private applyFilters() {
    // Réinitialiser les concerts filtrés à tous les concerts
    let filtered = [...this.concerts];
    
    // Appliquer le filtre de recherche
    if (this.searchQuery.trim()) {
      const query = this.searchQuery.toLowerCase().trim();
      filtered = filtered.filter(concert => 
        concert.artistName.toLowerCase().includes(query) ||
        concert.concertName.toLowerCase().includes(query) ||
        concert.city.toLowerCase().includes(query) ||
        concert.country.toLowerCase().includes(query) ||
        concert.musicStyle.toLowerCase().includes(query)
      );
    }
    
    // Appliquer les filtres sélectionnés
    if (this.selectedYear) {
      filtered = filtered.filter(concert => {
        const parts = concert.date.split('/');
        return parts[2] === String(this.selectedYear);
      });
    }
    
    if (this.selectedCountry) {
      filtered = filtered.filter(concert => 
        concert.country === this.selectedCountry
      );
    }
    
    if (this.selectedStyle) {
      filtered = filtered.filter(concert => 
        concert.musicStyle === this.selectedStyle
      );
    }
    
    this.filteredConcerts = filtered;
  }

  promoteToAdmin(user: any): void {
    user.role = 'Administrateur';
    alert(`${user.username} est maintenant administrateur.`);
  }

  banUser(user: any): void {
    this.users = this.users.filter(u => u !== user);
    alert(`${user.username} a été banni.`);
  }

  deleteUser(user: any): void {
    this.users = this.users.filter(u => u !== user);
    alert(`${user.username} a été supprimé.`);
  }

  deleteMessage(message: any): void {
    this.reportedMessages = this.reportedMessages.filter(m => m !== message);
    alert('Message supprimé.');
  }

  ignoreReport(message: any): void {
    this.reportedMessages = this.reportedMessages.filter(m => m !== message);
    alert('Signalement ignoré.');
  }
}