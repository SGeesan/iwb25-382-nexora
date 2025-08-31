// src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import LoginPage from '../views/LoginPage.vue'
import HomeView from '../views/HomeView.vue'
import NotFoundView from '../views/NotFoundView.vue'
import ForbiddenView from '../views/ForbiddenView.vue'
import RegisterPage from '../views/RegisterPage.vue'
import CVUpload from '../views/CVUpload.vue'
import ProfileSection from '../views/ProfileSection.vue'
import PostJob from '../views/PostJobs.vue'
import CompanyHome from '../views/CompanyHome.vue'
import SearchJobs from '../views/ShowJobs.vue'
import DocUpload from '../views/DocUpload.vue'
import AdminHome from '../views/AdminHome.vue'

// Helper to decode JWT payload
function parseJwt(token) {
  try {
    const base64Url = token.split('.')[1]
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/')
    const jsonPayload = decodeURIComponent(
      atob(base64)
        .split('')
        .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
        .join('')
    )
    return JSON.parse(jsonPayload)
  } catch (e) {
    console.error('Invalid JWT:', e)
    return null
  }
}

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'root',
      component: LoginPage,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    },
    {
      path: '/login',
      name: 'login',
      component: LoginPage,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    },
    {
      path: '/home',
      name: 'home',
      component: HomeView,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['user', 'admin']
      }
    },
    {
      path: '/upload',
      name: 'upload',
      component: CVUpload,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['user', 'admin']
      }
    },
    {
      path: '/jobs',
      name: 'jobs',
      component: SearchJobs,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['user']
      }
    },
    {
      path: '/company-home',
      name: 'company-home',
      component: CompanyHome,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['company']
      }
    },
    {
      path: '/upload-docs',
      name: 'DocUpload',
      component: DocUpload,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['company']
      }
    },
    {
      path: '/admin-dashboard',
      name: 'admin-dashboard',
      component: AdminHome,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['admin']
      }
    },
    {
      path: '/post-jobs',
      name: 'post-jobs',
      component: PostJob,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['company']
      }
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      // component: AdminDashboardView,
      component: HomeView,
      meta: {
        hideSidebar: false,
        hideTopNav: false,
        hidePlayer: false,
        requiresAuth: true,
        allowedRoles: ['admin']
      }
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterPage,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    },
    {
      path: '/profile',
      name: 'profile',
      component: ProfileSection,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    },
    {
      path: '/forbidden',
      name: 'forbidden',
      component: ForbiddenView,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: NotFoundView,
      meta: {
        hideSidebar: true,
        hideTopNav: true,
        hidePlayer: true,
        requiresAuth: false
      }
    }
  ]
})

// Global Navigation Guard
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('jwt_token')
  let userRole = null

  if (token) {
    const payload = parseJwt(token)
    if (payload) {
      // Adjust 'role' if your JWT uses a different claim name, e.g. 'roles' or inside nested objects
      userRole = payload.role || null
    } else {
      // Invalid token, clear storage
      localStorage.removeItem('jwt_token')
    }
  } else {
    // No token, ensure cleared
    localStorage.removeItem('jwt_token')
  }

  // Check if the route requires authentication
  if (to.meta.requiresAuth) {
    if (!token) {
      // Not authenticated → redirect to login
      console.log(`Access denied: Route ${to.path} requires authentication. Redirecting to login.`)
      next({ name: 'login' })
    } else {
      // Authenticated, check roles if specified
      if (to.meta.allowedRoles && to.meta.allowedRoles.length > 0) {
        if (userRole && to.meta.allowedRoles.includes(userRole)) {
          // Role allowed → proceed
          console.log(`Access granted: User role '${userRole}' is allowed on ${to.path}.`)
          next()
        } else {
          // Role not allowed → forbidden
          console.warn(`Access denied: User role '${userRole}' not allowed on ${to.path}. Redirecting to forbidden.`)
          next({ name: 'forbidden' })
        }
      } else {
        // No role restriction, proceed
        console.log(`Access granted: Route ${to.path} requires authentication, no specific roles needed.`)
        next()
      }
    }
  } else {
    // No authentication required
    if (to.name === 'login' && token) {
      // Already authenticated, redirect from login to home
      console.log(`Already authenticated. Redirecting from login page to home.`)
      next({ name: 'home' })
    } else {
      // Proceed normally
      console.log(`Proceeding to public route: ${to.path}.`)
      next()
    }
  }
})

export default router
