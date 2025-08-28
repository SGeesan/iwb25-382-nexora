<script setup>
import { ref, onMounted } from 'vue';
import { TrashIcon } from '@heroicons/vue/24/outline';
import apiClient from '../utils/axios';

const jobs = ref([]);
const isLoading = ref(true);
const error = ref(null);

const fetchJobs = async () => {
  isLoading.value = true;
  error.value = null;

  try {
    const response = await apiClient.get(`/company/get_all_jobs`);

    // Map backend fields to frontend-friendly format
    jobs.value = response.data.map(job => ({
      id: job._id,
      title: job.JobTitle,
      description: job.JobDescription,
      company: job.CompanyName,
      tags: job.JobTags,
      postedDate: (job.createdAt || "Not provided").split('T')[0] || "Not provided"  // fallback if no date
    }));

  } catch (err) {
    error.value = "Failed to load job listings. Please try again.";
    console.error(err);
  } finally {
    isLoading.value = false;
  }
};


const deleteJob = async (jobId) => {
  // Confirmation dialog for the user
  if (!confirm("Are you sure you want to delete this job listing?")) {
    return;
  }

  try {
    // Send jobId in the POST body
    await apiClient.post(`/company/delete_job`, { jobId });

    // Remove the job from the local list
    jobs.value = jobs.value.filter(job => job._id !== jobId);

    alert("Job listing deleted successfully!");
    window.location.reload();

  } catch (error) {
    console.error("Error deleting job:", error);
    alert("Failed to delete job. Please try again.");
  }
};


onMounted(fetchJobs);
</script>

<template>
  <div class="p-8 text-white min-h-screen">
    <h1 class="text-4xl font-extrabold text-center mb-8">
      <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">
        Your Job Listings
      </span>
    </h1>

    <div v-if="isLoading" class="text-center text-gray-400">
      <p>Loading job listings...</p>
    </div>

    <div v-else-if="error" class="text-center text-red-500">
      <p>{{ error }}</p>
    </div>

    <div v-else-if="jobs.length === 0" class="text-center bg-gray-800 p-12 rounded-2xl">
      <p class="text-2xl text-gray-300">You haven't posted any jobs yet.</p>
      <p class="mt-4 text-gray-400">Use the "Post a New Job" page to get started!</p>
    </div>

    <div v-else class="space-y-6">
      <div 
        v-for="job in jobs" 
        :key="job.id" 
        class="bg-gray-800 p-6 rounded-2xl shadow-lg transition-transform transform hover:scale-[1.01] animate-fade-in-up"
      >
        <div class="flex justify-between items-start mb-2">
          <div>
            <h2 class="text-2xl font-bold">{{ job.title }}</h2>
            <span class="text-sm text-gray-400">Posted: {{ job.postedDate }}</span>
          </div>
          <button @click="deleteJob(job.id)" class="text-red-400 hover:text-red-500 transition-colors">
            <TrashIcon class="h-6 w-6" />
          </button>
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
