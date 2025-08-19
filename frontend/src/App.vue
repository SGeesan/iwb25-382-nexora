<script setup>
import { ref, onMounted, watch } from 'vue'
import { RouterLink, RouterView, useRoute, useRouter } from 'vue-router'
import { jwtDecode } from 'jwt-decode'
import MenuItem from './components/MenuItem.vue';

import ChevronUp from 'vue-material-design-icons/ChevronUp.vue';
import ChevronDown from 'vue-material-design-icons/ChevronDown.vue';
import Menu from 'vue-material-design-icons/Menu.vue';
import Close from 'vue-material-design-icons/Close.vue';

let openMenu = ref(false)
let showMobileNav = ref(false)
let userRole = ref(null)
let userName = ref(null)

const route = useRoute()
const router = useRouter()

const hideSidebar = () => route.meta.hideSidebar || false;
const hideTopNav = () => route.meta.hideTopNav || false;

const getUserInfo = () => {
  const token = localStorage.getItem('jwt_token');
  if (token) {
    try {
      const decodedToken = jwtDecode(token);
      userRole.value = decodedToken.role;
      userName.value = decodedToken.user_name || 'User';
      console.log('Decoded user role:', userRole.value);
      console.log('Decoded user name:', userName.value);
    } catch (error) {
      console.error('Failed to decode token:', error);
      localStorage.removeItem('jwt_token');
      userRole.value = null;
      userName.value = null;
    }
  } else {
    userRole.value = null;
    userName.value = null;
  }
}

const logout = () => {
  localStorage.removeItem('jwt_token');
  userRole.value = null;
  userName.value = null;
  router.push('/login');
}

watch(
  () => route.fullPath,
  () => {
    getUserInfo();
    showMobileNav.value = false; // Close the mobile nav on route change
  }
);

onMounted(() => {
  getUserInfo();
});
</script>

<template>
  <div class="min-h-screen bg-black">
        <div 
      v-if="showMobileNav && !hideSidebar()" 
      id="MobileSideNav" 
      class="fixed inset-y-0 left-0 h-full w-[240px] z-50 p-6 bg-black transform transition-transform duration-300 md:hidden"
    >
      <RouterLink to="/home">
        <img width="180" src="/images/icons/logo.png">
      </RouterLink>
      <div class="my-8"></div>
      <ul>
        <!-- User -->
        <RouterLink v-if="userRole === 'user'" to="/home">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Home" iconString="home" pageUrl="/home" />
        </RouterLink>
        

        <!-- Company -->
        <RouterLink v-if="userRole === 'company'" to="/company-home">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Home" iconString="home" pageUrl="/company-home" />
        </RouterLink>

        <RouterLink v-if="userRole === 'company'" to="/post-jobs">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Post Job" iconString="home" pageUrl="/post-jobs" />
        </RouterLink>



        <RouterLink v-if="userRole === 'user'" to="/upload">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Upload CV" iconString="pdf" pageUrl="/upload" />
        </RouterLink> 

        <RouterLink v-if="userRole === 'admin'" to="/admin-dashboard">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Admin Dashboard" iconString="settings" pageUrl="/admin-dashboard" />
        </RouterLink>

        <RouterLink v-if="userRole === 'admin'" to="/admin-dashboard">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Admin Dashboard" iconString="settings" pageUrl="/admin-dashboard" />
        </RouterLink>

      </ul>
    </div>

        <div v-if="!hideSidebar()" id="SideNavDesktop" class="h-full p-6 w-[240px] fixed z-50 bg-black hidden md:block">
      <RouterLink to="/home">
        <img width="180" src="/images/icons/logo.png">
      </RouterLink>
      <div class="my-8"></div>
      <ul>
        <!-- User -->
        <RouterLink v-if="userRole === 'user'" to="/home">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Home" iconString="home" pageUrl="/home" />
        </RouterLink>

        <RouterLink v-if="userRole === 'user'" to="/upload">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Upload CV" iconString="pdf" pageUrl="/upload" />
        </RouterLink> 
        

        <!-- Company -->
        <RouterLink v-if="userRole === 'company'" to="/company-home">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Home" iconString="home" pageUrl="/company-home" />
        </RouterLink>

        <RouterLink v-if="userRole === 'company'" to="/post-jobs">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Post Job" iconString="home" pageUrl="/post-jobs" />
        </RouterLink>



        <RouterLink v-if="userRole === 'admin'" to="/admin-dashboard">
          <MenuItem class="ml-[1px]" :iconSize="23" name="Admin Dashboard" iconString="settings" pageUrl="/admin-dashboard" />
        </RouterLink>

      </ul>
    </div>
    
        <div
      v-if="!hideTopNav()"
      id="TopNav"
      class="w-full md:w-[calc(100%-240px)] h-[60px] fixed right-0 z-20 bg-[#101010] bg-opacity-80 flex items-center justify-between"
      style="background-color: rgba(16, 16, 16, 0.8); backdrop-filter: blur(10px);"
    >
      <div class="flex items-center ml-6">
                <button v-if="!hideSidebar()" @click="showMobileNav = !showMobileNav" class="md:hidden">
          <Menu v-if="!showMobileNav" fillColor="#FFFFFF" :size="25" />
          <Close v-else fillColor="#FFFFFF" :size="25" />
        </button>
      </div>

      <button @click="openMenu = !openMenu" :class="openMenu ? 'bg-[#282828]' : 'bg-black'"
        class="bg-black hover:bg-[#282828] rounded-full p-0.5 mr-8 mt-0.5 cursor-pointer">
        <div class="flex items-center">
          <div class="text-white text-[14px] ml-1.5 font-semibold">{{ userName || 'Guest' }}</div>
          <ChevronDown v-if="!openMenu" fillColor="#FFFFFF" :size="25" />
          <ChevronUp v-else fillColor="#FFFFFF" :size="25" />
        </div>
      </button>

      <span v-if="openMenu"
        class="fixed w-[190px] bg-[#282828] shadow-2xl z-50 rounded-sm top-[52px] right-[35px] p-1 cursor-pointer">
        <ul class="text-gray-200 font-semibold text-[14px]">

            <router-link to="/profile">
              <li class="px-3 py-2.5 hover:bg-[#3E3D3D]">
                  Profile
              </li></router-link>
          
          <li @click="logout()" class="px-3 py-2.5 hover:bg-[#3E3D3D]">Log out</li>
          
        </ul>
      </span>
    </div>

        <div
      :class="{ 'w-full': hideSidebar(), 'w-full md:w-[calc(100%-240px)]': !hideSidebar() }"
      class="fixed right-0 top-0 overflow-auto h-full bg-gradient-to-b from-[#000] to-black"
    >
      <div v-if="!hideTopNav()" class="mt-[70px]"></div>
      <RouterView />
    </div>
  </div>
</template>

<style scoped>
/* No specific custom styles needed for App.vue, Tailwind handles it */
</style>