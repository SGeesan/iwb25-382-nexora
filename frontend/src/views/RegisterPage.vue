<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
// Import your API client - adjust the import path as needed
// import apiClient from '@/api/client'

const router = useRouter()

// Reactive variables
const user_name = ref('')
const email = ref('')
const password = ref('')
const role = ref('user')
const errorMessage = ref('')

const register = async () => {
  errorMessage.value = ''; // Clear previous errors

  try {
      // Uncomment and adjust this when you have apiClient set up
      const response = await apiClient.post('/register', {
          email: email.value,
          password: password.value,
          user_name: user_name.value,
          role: role.value,
      });


      // Redirect to home page after successful registration
      router.push('/');

      // For now, just log the data (remove this when API is connected)
      console.log('Registration data:', {
          user_name: user_name.value,
          email: email.value,
          password: password.value,
          role: role.value,
      });

  } catch (error) {
      console.error('Registration failed:', error);
      if (error.response && error.response.data && error.response.data.message) {
          errorMessage.value = error.response.data.message;
      } else {
          errorMessage.value = 'An unexpected error occurred. Please try again.';
      }
  }
};
</script>

<template>
    <div class="flex items-center justify-center min-h-screen bg-black p-4">
      <div class="w-full max-w-md bg-[#181818] rounded-lg shadow-lg p-8">
        <h1 class="text-white text-3xl font-bold text-center mb-6">Register</h1>
        
        <form @submit.prevent="register">
          <div class="mb-4">
            <label for="user_name" class="block text-gray-300 text-sm font-semibold mb-2">User Name</label>
            <input 
              type="text" 
              id="user_name"
              v-model="user_name" 
              placeholder="Enter your username"
              class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E] placeholder-gray-400"
              required 
            />
          </div>
          
          <div class="mb-4">
            <label for="email" class="block text-gray-300 text-sm font-semibold mb-2">Email</label>
            <input 
              type="email" 
              id="email"
              v-model="email" 
              placeholder="your@example.com"
              class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E] placeholder-gray-400"
              required 
            />
          </div>
          
          <div class="mb-4">
            <label for="password" class="block text-gray-300 text-sm font-semibold mb-2">Password</label>
            <input 
              type="password" 
              id="password"
              v-model="password" 
              placeholder="********"
              class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E] placeholder-gray-400"
              required 
            />
          </div>
          
          <div class="mb-4">
            <label for="role" class="block text-gray-300 text-sm font-semibold mb-2">Role</label>
            <select 
              id="role"
              v-model="role"
              class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E]"
            >
              <option value="user" class="bg-[#3E3E3E] text-white">User</option>
              <option value="company" class="bg-[#3E3E3E] text-white">Company</option>
            </select>
          </div>

          <p v-if="errorMessage" class="text-red-500 text-sm text-center mb-4">{{ errorMessage }}</p>
          
          <div class="flex items-center justify-center">
            <button 
              type="submit"
              class="bg-[#2EA0C2] hover:bg-[#244284] text-white font-bold py-3 px-6 rounded-full focus:outline-none focus:shadow-outline w-full transition duration-200 ease-in-out"
            >
              Register
            </button>
          </div>
        </form>
        
        <p class="text-center text-gray-400 text-sm mt-8">
          Already have an account?
          <a href="/" class="font-bold text-[#2EA0C2] hover:text-[#244284]">Sign In</a>
        </p>
      </div>
    </div>
</template>