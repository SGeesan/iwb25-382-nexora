<script setup>
import { ref, onMounted } from "vue";
import axios from "axios";
import apiClient from "../utils/axios";

const cvData = ref(null);
const isLoading = ref(true);
const error = ref(null);
const newCVFile = ref(null);

const fetchCurrentCV = async () => {
  isLoading.value = true;
  error.value = null;
  try {
    // Step 1: Get CV info
    const infoResponse = await apiClient.get('/user/get_cv_info', {
      headers: {
        Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
      },
    });

    const { images, uuid } = infoResponse.data;

    // Step 2: Fetch each CV page as blob
    const fetchedImages = await Promise.all(
      images.map(async (imgPath) => {
        // Extract page number
        const pageNum = imgPath.split('/').pop();
        const pathParam = encodeURIComponent(`${uuid}/${pageNum}`);

        const imageResponse = await apiClient.get(`/user/get_cv_image?path=/image/${pathParam}`, {
          responseType: 'arraybuffer',
          headers: {
            Authorization: `Bearer ${localStorage.getItem('jwt_token')}`
          }
        });

        const blob = new Blob([imageResponse.data], { type: imageResponse.headers['content-type'] });
        return URL.createObjectURL(blob);
      })
    );

    cvData.value = {
      page_count: infoResponse.data.page_count,
      uuid,
      images: fetchedImages
    };

  } catch (err) {
    if (err.response && err.response.status === 404) {
      cvData.value = null;
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

  try {
    await apiClient.post('/user/upload_cv', newCVFile.value, {
      headers: {
        'Content-Type': newCVFile.value.type, // e.g., application/pdf or image/png
      },
    });

    // On successful upload, re-fetch the CV to display it
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
      <p class="animate-pulse">Loading...</p>
    </div>

    <div v-else-if="error" class="text-red-500 text-center">
      <p>{{ error }}</p>
    </div>

    <div v-else class="cv-content-fade-in">
      <!-- CV images -->
      <div v-if="cvData && cvData.images.length">
        <h2 class="text-xl text-white mb-4">Current CV:</h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          <div v-for="(img, index) in cvData.images" :key="index" class="cv-image-container">
            <img
              :src="img"
              :alt="`CV Page ${index + 1}`"
              class="cv-image"
            />
            <p class="text-gray-300 text-center mt-2 text-sm">Page {{ index + 1 }}</p>
          </div>
        </div>
        <p class="mt-4 text-gray-400">Want to update it? Upload a new one below.</p>
      </div>

      <!-- No CV uploaded -->
      <div v-else class="text-center bg-gray-800 p-12 rounded-xl">
        <p class="text-2xl font-semibold text-gray-300">You haven't uploaded a CV yet.</p>
        <label for="file-upload" class="inline-block mt-8 px-8 py-4 bg-blue-600 text-white font-bold rounded-full shadow-lg hover:bg-blue-700 cursor-pointer transition duration-300 transform hover:scale-105">
          Upload Your First CV
        </label>
        <input id="file-upload" type="file" @change="handleFileUpload" class="hidden" accept="image/*,application/pdf">
      </div>

      <!-- Upload new CV -->
      <div v-if="cvData" class="mt-8 text-center">
        <label for="file-upload-update" class="inline-block px-8 py-4 bg-blue-600 text-white font-bold rounded-full shadow-lg hover:bg-blue-700 cursor-pointer transition duration-300 transform hover:scale-105">
          Upload a New CV
        </label>
        <input id="file-upload-update" type="file" @change="handleFileUpload" class="hidden" accept="image/*,application/pdf">
      </div>
    </div>
  </div>
</template>

<style scoped>
.cv-image-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.cv-image {
  width: 100%;
  max-width: 200px; /* smaller thumbnails */
  height: auto;
  border: 2px solid #4b5563; /* gray-700 border */
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.cv-image:hover {
  transform: scale(1.05);
  box-shadow: 0 8px 16px rgba(0,0,0,0.5);
}
</style>