<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios'; // Assuming you have axios installed and configured

const cvData = ref(null);
const isLoading = ref(true);
const error = ref(null);
const newCVFile = ref(null);

const fetchCurrentCV = async () => {
  isLoading.value = true;
  error.value = null;
  try {
    const response = await axios.get('/api/user/cv', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
      },
      responseType: 'arraybuffer' // Handle the response as binary data (e.g., image)
    });

    // Create a Blob from the response data and a URL to display the image
    const blob = new Blob([response.data], { type: response.headers['content-type'] });
    const imageUrl = URL.createObjectURL(blob);
    cvData.value = { url: imageUrl };
  } catch (err) {
    if (err.response && err.response.status === 404) {
      cvData.value = null; // No CV found
    } else {
      error.value = 'Failed to fetch CV. Please try again.';
      console.error(err);
    }
  } finally {
    isLoading.value = false;
  }
};

const handleFileUpload = (event) => {
  const file = event.target.files[0];
  if (file) {
    newCVFile.value = file;
    uploadNewCV(); // Automatically upload after selection
  }
};

const uploadNewCV = async () => {
  if (!newCVFile.value) {
    error.value = 'Please select a file to upload.';
    return;
  }

  isLoading.value = true;
  error.value = null;
  const formData = new FormData();
  formData.append('cv', newCVFile.value);

  try {
    await axios.post('/api/user/cv/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
        Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
      }
    });
    // On successful upload, re-fetch the new CV to display it
    newCVFile.value = null;
    await fetchCurrentCV();
    alert('CV uploaded successfully!');
  } catch (err) {
    error.value = 'Failed to upload CV. Please ensure it is a valid file.';
    console.error(err);
  } finally {
    isLoading.value = false;
  }
};

// Fetch data on initial component load
onMounted(fetchCurrentCV);
</script>

<template>
  <div class="p-8">
    <h1 class="text-3xl font-bold text-white mb-6">Your CV</h1>

    <div v-if="isLoading" class="text-white text-center">
      <p>Loading...</p>
    </div>

    <div v-else-if="error" class="text-red-500 text-center">
      <p>{{ error }}</p>
    </div>

    <div v-else>
      <div v-if="cvData">
        <h2 class="text-xl text-white mb-4">Current CV:</h2>
        <img :src="cvData.url" alt="Current CV" class="max-w-full h-auto border-4 border-gray-700 rounded-lg shadow-lg">
        <p class="mt-4 text-gray-400">Want to update it? Upload a new one below.</p>
      </div>

      <div v-else class="text-center bg-gray-800 p-12 rounded-xl">
        <p class="text-2xl font-semibold text-gray-300">You haven't uploaded a CV yet.</p>
        <label for="file-upload" class="
          inline-block mt-8 px-8 py-4
          bg-green-600 text-white font-bold
          rounded-full shadow-lg
          hover:bg-green-700 cursor-pointer
          transition duration-300 transform hover:scale-105
        ">
          Upload Your First CV
        </label>
        <input id="file-upload" type="file" @change="handleFileUpload" class="hidden" accept="image/*,application/pdf">
      </div>

      <div v-if="cvData" class="mt-8 text-center">
        <label for="file-upload-update" class="
          inline-block px-8 py-4
          bg-blue-600 text-white font-bold
          rounded-full shadow-lg
          hover:bg-blue-700 cursor-pointer
          transition duration-300 transform hover:scale-105
        ">
          Upload a New CV
        </label>
        <input id="file-upload-update" type="file" @change="handleFileUpload" class="hidden" accept="image/*,application/pdf">
      </div>
    </div>
  </div>
</template>