<script setup>
import { RouterLink } from 'vue-router';
</script>

<template>
  <div class="p-8 text-white">
    <div class="py-1.5"></div>

    <div class="flex justify-center items-center h-[calc(100vh-100px)]">
      <div class="text-center">
        <h1 class="text-6xl font-extrabold mb-4 animate-fade-in-up">
          <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">Your Future</span> Starts Here
        </h1>
        <p class="text-xl font-light text-gray-400 mb-8 animate-fade-in-up delay-200">
          Upload your CV, find your dream job, and connect with top companies.
        </p>
        
        <div class="flex justify-center gap-6 animate-fade-in-up delay-400">
          <RouterLink to="/upload" class="
            bg-blue-600 text-white font-bold
            py-3 px-8 rounded-full shadow-lg
            hover:bg-blue-700 transition duration-300 transform hover:scale-105
          ">
            Upload Your CV
          </RouterLink>
          <RouterLink to="/jobs" class="
            bg-transparent border-2 border-gray-500 text-gray-300 font-bold
            py-3 px-8 rounded-full
            hover:bg-gray-700 hover:text-white transition duration-300 transform hover:scale-105
          ">
            Find Jobs
          </RouterLink>
        </div>
      </div>
    </div>

    <div class="">
      <h2 class="text-4xl font-bold text-center mb-12">How It Works</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-10">
        <div class="flex flex-col items-center text-center p-6 bg-gray-800 rounded-lg shadow-lg transform hover:scale-105 transition duration-300">
          <div class="p-4 bg-gray-700 rounded-full mb-4">
            <svg class="h-10 w-10 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 15h2v-6h-2v6zm0-8h2V7h-2v2z"></path>
            </svg>
          </div>
          <h3 class="text-xl font-bold mb-2">Upload Your CV</h3>
          <p class="text-gray-400">Quickly upload your CV and let our system analyze your skills and experience.</p>
        </div>

        <div class="flex flex-col items-center text-center p-6 bg-gray-800 rounded-lg shadow-lg transform hover:scale-105 transition duration-300">
          <div class="p-4 bg-gray-700 rounded-full mb-4">
            <svg class="h-10 w-10 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M16 12l-4 4-4-4"></path>
              <path d="M12 4.5l-4 4-4-4"></path>
              <path d="M12 19.5l4-4 4 4"></path>
              <path d="M12 4.5l4 4-4-4zM12 19.5l4-4-4-4zM12 19.5l-4-4 4 4z"></path>
              <path d="M16 12l4 4-4-4zM16 12l4-4-4-4zM16 12l-4 4-4-4zM16 12l-4-4-4 4z"></path>
              <path d="M12 12l-4 4-4-4zM12 12l4-4-4-4zM12 12l-4-4-4 4zM12 12l-4 4-4-4z"></path>
              <path d="M16 12l4-4-4-4zM16 12l4 4-4-4zM16 12l-4-4-4-4zM16 12l-4 4-4-4z"></path>
            </svg>
          </div>
          <h3 class="text-xl font-bold mb-2">Get Matched with Jobs</h3>
          <p class="text-gray-400">Our smart algorithm finds the perfect job listings that match your profile.</p>
        </div>

        <div class="flex flex-col items-center text-center p-6 bg-gray-800 rounded-lg shadow-lg transform hover:scale-105 transition duration-300">
          <div class="p-4 bg-gray-700 rounded-full mb-4">
            <svg class="h-10 w-10 text-blue-400" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm4-10c0 .55-.45 1-1 1H9c-.55 0-1-.45-1-1V9c0-.55.45-1 1-1h6c.55 0 1 .45 1 1v1zm-3 4h2v2h-2v-2zm0-4h2V9h-2v1zm0-4h2V5h-2v1zm-4 4h2v2h-2v-2zm0-4h2V9h-2v1zm0-4h2V5h-2v1z"></path>
            </svg>
          </div>
          <h3 class="text-xl font-bold mb-2">Apply with One Click</h3>
          <p class="text-gray-400">Apply to jobs effortlessly using your stored CV and profile information.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Keyframe animations for a smooth, modern look */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.8s ease-out forwards;
  opacity: 0; /* Hide elements before animation starts */
}

.delay-200 {
  animation-delay: 0.2s;
}

.delay-400 {
  animation-delay: 0.4s;
}

/* Optional: for the gradient text effect */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}
</style>