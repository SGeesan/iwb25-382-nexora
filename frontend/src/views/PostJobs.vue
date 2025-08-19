<script setup>
import { ref, computed } from "vue";
import { XMarkIcon } from '@heroicons/vue/24/outline'; // Importing an icon for removing tags

const jobTitle = ref("");
const jobDescription = ref("");
const selectedTags = ref([]);
const searchTerm = ref("");
const showTagsDropdown = ref(false);

// A predefined list of available tags for demonstration
const availableTags = ref([
  "JavaScript",
  "React",
  "Node.js",
  "Vue.js",
  "Python",
  "Go",
  "AWS",
  "Docker",
  "Kubernetes",
  "TypeScript",
  "Tailwind CSS",
  "PostgreSQL",
  "MongoDB",
  "GraphQL",
  "Rest API",
  "CI/CD",
  "Figma",
  "UI/UX",
  "Svelte",
  "Angular",
  "Ruby on Rails",
]);

// Computed property to filter the available tags based on the search term
const filteredTags = computed(() => {
  if (!searchTerm.value) {
    return availableTags.value.filter(tag => !selectedTags.value.includes(tag));
  }
  const lowerCaseSearch = searchTerm.value.toLowerCase();
  return availableTags.value
    .filter(tag => tag.toLowerCase().includes(lowerCaseSearch))
    .filter(tag => !selectedTags.value.includes(tag));
});

// Function to add a selected tag to the list
const addTag = (tag) => {
  if (!selectedTags.value.includes(tag)) {
    selectedTags.value.push(tag);
    searchTerm.value = ""; // Clear the search input
    showTagsDropdown.value = false;
  }
};

// Function to remove a tag from the selected list
const removeTag = (tagToRemove) => {
  selectedTags.value = selectedTags.value.filter(tag => tag !== tagToRemove);
};

// Function to handle form submission
const handleSubmit = () => {
  const formData = {
    title: jobTitle.value,
    description: jobDescription.value,
    tags: selectedTags.value,
  };
  console.log("Submitting job post:", formData);
  // Here you would typically send the data to your backend API
  alert("Job post submitted! Check the console for the form data.");

  // Reset the form
  jobTitle.value = "";
  jobDescription.value = "";
  selectedTags.value = [];
};
</script>

<template>
  <div class="p-8 text-white min-h-screen flex items-center justify-center">
    <div class="max-w-4xl w-full bg-gray-800 p-8 rounded-2xl shadow-lg animate-fade-in-up">
      <h1 class="text-4xl font-extrabold text-center mb-8">
        <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">
          Post a New Job
        </span>
      </h1>
      
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <div>
          <label for="jobTitle" class="block text-gray-300 font-semibold mb-2">Job Title</label>
          <input
            id="jobTitle"
            v-model="jobTitle"
            type="text"
            required
            class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="e.g., Senior Full Stack Developer"
          />
        </div>
        
        <div>
          <label for="jobDescription" class="block text-gray-300 font-semibold mb-2">Job Description</label>
          <textarea
            id="jobDescription"
            v-model="jobDescription"
            rows="6"
            required
            class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Provide a detailed description of the role, responsibilities, and qualifications."
          ></textarea>
        </div>

        <div>
          <label for="tags" class="block text-gray-300 font-semibold mb-2">Required Skills / Tags</label>
          
          <!-- Selected Tags Display -->
          <div v-if="selectedTags.length" class="flex flex-wrap gap-2 mb-4">
            <span
              v-for="tag in selectedTags"
              :key="tag"
              class="flex items-center bg-blue-500 text-white text-sm font-medium px-3 py-1 rounded-full shadow-md"
            >
              {{ tag }}
              <button
                type="button"
                @click="removeTag(tag)"
                class="ml-2 text-white hover:text-gray-200 transition-colors"
              >
                <XMarkIcon class="h-4 w-4" />
              </button>
            </span>
          </div>

          <!-- Tags Search Input and Dropdown -->
          <div class="relative">
            <input
              id="tags"
              v-model="searchTerm"
              @focus="showTagsDropdown = true"
              @blur="setTimeout(() => showTagsDropdown = false, 200)"
              type="text"
              class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white border border-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="Search for tags..."
            />
            
            <div
              v-if="showTagsDropdown && filteredTags.length"
              class="absolute z-10 w-full mt-2 bg-gray-700 rounded-lg shadow-xl border border-gray-600 max-h-48 overflow-y-auto"
            >
              <ul class="py-1">
                <li
                  v-for="tag in filteredTags"
                  :key="tag"
                  @mousedown.prevent="addTag(tag)"
                  class="px-4 py-2 cursor-pointer hover:bg-gray-600 text-gray-300"
                >
                  {{ tag }}
                </li>
              </ul>
            </div>
            <p v-if="filteredTags.length === 0 && searchTerm" class="mt-2 text-gray-400 text-sm">No matching tags found.</p>
          </div>
        </div>

        <!-- Submit Button -->
        <div class="pt-4">
          <button
            type="submit"
            class="w-full py-3 rounded-full font-bold bg-blue-600 hover:bg-blue-700 transition transform hover:scale-105 shadow-lg"
          >
            Post Job
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
/* Scoped styles to ensure animations and other classes don't affect other components */
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
