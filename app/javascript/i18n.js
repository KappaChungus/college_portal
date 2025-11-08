// Simple i18n system for College Portal
class I18n {
  constructor() {
    this.currentLang = localStorage.getItem('language') || 'en';
    this.translations = {
      en: {
        // Navigation
        dashboard: 'Dashboard',
        study_progress: 'Study Progress',
        schedule: 'Schedule',
        petitions: 'Petitions',
        surveys: 'Surveys',
        
        // Common actions
        loading: 'Loading...',
        submit: 'Submit',
        cancel: 'Cancel',
        save: 'Save',
        edit: 'Edit',
        delete: 'Delete',
        close: 'Close',
        back: 'Back',
        
        // Header
        profile: 'Profile',
        logout: 'Log Out',
        hello: 'Hello',
        
        // Study Progress page
        study_progress_title: 'Study Progress',
        student_profile_label: 'Student Profile',
        study_name_label: 'Study Name',
        study_year_label: 'Study Year',
        semester_label: 'Semester',
        specialization_label: 'Specialization',
        my_groups: 'My Groups',
        my_courses: 'My Courses',
        code: 'Code',
        course_title: 'Course Title',
        teacher: 'Teacher',
        status: 'Status',
        final_grade: 'Final Grade',
        no_groups: 'No groups assigned',
        no_courses: 'No courses enrolled',
        load_error: 'Error loading data',
        current_courses: 'Current Courses',
        passed_courses: 'Passed Courses',
        failed_courses: 'Failed Courses',
        show_passed_courses: 'Show Passed Courses',
        hide_passed_courses: 'Hide Passed Courses',
        show_failed_courses: 'Show Failed Courses',
        hide_failed_courses: 'Hide Failed Courses',
        course_grades: 'Course Grades',
        test_grades: 'Test Grades',
        
        // Dashboard
        announcements: 'Announcements',
        latest_grades: 'Latest Grades',
        no_announcements: 'No announcements available',
        by: 'By',
        previous: 'Previous',
        next: 'Next',
        
        // Petitions page
        my_petitions: 'My Petitions',
        new_petition: 'New Petition',
        back_to_petitions: 'Back to Petitions',
        topic: 'Topic',
        content: 'Content',
        submit_petition: 'Submit Petition',
        no_petitions: 'No petitions',
        no_petitions_message: 'Get started by creating a new petition.',
        loading_petitions: 'Loading petitions...',
        loading_topics: 'Loading topics...',
        select_topic: 'Select a topic...',
        petition_placeholder: 'Describe your petition in detail...',
        submitting: 'Submitting...',
        petition_success: 'Petition submitted successfully! Redirecting...',
        required_fields: 'Please fill in all required fields',
        submit_error: 'An error occurred while submitting your petition. Please try again.',
        
        // Schedule page
        weekly_schedule: 'Weekly Schedule',
        loading_schedule: 'Loading schedule...',
        no_schedule: 'No schedule available',
        time: 'Time',
        monday: 'Monday',
        tuesday: 'Tuesday',
        wednesday: 'Wednesday',
        thursday: 'Thursday',
        friday: 'Friday',
        saturday: 'Saturday',
        sunday: 'Sunday',
        room: 'Room',
        
        // Surveys page
        teacher_surveys: 'Teacher Surveys',
        rate_your_teachers: 'Rate Your Teachers',
        your_submitted_surveys: 'Your Submitted Surveys',
        rate_teacher: 'Rate Teacher',
        quality_of_classes: 'Quality of Classes Conducted',
        ease_of_communication: 'Ease of Communication',
        fair_and_clear_conditions: 'Fair and Clear Conditions',
        detailed_opinion: 'Detailed Opinion (Optional)',
        submit_survey: 'Submit Survey',
        loading_teachers: 'Loading teachers...',
        loading_surveys: 'Loading surveys...',
        no_teachers_to_rate: 'All teachers have been rated or no current courses available',
        no_surveys_submitted: 'No surveys submitted yet',
        already_rated: 'Already Rated',
        rated: 'Rated',
        opinion_placeholder: 'Share your thoughts about the teacher...',
        
        // Teacher navigation
        students: 'Students',
        grades: 'Grades',
        survey_results: 'Survey Results',
        
        // Teacher surveys page
        average_ratings: 'Average Ratings',
        individual_surveys: 'Individual Surveys',
        based_on: 'Based on',
        surveys: 'surveys',
        no_surveys: 'No surveys available',
        
        // Teacher courses page
        view_details: 'View details',
        back_to_courses: 'Back to Courses',
        group: 'Group',
        email: 'Email',
        actions: 'Actions',
        no_students: 'No students enrolled',
        view_grades: 'View Grades',
        add_grade: 'Add Grade',
        edit_grade: 'Edit Grade',
        name: 'Name',
        grade_name: 'Grade Name',
        mark: 'Mark',
        no_grades: 'No grades recorded yet'
      },
      pl: {
        // Navigation  
        dashboard: 'Panel główny',
        study_progress: 'Postęp studiów',
        schedule: 'Plan zajęć',
        petitions: 'Podania',
        surveys: 'Ankiety',
        
        // Common actions
        loading: 'Ładowanie...',
        submit: 'Wyślij',
        cancel: 'Anuluj',
        save: 'Zapisz',
        edit: 'Edytuj',
        delete: 'Usuń',
        close: 'Zamknij',
        back: 'Powrót',
        
        // Header
        profile: 'Profil',
        logout: 'Wyloguj',
        hello: 'Witaj',
        
        // Study Progress page
        study_progress_title: 'Postęp studiów',
        student_profile_label: 'Profil studenta',
        study_name_label: 'Kierunek',
        study_year_label: 'Rok studiów',
        semester_label: 'Semestr',
        specialization_label: 'Specjalizacja',
        my_groups: 'Moje grupy',
        my_courses: 'Moje kursy',
        code: 'Kod',
        course_title: 'Tytuł kursu',
        teacher: 'Wykładowca',
        status: 'Status',
        final_grade: 'Ocena końcowa',
        no_groups: 'Brak przypisanych grup',
        no_courses: 'Brak zapisanych kursów',
        load_error: 'Błąd wczytywania danych',
        current_courses: 'Aktywne kursy',
        passed_courses: 'Zaliczone kursy',
        failed_courses: 'Niezaliczone kursy',
        show_passed_courses: 'Pokaż zaliczone kursy',
        hide_passed_courses: 'Ukryj zaliczone kursy',
        show_failed_courses: 'Pokaż niezaliczone kursy',
        hide_failed_courses: 'Ukryj niezaliczone kursy',
        course_grades: 'Oceny z kursu',
        test_grades: 'Oceny z testów',
        
        // Dashboard
        announcements: 'Ogłoszenia',
        latest_grades: 'Ostatnie oceny',
        no_announcements: 'Brak ogłoszeń',
        by: 'Przez',
        previous: 'Poprzednia',
        next: 'Następna',
        
        // Petitions page
        my_petitions: 'Moje podania',
        new_petition: 'Nowe podanie',
        back_to_petitions: 'Powrót do podań',
        topic: 'Temat',
        content: 'Treść',
        submit_petition: 'Wyślij podanie',
        no_petitions: 'Brak podań',
        no_petitions_message: 'Zacznij od utworzenia nowego podania.',
        loading_petitions: 'Ładowanie podań...',
        loading_topics: 'Ładowanie tematów...',
        select_topic: 'Wybierz temat...',
        petition_placeholder: 'Opisz szczegółowo swoje podanie...',
        submitting: 'Wysyłanie...',
        petition_success: 'Podanie zostało wysłane pomyślnie! Przekierowanie...',
        required_fields: 'Proszę wypełnić wszystkie wymagane pola',
        submit_error: 'Wystąpił błąd podczas wysyłania podania. Spróbuj ponownie.',
        
        // Schedule page
        weekly_schedule: 'Plan zajęć',
        loading_schedule: 'Ładowanie planu...',
        no_schedule: 'Brak planu zajęć',
        time: 'Godzina',
        monday: 'Poniedziałek',
        tuesday: 'Wtorek',
        wednesday: 'Środa',
        thursday: 'Czwartek',
        friday: 'Piątek',
        saturday: 'Sobota',
        sunday: 'Niedziela',
        room: 'Sala',
        
        // Surveys page
        teacher_surveys: 'Ankiety nauczycieli',
        rate_your_teachers: 'Oceń swoich wykładowców',
        your_submitted_surveys: 'Twoje wysłane ankiety',
        rate_teacher: 'Oceń wykładowcę',
        quality_of_classes: 'Jakość prowadzonych zajęć',
        ease_of_communication: 'Łatwość komunikacji',
        fair_and_clear_conditions: 'Uczciwe i jasne warunki',
        detailed_opinion: 'Szczegółowa opinia (Opcjonalne)',
        submit_survey: 'Wyślij ankietę',
        loading_teachers: 'Ładowanie wykładowców...',
        loading_surveys: 'Ładowanie ankiet...',
        no_teachers_to_rate: 'Wszyscy wykładowcy zostali ocenieni lub brak aktualnych kursów',
        no_surveys_submitted: 'Nie wysłano jeszcze żadnych ankiet',
        already_rated: 'Już oceniony',
        rated: 'Oceniony',
        opinion_placeholder: 'Podziel się swoimi przemyśleniami o wykładowcy...',
        
        // Teacher navigation
        students: 'Studenci',
        grades: 'Oceny',
        survey_results: 'Wyniki ankiet',
        
        // Teacher surveys page
        average_ratings: 'Średnie oceny',
        individual_surveys: 'Poszczególne ankiety',
        based_on: 'Na podstawie',
        surveys: 'ankiet',
        no_surveys: 'Brak dostępnych ankiet',
        
        // Teacher courses page
        view_details: 'Zobacz szczegóły',
        back_to_courses: 'Powrót do kursów',
        group: 'Grupa',
        email: 'Email',
        actions: 'Akcje',
        no_students: 'Brak zapisanych studentów',
        view_grades: 'Zobacz oceny',
        add_grade: 'Dodaj ocenę',
        edit_grade: 'Edytuj ocenę',
        name: 'Imię',
        grade_name: 'Nazwa oceny',
        mark: 'Ocena',
        no_grades: 'Nie zapisano jeszcze żadnych ocen'

      }
    };
  }
  
  t(key) {
    return this.translations[this.currentLang]?.[key] || this.translations.en[key] || key;
  }
  
  setLanguage(lang) {
    if (this.translations[lang]) {
      this.currentLang = lang;
      localStorage.setItem('language', lang);
      this.updateUI();
      
      // Dispatch event for other components to listen
      document.dispatchEvent(new CustomEvent('languageChanged', { 
        detail: { language: lang } 
      }));
    }
  }
  
  getCurrentLanguage() {
    return this.currentLang;
  }
  
  updateUI() {
    // Update language indicator
    const langIndicator = document.getElementById('current-language');
    if (langIndicator) {
      langIndicator.textContent = this.currentLang.toUpperCase();
    }
    
    // Update all elements with data-i18n attribute
    document.querySelectorAll('[data-i18n]').forEach(element => {
      const key = element.getAttribute('data-i18n');
      const translation = this.t(key);
      
      if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
        const attr = element.getAttribute('data-i18n-attr') || 'placeholder';
        element[attr] = translation;
      } else {
        // Preserve HTML content if has data-i18n-html
        if (element.hasAttribute('data-i18n-html')) {
          element.innerHTML = translation;
        } else {
          element.textContent = translation;
        }
      }
    });
  }
  
  init() {
    this.updateUI();
    
    // Re-apply on Turbo navigation
    document.addEventListener('turbo:load', () => {
      this.updateUI();
    });
    
    // Re-apply on Turbo render
    document.addEventListener('turbo:render', () => {
      this.updateUI();
    });
  }
}

// Create global instance immediately
const i18n = new I18n();

// Export for use in other scripts immediately (before DOMContentLoaded)
window.i18n = i18n;

// Global function for language change - define immediately
window.changeLanguage = function(lang) {
  i18n.setLanguage(lang);
  
  // Close dropdown
  const dropdown = document.getElementById('language-dropdown');
  if (dropdown) {
    dropdown.classList.add('hidden');
  }
};

// Export translation function immediately
window.t = (key) => i18n.t(key);

// Initialize on DOM ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => i18n.init());
} else {
  i18n.init();
}
