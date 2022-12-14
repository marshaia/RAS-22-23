import { createRouter, createWebHistory } from "vue-router";

// you need to do npm install vue-router

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      component: () => import("./views/HomePage.vue"),
      name: "home",
    },
    {
      path: "/login",
      component: () => import("./views/LoginPage.vue"),
      name: "login",
    },
    {
      path: "/profile",
      component: () => import("./views/Profile.vue"),
      name: "profile",
    },
    {
      path: "/register",
      component: () => import("./views/Register.vue"),
      name: "register",
    },
  ],
});

export default router;
