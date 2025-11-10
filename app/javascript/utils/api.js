// Shared API utility functions

/**
 * Get CSRF token from meta tag
 * @returns {string|null} CSRF token
 */
export function getCsrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.content;
}

/**
 * Make an authenticated API request
 * @param {string} url - API endpoint
 * @param {Object} options - Fetch options
 * @returns {Promise<Response>}
 */
export async function apiRequest(url, options = {}) {
  const csrfToken = getCsrfToken();
  
  if (!csrfToken) {
    console.error('CSRF token not found');
    throw new Error('CSRF token not found');
  }

  const defaultOptions = {
    headers: {
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    credentials: 'same-origin'
  };

  const mergedOptions = {
    ...defaultOptions,
    ...options,
    headers: {
      ...defaultOptions.headers,
      ...options.headers
    }
  };

  return fetch(url, mergedOptions);
}

/**
 * Make a GET request
 * @param {string} url - API endpoint
 * @returns {Promise<any>} Parsed JSON response
 */
export async function apiGet(url) {
  const response = await apiRequest(url, { method: 'GET' });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  return response.json();
}

/**
 * Make a POST request
 * @param {string} url - API endpoint
 * @param {Object} data - Request body
 * @returns {Promise<any>} Parsed JSON response
 */
export async function apiPost(url, data) {
  const response = await apiRequest(url, {
    method: 'POST',
    body: JSON.stringify(data)
  });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  return response.json();
}

/**
 * Make a PUT request
 * @param {string} url - API endpoint
 * @param {Object} data - Request body
 * @returns {Promise<any>} Parsed JSON response
 */
export async function apiPut(url, data) {
  const response = await apiRequest(url, {
    method: 'PUT',
    body: JSON.stringify(data)
  });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  return response.json();
}

/**
 * Make a DELETE request
 * @param {string} url - API endpoint
 * @returns {Promise<any>} Parsed JSON response or null for empty responses
 */
export async function apiDelete(url) {
  const response = await apiRequest(url, { method: 'DELETE' });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  // Check if response has content before trying to parse JSON
  const contentType = response.headers.get('content-type');
  const contentLength = response.headers.get('content-length');
  
  if (response.status === 204 || contentLength === '0' || !contentType?.includes('application/json')) {
    return null;
  }
  
  return response.json();
}
