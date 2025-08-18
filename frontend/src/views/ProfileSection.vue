<script setup>
import { ref, onMounted } from "vue";
import { jwtDecode } from "jwt-decode";
import { useRouter } from "vue-router"; // Import useRouter
import apiClient from "../utils/axios";
import ArrowLeft from 'vue-material-design-icons/ArrowLeft.vue'; // Import the back arrow icon

const user = ref({ username: "", email: "", role: "" });
const currentPassword = ref("");
const newPassword = ref("");
const confirmPassword = ref("");
const isLoading = ref(false);
const message = ref(null);
const error = ref(null);

const router = useRouter(); // Initialize the router

onMounted(() => {
  const token = localStorage.getItem("jwt_token");
  if (token) {
    try {
      const decoded = jwtDecode(token);
      user.value.username = decoded.user_name || "";
      user.value.email = decoded.email || "";
      user.value.role = decoded.role || "";
    } catch (e) {
      console.error("Invalid token", e);
    }
  }
});

const changePassword = async () => {
  if (newPassword.value !== confirmPassword.value) {
    error.value = "New passwords do not match.";
    return;
  }
  isLoading.value = true;
  message.value = null;
  error.value = null;

  try {
    await apiClient.post("/user/change_password", {
      currentPassword: currentPassword.value,
      newPassword: newPassword.value,
    });
    message.value = "Password changed successfully!";
    currentPassword.value = "";
    newPassword.value = "";
    confirmPassword.value = "";
  } catch (err) {
    error.value = "Failed to change password. Please check your current password.";
    console.error(err);
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <div class="p-8 text-white">
    <!-- Back Button -->
    <div class="absolute top-0 left-0 p-8">
        <button @click="router.back()" class="flex items-center text-gray-400 hover:text-white transition-colors duration-200">
            <ArrowLeft :size="24" class="mr-1" />
            <span class="font-semibold">Back</span>
        </button>
    </div>
    
    <div class="text-center mb-12">
      <h1 class="text-5xl font-extrabold animate-fade-in-up">
        <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">
          Your Profile
        </span>
      </h1>
      <p class="text-gray-400 mt-2 animate-fade-in-up delay-200">Manage your account details and security.</p>
    </div>

    <!-- Profile Info -->
    <div class="max-w-3xl mx-auto bg-gray-800 p-8 rounded-2xl shadow-lg animate-fade-in-up delay-400">
      <h2 class="text-2xl font-bold mb-6 text-blue-400">Account Information</h2>
      <div class="space-y-4 text-gray-300">
        <p><span class="font-semibold text-white">Username:</span> {{ user.username }}</p>
        <p><span class="font-semibold text-white">Email:</span> {{ user.email }}</p>
        <p><span class="font-semibold text-white">Role:</span> {{ user.role }}</p>
      </div>
    </div>

    <!-- Change Password -->
    <div class="max-w-3xl mx-auto mt-10 bg-gray-800 p-8 rounded-2xl shadow-lg animate-fade-in-up delay-600">
      <h2 class="text-2xl font-bold mb-6 text-blue-400">Change Password</h2>
      <form @submit.prevent="changePassword" class="space-y-4">
        <div>
          <label class="block text-gray-300 mb-1">Current Password</label>
          <input v-model="currentPassword" type="password"
            class="w-full px-4 py-2 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label class="block text-gray-300 mb-1">New Password</label>
          <input v-model="newPassword" type="password"
            class="w-full px-4 py-2 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <div>
          <label class="block text-gray-300 mb-1">Confirm New Password</label>
          <input v-model="confirmPassword" type="password"
            class="w-full px-4 py-2 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>

        <button type="submit" :disabled="isLoading"
          class="w-full py-3 rounded-full font-bold bg-blue-600 hover:bg-blue-700 transition transform hover:scale-105 shadow-lg">
          {{ isLoading ? "Changing..." : "Change Password" }}
        </button>
      </form>

      <!-- Messages -->
      <p v-if="message" class="mt-4 text-green-400 text-center">{{ message }}</p>
      <p v-if="error" class="mt-4 text-red-400 text-center">{{ error }}</p>
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
.delay-200 { animation-delay: 0.2s; }
.delay-400 { animation-delay: 0.4s; }
.delay-600 { animation-delay: 0.6s; }
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}
</style>
