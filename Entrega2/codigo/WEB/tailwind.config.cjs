/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        'rasbet-view-black': '#191919',
        'rasbet-logo-gold' : '#D0B600',
        'rasbet-logo-pink' : '#F55CA6',
        'rasbet-blue' : '#56BAEC',
      },
    },
  },
  plugins: [
    require('tailwind-scrollbar'),
  ],
};
