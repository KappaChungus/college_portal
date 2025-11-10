# Frontend Structure Improvements - Implementation Guide

## 📊 Analysis Summary

### Code Duplication Found
- **CSRF Token fetching**: 40+ repetitions
- **Loading state management**: Repeated in every view
- **API fetch boilerplate**: Duplicated error handling and headers
- **Dark mode + Language selector**: Identical code in student and teacher layouts
- **Modal open/close logic**: Repeated across multiple views
- **Turbo navigation handlers**: Similar patterns everywhere

---

## ✅ Implemented Improvements

### 1. JavaScript Utilities Created

#### `/app/javascript/utils/api.js`
**Purpose**: Centralize all API calls with automatic CSRF token handling

**Functions**:
- `getCsrfToken()` - Get CSRF token from meta tag
- `apiRequest(url, options)` - Base authenticated request
- `apiGet(url)` - GET request wrapper
- `apiPost(url, data)` - POST request wrapper
- `apiPut(url, data)` - PUT request wrapper
- `apiDelete(url)` - DELETE request wrapper

**Usage Example**:
```javascript
import { apiGet, apiPost } from 'utils/api';

// Instead of:
const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
const response = await fetch('/api/student/courses', {
  headers: { 'X-CSRF-Token': csrfToken, 'Accept': 'application/json' },
  credentials: 'same-origin'
});
const data = await response.json();

// Use:
const data = await apiGet('/api/student/courses');
```

#### `/app/javascript/utils/dom.js`
**Purpose**: Common DOM manipulation utilities

**Functions**:
- `show(element)` - Remove 'hidden' class
- `hide(element)` - Add 'hidden' class
- `toggle(element)` - Toggle 'hidden' class
- `setLoadingState(sectionId, state)` - Manage loading/success/error states
- `openModal(modal)` / `closeModal(modal)` - Modal management
- `clearForm(form)` - Reset form
- `setText(element, text)` / `setHtml(element, html)` - Safe content updates

**Usage Example**:
```javascript
import { setLoadingState, hide, show } from 'utils/dom';

// Instead of:
document.getElementById('announcements-loading').classList.remove('hidden');
document.getElementById('announcements-content').classList.add('hidden');
document.getElementById('announcements-error').classList.add('hidden');

// Use:
setLoadingState('announcements', 'loading');
// ... after success
setLoadingState('announcements', 'success');
```

#### `/app/javascript/utils/turbo.js`
**Purpose**: Turbo navigation helpers

**Functions**:
- `setupTurboHandlers(loadDataFn, resetStateFn)` - Setup load/cache handlers
- `onTurboLoad(fn)` - Execute on page load
- `beforeTurboCache(fn)` - Execute before cache

**Usage Example**:
```javascript
import { setupTurboHandlers } from 'utils/turbo';

// Instead of:
document.addEventListener('turbo:load', loadDashboardData);
document.addEventListener('turbo:before-cache', () => {
  setLoadingState('announcements', 'loading');
});

// Use:
setupTurboHandlers(
  loadDashboardData,
  () => setLoadingState('announcements', 'loading')
);
```

### 2. View Partials Created

#### `/app/views/shared/_header.html.erb`
**Purpose**: Shared header with dark mode, language selector, and user menu

**Benefits**:
- Eliminates duplicate header code in student/teacher layouts
- Centralized dark mode and language logic
- Easier to maintain and update

**Usage**:
```erb
<%= render 'shared/header' %>
```

#### `/app/views/shared/_loading_state.html.erb`
**Purpose**: Reusable loading/content/error state component

**Parameters**:
- `section_id` - Base ID for the section (default: 'content')
- `loading_text` - Loading message (default: 'Loading...')
- `error_text` - Error message

**Usage**:
```erb
<%= render 'shared/loading_state', 
  section_id: 'announcements',
  loading_text: 'Loading announcements...',
  error_text: 'Failed to load announcements' %>
```

#### `/app/views/shared/_modal.html.erb`
**Purpose**: Reusable modal component

**Parameters**:
- `modal_id` - Unique modal ID
- `title` - Modal title
- `size` - Modal size ('sm', 'md', 'lg', 'xl', '2xl')

**Usage**:
```erb
<%= render 'shared/modal', 
  modal_id: 'add-announcement-modal',
  title: 'Add Announcement',
  size: 'lg' do %>
  <!-- Modal content here -->
<% end %>
```

---

## 📝 Next Steps: Migration Guide

### Phase 1: Update Layouts (High Priority)

#### 1.1 Update `/app/views/layouts/student.html.erb`
Replace lines 16-68 (header section) with:
```erb
<%= render 'shared/header' %>
```

#### 1.2 Update `/app/views/layouts/teacher.html.erb`
Replace lines 16-68 (header section) with:
```erb
<%= render 'shared/header' %>
```

### Phase 2: Refactor Dashboard Views

#### 2.1 Update `/app/views/student_frontend/dashboard.html.erb`

**Before** (lines 136-160):
```javascript
async function loadDashboardData() {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
  
  if (!csrfToken) {
    console.error('CSRF token not found');
    return;
  }

  try {
    const announcementsResponse = await fetch('/api/student/announcements', {
      headers: {
        'X-CSRF-Token': csrfToken,
        'Accept': 'application/json'
      },
      credentials: 'same-origin'
    });
    // ...
```

**After**:
```javascript
import { apiGet } from 'utils/api';
import { setLoadingState } from 'utils/dom';
import { setupTurboHandlers } from 'utils/turbo';

async function loadDashboardData() {
  try {
    setLoadingState('announcements', 'loading');
    const announcements = await apiGet('/api/student/announcements');
    allAnnouncements = announcements;
    renderAnnouncements();
    setLoadingState('announcements', 'success');
  } catch (error) {
    console.error('Failed to load announcements:', error);
    setLoadingState('announcements', 'error');
  }
}

setupTurboHandlers(loadDashboardData);
```

#### 2.2 Similar updates for:
- `/app/views/teacher_frontend/dashboard.html.erb`
- `/app/views/student_frontend/study_progress.html.erb`
- `/app/views/student_frontend/surveys.html.erb`
- `/app/views/teacher_frontend/profile.html.erb`

### Phase 3: Replace Modal Implementations

Update modals to use the shared component:

**Before**:
```html
<div id="add-announcement-modal" class="hidden fixed inset-0 bg-black bg-opacity-50...">
  <div class="bg-white rounded-lg...">
    <div class="flex justify-between...">
      <h3>Add Announcement</h3>
      <button onclick="closeAddModal()">X</button>
    </div>
    <!-- content -->
  </div>
</div>
```

**After**:
```erb
<%= render 'shared/modal', 
  modal_id: 'add-announcement-modal',
  title: 'Add Announcement',
  size: 'lg' do %>
  <!-- Just the form content here -->
<% end %>
```

### Phase 4: Replace Loading States

**Before**:
```html
<div id="announcements-loading" class="flex items-center justify-center py-12">
  <div class="animate-spin..."></div>
  <p>Loading...</p>
</div>
<div id="announcements-content" class="hidden">
  <!-- content -->
</div>
<div id="announcements-error" class="hidden">
  <!-- error -->
</div>
```

**After**:
```erb
<%= render 'shared/loading_state', 
  section_id: 'announcements',
  loading_text: 'Loading announcements...' do %>
  <!-- Content goes here -->
<% end %>
```

---

## 📈 Expected Benefits

### Code Reduction
- **~60% reduction** in JavaScript boilerplate
- **~40% reduction** in HTML repetition
- **~50% reduction** in loading state code

### Maintenance
- Single source of truth for API calls
- Centralized error handling
- Easier to add features (e.g., retry logic, rate limiting)

### Consistency
- Uniform API call patterns
- Consistent loading states across all pages
- Standardized modal behavior

### Developer Experience
- Cleaner, more readable code
- Faster development of new features
- Reduced cognitive load

---

## 🚀 Priority Recommendations

### Immediate (Do First)
1. ✅ **DONE**: Create JavaScript utilities
2. ✅ **DONE**: Create shared partials
3. **TODO**: Replace headers in both layouts
4. **TODO**: Update dashboard views to use new utilities

### Short Term (Next)
5. **TODO**: Migrate all API calls to use `api.js` utilities
6. **TODO**: Replace all loading states with `_loading_state.html.erb`
7. **TODO**: Migrate modals to `_modal.html.erb`

### Long Term (Nice to Have)
8. Consider using Stimulus controllers for complex interactions
9. Add global error notification system
10. Implement request caching/deduplication

---

## 💡 Usage Notes

### Importing Utilities
Add to your view's `<script>` tag:
```javascript
import { apiGet, apiPost } from 'utils/api';
import { show, hide, setLoadingState } from 'utils/dom';
import { setupTurboHandlers } from 'utils/turbo';
```

### Working with Existing Code
You can migrate incrementally:
1. Start with one view (e.g., dashboard)
2. Test thoroughly
3. Move to next view
4. No need to migrate everything at once

---

## 🔍 Files to Update (Checklist)

### High Priority
- [ ] `/app/views/layouts/student.html.erb` - Replace header
- [ ] `/app/views/layouts/teacher.html.erb` - Replace header
- [ ] `/app/views/student_frontend/dashboard.html.erb` - Use API utils
- [ ] `/app/views/teacher_frontend/dashboard.html.erb` - Use API utils

### Medium Priority
- [ ] `/app/views/student_frontend/study_progress.html.erb`
- [ ] `/app/views/student_frontend/surveys.html.erb`
- [ ] `/app/views/student_frontend/petitions.html.erb`
- [ ] `/app/views/teacher_frontend/profile.html.erb`
- [ ] `/app/views/teacher_frontend/manage_courses.html.erb`
- [ ] `/app/views/teacher_frontend/course.html.erb`

### Lower Priority
- [ ] `/app/views/shared/_schedule.html.erb`
- [ ] `/app/views/teacher_frontend/surveys.html.erb`

---

## 📞 Support

If you encounter issues during migration:
1. Check browser console for import errors
2. Verify importmap configuration includes utilities
3. Ensure CSRF meta tag is present in layout
4. Test with browser dev tools network tab

---

**Total Estimated Time for Full Migration**: 4-6 hours
**Immediate Impact**: Header replacement (15 minutes)
**High ROI**: Dashboard views (2 hours)
