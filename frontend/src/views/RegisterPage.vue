<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import apiClient from "../utils/axios"; // adjust path if needed

const router = useRouter();

// Form fields
const user_name = ref("");
const email = ref("");
const password = ref("");
const role = ref("user");
const errorMessage = ref("");
const successMessage = ref("");

// Computed properties to dynamically change the label and placeholder
const userNameLabel = computed(() => {
    return role.value === "company" ? "Name of the company/organization" : "User Name";
});

const userNamePlaceholder = computed(() => {
    return role.value === "company" ? "Enter company or organization name" : "Enter username";
});

const register = async () => {
    errorMessage.value = "";
    successMessage.value = "";

    try {
        const response = await apiClient.post("/register", {
            user_name: user_name.value,
            email: email.value,
            password: password.value,
            role: role.value,
        });

        successMessage.value = "Registration successful! Redirecting to login...";
        console.log("Registration success:", response.data);

        // Redirect after short delay
        setTimeout(() => {
            router.push({ name: "login" });
        }, 1500);
    } catch (error) {
        console.error("Registration failed:", error);
        errorMessage.value =
            error.response?.data?.message ||
            error.response?.data?.body ||
            "Registration failed. Please try again.";
    }
};
</script>

<template>
    <div class="flex items-center justify-center min-h-screen bg-black p-4">
        <div class="w-full max-w-md bg-[#181818] rounded-lg shadow-lg p-8">
            <h1 class="text-white text-3xl font-bold text-center mb-6">Register</h1>

            <form @submit.prevent="register">

                <div class="mb-4">
                    <label class="block text-gray-300 text-sm font-semibold mb-2">Register as a</label>
                    <select
                        v-model="role"
                        class="w-full px-4 py-3 rounded bg-[#3E3E3E] text-white"
                    >
                        <option value="user">User</option>
                        <option value="company">Company</option>
                    </select>
                </div>


                <div class="mb-4">
                    <label class="block text-gray-300 text-sm font-semibold mb-2" v-text="userNameLabel"></label>
                    <input
                        v-model="user_name"
                        required
                        type="text"
                        :placeholder="userNamePlaceholder"
                        class="w-full px-4 py-3 rounded bg-[#3E3E3E] text-white"
                    />
                </div>

                <div class="mb-4">
                    <label class="block text-gray-300 text-sm font-semibold mb-2">Email</label>
                    <input
                        v-model="email"
                        required
                        type="email"
                        placeholder="your@example.com"
                        class="w-full px-4 py-3 rounded bg-[#3E3E3E] text-white"
                    />
                </div>

                <div class="mb-4">
                    <label class="block text-gray-300 text-sm font-semibold mb-2">Password</label>
                    <input
                        v-model="password"
                        required
                        type="password"
                        placeholder="********"
                        class="w-full px-4 py-3 rounded bg-[#3E3E3E] text-white"
                    />
                </div>

                <p v-if="errorMessage" class="text-red-500 text-sm text-center mb-4">
                    {{ errorMessage }}
                </p>
                <p v-if="successMessage" class="text-green-500 text-sm text-center mb-4">
                    {{ successMessage }}
                </p>

                <button
                    type="submit"
                    class="bg-[#2EA0C2] hover:bg-[#244284] text-white w-full py-3 rounded-full"
                >
                    Register
                </button>
            </form>

            <p class="text-center text-gray-400 text-sm mt-6">
                Already have an account?
                <router-link to="/login" class="text-[#2EA0C2] font-bold">Sign In</router-link>
            </p>
        </div>
    </div>
</template>