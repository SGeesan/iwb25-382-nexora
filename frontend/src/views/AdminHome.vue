<template>
  <div class="p-8 bg-[#101010] min-h-screen">
    <h1 class="text-3xl font-semibold text-white mb-6">Admin Dashboard</h1>
    <p class="text-gray-400 mb-8">Review and manage company verification requests.</p>

    <div v-if="requests.length === 0" class="bg-[#1a1a1a] p-6 rounded-lg text-center text-gray-500">
      <p class="text-lg">No pending verification requests at this time.</p>
    </div>

    <div v-else class="bg-[#1a1a1a] p-6 rounded-lg shadow-lg overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-700">
        <thead class="bg-[#282828]">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Company Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Submission Date</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
          <tr v-for="request in requests" :key="request.id" class="transition-all duration-300 hover:bg-[#333333]">
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
                <button @click="showDocumentViewer(request.documentPages, request.companyName)" class="text-blue-400 hover:text-blue-500 transition-colors duration-200">
                  View Document
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <div v-if="isViewerOpen" class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50">
      <div class="bg-[#1a1a1a] p-6 rounded-lg w-11/12 md:w-3/4 lg:w-1/2 max-h-[90vh] overflow-y-auto relative">
        <button @click="closeViewer" class="absolute top-4 right-4 text-gray-400 hover:text-gray-200">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <h2 class="text-2xl text-white font-bold mb-4">{{ companyName.toUpperCase() }}</h2>
        
        <div v-if="selectedPages.length > 1" class="flex justify-center items-center mb-4 text-white">
          <button @click="prevPage" :disabled="currentPageIndex === 0" class="p-2 disabled:opacity-50">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
          </button>
          <span class="mx-4">Page {{ currentPageIndex + 1 }} of {{ selectedPages.length }}</span>
          <button @click="nextPage" :disabled="currentPageIndex === selectedPages.length - 1" class="p-2 disabled:opacity-50">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </button>
        </div>

        <div class="flex justify-center">
          <img 
            v-if="selectedPages.length > 0"
            :src="selectedPages[currentPageIndex]" 
            :alt="'Document Page ' + (currentPageIndex + 1)" 
            class="w-full h-auto rounded-lg shadow-lg max-w-full"
          >
          <p v-else class="text-gray-400">No document pages found.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import apiClient from '../utils/axios';

const requests = ref([]);
const isViewerOpen = ref(false);
const selectedPages = ref([]);
const currentPageIndex = ref(0);
const companyName = ref('');

// ✅ Fetch requests
const fetchRequests = async () => {
  try {
    const { data } = await apiClient.get('/admin/get_all_company_requests');

    requests.value = data.map(item => ({
      id: item._id,
      companyName: item.company_name,
      submissionDate: new Date(item.createdAt).toLocaleDateString(),
      status: item.status.charAt(0).toUpperCase() + item.status.slice(1), // normalize
      documentPages: item.file_uuid ? [`/uploads/${item.file_uuid}.png`] : []
    }));
  } catch (error) {
    console.error("Error fetching company requests:", error);
  }
};

// ✅ Unified update function
const updateRequestStatus = async (id, newStatus) => {
  try {
    await apiClient.put(`/admin/update_company_request_status/${id}`, {
      new_status: newStatus.toLowerCase()  // backend expects lowercase
    });

    const request = requests.value.find(req => req.id === id);
    if (request) {
      request.status = newStatus;
    }
  } catch (error) {
    console.error(`Error updating request ${id} to ${newStatus}:`, error);
  }
};

// ✅ Simple wrappers
const approveRequest = (id) => updateRequestStatus(id, 'Approved');
const rejectRequest = (id) => updateRequestStatus(id, 'Rejected');

const showDocumentViewer = async (fileUuid, company) => {
  selectedPages.value = [];
  currentPageIndex.value = 0;
  companyName.value = company;

  try {
    // Step 1: Get document info
    const { data } = await apiClient.get(`/admin/get_company_request_doc/${companyName.value}`);
    const { uuid, page_count, images } = data; // images is optional if you want paths

    // Step 2: Fetch each page as a blob concurrently
    const fetchedImages = await Promise.all(
      images.map(async (imgPath) => {
        // Extract page number
        const pageNum = imgPath.split('/').pop();
        const pathParam = encodeURIComponent(`${uuid}/${pageNum}`);

        const imageResponse = await apiClient.get(`/admin/get_cr_image?path=/image/${pathParam}`, {
          responseType: 'arraybuffer',
          headers: {
            Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
          }
        });

        const blob = new Blob([imageResponse.data], { type: imageResponse.headers['content-type'] });
        return URL.createObjectURL(blob);
      })
    );

    selectedPages.value = fetchedImages;
    isViewerOpen.value = true;

  } catch (err) {
    console.error("Error fetching document pages", err);
    alert("Failed to load document pages.");
  }
};

const closeViewer = () => {
  isViewerOpen.value = false;
  selectedPages.value = [];
  currentPageIndex.value = 0;
  companyName.value = '';
};

const prevPage = () => {
  if (currentPageIndex.value > 0) currentPageIndex.value--;
};

const nextPage = () => {
  if (currentPageIndex.value < selectedPages.value.length - 1) currentPageIndex.value++;
};

onMounted(() => {
  fetchRequests();
});
</script>



<style scoped>
/* Tailwind CSS handles all styling */
</style>