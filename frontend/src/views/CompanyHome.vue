<script setup>
import { ref, onMounted } from 'vue';
import { TrashIcon } from '@heroicons/vue/24/outline';

const jobs = ref([]);
const isLoading = ref(true);
const error = ref(null);

// Placeholder data for demonstration
const mockJobs = [
  {
    id: 1,
    title: "Senior Full Stack Developer",
    description: "Looking for a skilled developer to join our team...",
    tags: ["JavaScript", "React", "Node.js", "MongoDB", "AWS"],
    postedDate: "2024-07-25"
  },
  {
    id: 2,
    title: "UI/UX Designer",
    description: "We need a creative designer to work on our new platform...",
    tags: ["Figma", "UI/UX", "Tailwind CSS"],
    postedDate: "2024-07-24"
  },
  {
    id: 3,
    title: "DevOps Engineer",
    description: "An experienced DevOps professional to manage our infrastructure...",
    tags: ["Go", "Kubernetes", "Docker", "CI/CD"],
    postedDate: "2024-07-23"
  }
];

// Function to fetch the company's job listings from a backend
const fetchJobs = async () => {
  isLoading.value = true;
  error.value = null;

  try {
    // In a real application, you would make an API call here
    // Example: const response = await apiClient.get('/company/jobs');
    // jobs.value = response.data;
    
    // Using mock data for now
    jobs.value = mockJobs;
  } catch (err) {
    error.value = "Failed to load job listings. Please try again.";
    console.error(err);
  } finally {
    isLoading.value = false;
  }
};

const deleteJob = (jobId) => {
  // Confirmation dialog for the user
  if (confirm("Are you sure you want to delete this job listing?")) {
    // In a real application, you would make an API call here to delete the job
    // Example: await apiClient.delete(`/company/jobs/${jobId}`);
    
    // For this mock data, we'll just filter the job out
    jobs.value = jobs.value.filter(job => job.id !== jobId);
    alert("Job listing deleted successfully!");
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
