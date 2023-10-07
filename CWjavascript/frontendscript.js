// script.js
document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('certificationForm');
  form.addEventListener('submit', async (event) => {
    event.preventDefault();
    const formData = new FormData(form);
    try {
      const response = await fetch('/api/certification/register', {
        method: 'POST',
        body: formData,
      });
      if (response.ok) {
        // Handle successful registration
        console.log('Registration successful!');
      } else {
        // Handle registration error
        console.error('Registration failed');
      }
    } catch (error) {
      console.error('Error:', error);
    }
  });
});
