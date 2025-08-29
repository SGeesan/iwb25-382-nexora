<template>
  <div class="p-8">
    <h1 class="text-3xl font-semibold text-white mb-6">Admin Dashboard</h1>
    <p class="text-gray-400 mb-8">Review and manage company verification requests.</p>

    <div v-if="requests.length === 0" class="bg-[#101010] p-6 rounded-lg text-center text-gray-500">
      <p class="text-lg">No pending verification requests at this time.</p>
    </div>

    <div v-else class="bg-[#101010] p-6 rounded-lg shadow-lg overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-700">
        <thead class="bg-[#1a1a1a]">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Company Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Submission Date</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
          <tr v-for="request in requests" :key="request.id" class="transition-all duration-300 hover:bg-[#282828]">
            <td class="px-6 py-4 whitespace-nowrap text-white">{{ request.companyName }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-gray-400">{{ request.submissionDate }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-gray-400">
              <span 
                :class="{
                  'bg-yellow-500': request.status === 'Pending',
                  'bg-green-500': request.status === 'Verified',
                  'bg-red-500': request.status === 'Rejected'
                }"
                class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full text-white"
              >
                {{ request.status }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <div class="flex space-x-2">
                <button
                  @click="approveRequest(request.id)"
                  :disabled="request.status !== 'Pending'"
                  :class="{'opacity-50 cursor-not-allowed': request.status !== 'Pending'}"
                  class="text-green-400 hover:text-green-500 transition-colors duration-200"
                >
                  Approve
                </button>
                <button
                  @click="rejectRequest(request.id)"
                  :disabled="request.status !== 'Pending'"
                  :class="{'opacity-50 cursor-not-allowed': request.status !== 'Pending'}"
                  class="text-red-400 hover:text-red-500 transition-colors duration-200"
                >
                  Reject
                </button>
                <a :href="request.documentUrl" target="_blank" class="text-blue-400 hover:text-blue-500 transition-colors duration-200">
                  View Document
                </a>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const requests = ref([]);

// This function simulates fetching requests from a database.
// In a real application, you would make an API call here.
const fetchRequests = () => {
  // Mock data for demonstration purposes
  const mockRequests = [
    { id: 1, companyName: 'Innovate Solutions Inc.', submissionDate: '2025-08-25', status: 'Pending', documentUrl: 'https://placehold.co/600x400/000000/FFFFFF?text=Document' },
    { id: 2, companyName: 'Global Tech Corp', submissionDate: '2025-08-24', status: 'Pending', documentUrl: 'https://placehold.co/600x400/000000/FFFFFF?text=Document' },
    { id: 3, companyName: 'Creative Ventures LLC', submissionDate: '2025-08-22', status: 'Verified', documentUrl: 'https://placehold.co/600x400/000000/FFFFFF?text=Document' },
    { id: 4, companyName: 'Blue Sky Innovations', submissionDate: '2025-08-20', status: 'Rejected', documentUrl: 'https://placehold.co/600x400/000000/FFFFFF?text=Document' },
  ];
  requests.value = mockRequests;
};

const approveRequest = (id) => {
  const request = requests.value.find(req => req.id === id);
  if (request) {
    request.status = 'Verified';
    console.log(`Request ${id} has been approved.`);
    // Here you would make an API call to update the status on the server.
  }
};

const rejectRequest = (id) => {
  const request = requests.value.find(req => req.id === id);
  if (request) {
    request.status = 'Rejected';
    console.log(`Request ${id} has been rejected.`);
    // Here you would make an API call to update the status on the server.
  }
};

onMounted(() => {
  fetchRequests();
});
</script>

<style scoped>
/* Tailwind CSS handles all styling */
</style>
