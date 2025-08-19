<script setup>
import { ref } from 'vue';
import apiClient from '../utils/axios';

// Reactive variables to manage component state
const jobs = ref([]);
const isLoading = ref(false);
const error = ref(null);

// Function to fetch job listings from the backend
const fetchJobs = async () => {
  isLoading.value = true;
  error.value = null;
  jobs.value = []; // Clear previous results

  try {
    // Make the API call to the specified endpoint
    const response = await apiClient.get('/user/search_jobs');
    
    // The response data is an array of job objects
    // Map the incoming data to match the component's expected structure
    jobs.value = response.data.map(job => ({
      id: job._id,
      title: job.JobTitle,
      company: job.CompanyName,
      description: job.JobDescription,
      tags: job.JobTags,
      postedDate: new Date(job.createdAt).toLocaleDateString()
    }));
  } catch (err) {
    // Handle API call errors
    error.value = "Failed to load job listings. Please try again.";
    console.error(err);
  } finally {
    // Set loading state to false once data is fetched or an error occurs
    isLoading.value = false;
  }
};
</script>

<template>
  <div class="p-8 text-white min-h-screen">
    <h1 class="text-4xl font-extrabold text-center mb-8">
      <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">
        Job Search Results
      </span>
    </h1>

    <div class="text-center mb-8">
      <button 
        @click="fetchJobs"
        :disabled="isLoading"
        class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-full transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <span v-if="isLoading">Searching...</span>
        <span v-else>Search Jobs</span>
      </button>
    </div>

    <!-- Initial state or empty state after search -->
    <div v-if="!jobs.length && !isLoading && !error" class="text-center bg-gray-800 p-12 rounded-2xl">
      <p class="text-2xl text-gray-300">Click "Search Jobs" to find available listings.</p>
    </div>

    <!-- Loading state -->
    <div v-else-if="isLoading" class="text-center text-gray-400">
      <p>Loading jobs...</p>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="text-center text-red-500">
      <p>{{ error }}</p>
    </div>

    <!-- Job listings -->
    <div v-else class="space-y-6">
      <div 
        v-for="job in jobs" 
        :key="job.id" 
        class="bg-gray-800 p-6 rounded-2xl shadow-lg transition-transform transform hover:scale-[1.01] animate-fade-in-up"
      >
        <div class="flex justify-between items-start mb-2">
          <div>
            <h2 class="text-2xl font-bold">{{ job.title }}</h2>
            <span class="text-sm text-gray-400">{{ job.company }}</span><br>
            <span class="text-sm text-gray-400">Posted: {{ job.postedDate }}</span>
          </div>
        </div>
        <p class="text-gray-300 mb-4">{{ job.description }}</p>
        <div class="flex flex-wrap gap-2">
          <span
            v-for="tag in job.tags"
            :key="tag"
            class="bg-blue-600 text-white text-xs font-semibold px-2.5 py-1 rounded-full"
          >
            {{ tag }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fade-in-up {
  animation: fadeInUp 0.8s ease-out forwards;
  opacity: 0;
}
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}
</style>
