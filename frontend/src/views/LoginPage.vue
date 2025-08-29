<script setup>
import { ref } from 'vue';
import apiClient from '../utils/axios';
import { useRouter } from 'vue-router';
import { jwtDecode } from 'jwt-decode'

// Reactive variables to store email and password
const email = ref('');
const password = ref('');
const errorMessage = ref(''); // To display any login errors
const isLoading = ref(false);
const router = useRouter(); // Initialize router if you're using it

const handleLogin = async () => {
    errorMessage.value = ''; // Clear previous errors

    try {
        const response = await apiClient.post('/login', {
            email: email.value,
            password: password.value,
        });

        const { token } = response.data;

        // Store the JWT token
        localStorage.setItem('jwt_token', token);

        // Decode the JWT to find the user's role
        const decodedToken = jwtDecode(token);
        const userRole = decodedToken.role; // Assuming the role is stored in the JWT payload

        // Redirect based on the user's role
        if (userRole === 'user') {
            router.push('/home');
        } else if (userRole === 'admin') {
            router.push('/admin-dashboard');
        } else if (userRole === 'company') {
            router.push('/company-home');
        } else {
            // Handle unknown roles or provide a default redirect
            router.push('/home');
        }

        console.log('Login successful!', { token });

    } catch (error) {
        console.error('Login failed:', error);
        if (error.response) {
            // The request was made and the server responded with a status code
            // that falls out of the range of 2xx
            if (error.response.status === 401 || error.response.status === 400) {
                // Handle specific authentication errors
                errorMessage.value = 'Invalid email or password. Please try again.';
            } else if (error.response.data && error.response.data) {
                // Fallback to a message provided by the API
                errorMessage.value = error.response.data;
            } else {
                errorMessage.value = 'An error occurred during login. Please try again.';
            }
        } else if (error.request) {
            // The request was made but no response was received
            errorMessage.value = 'No response from server. Please check your network connection.';
        } else {
            // Something happened in setting up the request that triggered an Error
            errorMessage.value = 'An unexpected error occurred. Please try again.';
        }
    } finally {
        isLoading.value = false;
    }
};
</script>

<template>
    <div class="flex items-center justify-center min-h-screen bg-black p-4">
        <div class="w-full max-w-md bg-[#181818] rounded-lg shadow-lg p-8">
            <h2 class="text-white text-3xl font-bold text-center mb-6">Log In</h2>

            <form @submit.prevent="handleLogin">
                <div class="mb-4">
                    <label for="email" class="block text-gray-300 text-sm font-semibold mb-2">Email</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="your@example.com"
                        class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E] placeholder-gray-400"
                        v-model="email" required
                    />
                </div>

                <div class="mb-6">
                    <label for="password" class="block text-gray-300 text-sm font-semibold mb-2">Password</label>
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="********"
                        class="shadow-sm appearance-none border border-[#535353] rounded w-full py-3 px-4 text-white leading-tight focus:outline-none focus:ring-1 focus:ring-[#2EA0C2] bg-[#3E3E3E] placeholder-gray-400"
                        v-model="password" required
                    />
                </div>

                <p v-if="errorMessage" class="text-red-500 text-sm text-center mb-4">{{ errorMessage }}</p>

                <div class="flex items-center justify-between mb-6">
                    <label class="flex items-center text-gray-300 text-sm">
                        <input type="checkbox" class="form-checkbox h-4 w-4 text-[#2EA0C2] transition duration-150 ease-in-out bg-[#3E3E3E] border-[#535353] rounded focus:ring-[#2EA0C2]" />
                        <span class="ml-2">Remember me</span>
                    </label>
                </div>

                <div class="flex items-center justify-center">
                    <button
                        type="submit"
                        class="bg-[#2EA0C2] hover:bg-[#244284] text-white font-bold py-3 px-6 rounded-full focus:outline-none focus:shadow-outline w-full transition duration-200 ease-in-out"
                    >
                        Login
                    </button>
                </div>
            </form>

            <p class="text-center text-gray-400 text-sm mt-8">
                Don't have an account?
                <a href="/register" class="font-bold text-[#2EA0C2] hover:text-[#244284]">Sign Up</a>
            </p>
        </div>
    </div>
</template>