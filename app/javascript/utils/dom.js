// DOM utility functions for common UI operations

/**
 * Show an element by removing 'hidden' class
 * @param {string|HTMLElement} element - Element ID or element itself
 */
export function show(element) {
  const el = typeof element === 'string' ? document.getElementById(element) : element;
  if (el) el.classList.remove('hidden');
}

/**
 * Hide an element by adding 'hidden' class
 * @param {string|HTMLElement} element - Element ID or element itself
 */
export function hide(element) {
  const el = typeof element === 'string' ? document.getElementById(element) : element;
  if (el) el.classList.add('hidden');
}

/**
 * Toggle element visibility
 * @param {string|HTMLElement} element - Element ID or element itself
 */
export function toggle(element) {
  const el = typeof element === 'string' ? document.getElementById(element) : element;
  if (el) el.classList.toggle('hidden');
}

/**
 * Manage loading state for a section
 * @param {string} sectionId - Base ID for the section (e.g., 'announcements')
 * @param {string} state - 'loading', 'success', 'error'
 */
export function setLoadingState(sectionId, state) {
  const loading = document.getElementById(`${sectionId}-loading`);
  const content = document.getElementById(`${sectionId}-content`);
  const error = document.getElementById(`${sectionId}-error`);

  if (!loading || !content || !error) {
    console.warn(`Loading state elements not found for section: ${sectionId}`);
    return;
  }

  switch (state) {
    case 'loading':
      show(loading);
      hide(content);
      hide(error);
      break;
    case 'success':
      hide(loading);
      show(content);
      hide(error);
      break;
    case 'error':
      hide(loading);
      hide(content);
      show(error);
      break;
  }
}

/**
 * Open a modal
 * @param {string|HTMLElement} modal - Modal ID or element
 */
export function openModal(modal) {
  show(modal);
}

/**
 * Close a modal
 * @param {string|HTMLElement} modal - Modal ID or element
 */
export function closeModal(modal) {
  hide(modal);
}

/**
 * Clear form inputs
 * @param {string|HTMLElement} form - Form ID or element
 */
export function clearForm(form) {
  const formEl = typeof form === 'string' ? document.getElementById(form) : form;
  if (formEl && formEl.tagName === 'FORM') {
    formEl.reset();
  }
}

/**
 * Set text content safely
 * @param {string|HTMLElement} element - Element ID or element
 * @param {string} text - Text content
 */
export function setText(element, text) {
  const el = typeof element === 'string' ? document.getElementById(element) : element;
  if (el) el.textContent = text;
}

/**
 * Set HTML content safely
 * @param {string|HTMLElement} element - Element ID or element
 * @param {string} html - HTML content
 */
export function setHtml(element, html) {
  const el = typeof element === 'string' ? document.getElementById(element) : element;
  if (el) el.innerHTML = html;
}

/**
 * Add event listener with automatic cleanup
 * @param {HTMLElement} element - Element to attach listener to
 * @param {string} event - Event name
 * @param {Function} handler - Event handler
 * @returns {Function} Cleanup function
 */
export function addListener(element, event, handler) {
  element.addEventListener(event, handler);
  return () => element.removeEventListener(event, handler);
}
