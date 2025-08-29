<template>
  <div class="p-8">
    <h1 class="text-3xl font-semibold text-white mb-6">Company Verification</h1>
    <p class="text-gray-400 mb-8">Please upload a document to verify your company's information. This document will be reviewed by an administrator.</p>

    <div class="bg-[#101010] p-6 rounded-lg shadow-lg">
      <div class="mb-4">
        <label for="document" class="block text-gray-300 font-medium mb-2">Select a Document</label>
        <div class="relative border-2 border-dashed border-gray-600 rounded-lg p-6 text-center hover:border-gray-500 transition duration-300 ease-in-out cursor-pointer">
          <input 
            type="file" 
            id="document" 
            class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" 
            @change="handleFileChange" 
            accept=".pdf,.doc,.docx"
          >
          <div v-if="fileName" class="text-white text-center">
            <p class="font-bold">{{ fileName }}</p>
            <p class="text-sm text-gray-400">Ready to upload</p>
          </div>
          <div v-else class="text-gray-400">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
            </svg>
            <p class="mt-2 text-sm">Drag and drop a file, or click to browse</p>
            <p class="text-xs mt-1 text-gray-500">PDF, DOC, DOCX files up to 10MB</p>
          </div>
        </div>
      </div>
      
      <div class="mt-6 flex justify-end">
        <button
          @click="uploadDocument"
          :disabled="!selectedFile"
          :class="{'opacity-50 cursor-not-allowed': !selectedFile}"
          class="bg-green-500 text-white font-bold py-2 px-6 rounded-full transition duration-300 ease-in-out hover:bg-green-600"
        >
          Upload Document
        </button>
      </div>
    </div>
    
    <div v-if="message" class="mt-4 p-4 rounded-md text-sm" :class="messageClass">
      {{ message }}
    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue';
import apiClient from '../utils/axios'; // ✅ axios wrapper

const selectedFile = ref(null);
const fileName = ref('');
const message = ref('');
const messageClass = ref('');

const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    if (file.size > 10485760) { // 10MB
      selectedFile.value = null;
      fileName.value = '';
      message.value = 'File is too large. Max size is 10MB.';
      messageClass.value = 'bg-red-500 text-white';
    } else {
      selectedFile.value = file;
      fileName.value = file.name;
      message.value = '';
    }
  } else {
    selectedFile.value = null;
    fileName.value = '';
  }
};

const uploadDocument = async () => {
  if (!selectedFile.value) {
    message.value = 'Please select a file to upload.';
    messageClass.value = 'bg-red-500 text-white';
    return;
  }

  message.value = 'Uploading document...';
  messageClass.value = 'bg-yellow-500 text-white';

  try {
    const response = await apiClient.post('/company/upload_request', selectedFile.value,
      {}
    );

    message.value = 'Document uploaded successfully! Pending verification.';
    messageClass.value = 'bg-green-500 text-white';
    selectedFile.value = null;
    fileName.value = '';
  } catch (err) {
    message.value = `Upload failed: ${err.response?.data || err.message}`;
    messageClass.value = 'bg-red-500 text-white';
  }
};
</script>


<style scoped>
/* No specific custom styles needed for this component, Tailwind handles it */
</style>
